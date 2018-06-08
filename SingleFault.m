%% Two-tank model and simulation (Single fault condition)

% Based on model described in Lindner (2014), available at
% http://scholar.sun.ac.za/handle/10019.1/95987

% Developed by A Kerremans and L Auret, 2017
% Updated by JT McCoy, 2018
% Submitted to Safe Process, 2018

% Copyright (C) 2017, 2018, 2019 L Auret, A Kerremans, JT McCoy
% Contact: lauret@sun.ac.za

% This file is part of the Two Tank Simulator program.

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%     
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%  
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% SingleFault.m

% Main code to load data for a single fault simulated in paper, or to
% generate fresh data from the Simulink model

%% Initialise work space

% // One fault condition

% // All time units are in MINUTES

% *** -- You can change these values

close all; clear; clc;

% 3-month simulation run time parameters
tSim = 120960;       % Total simulation time
tInit = 400;        % Initialisation time
tData = 40320;       % Data length used for PCA training - 1 month
sys = 'TTankModel';

% *** Number of consecutive alarms = interlock activation 
intDelay = 20;

load_system(sys);

[ssOut,sizeStep_Gc11,sizeStep_Gc23,sizeStep_Gc32,sizeStep_Gc44,tStep_Gc11,tStep_Gc23,tStep_Gc32,tStep_Gc44] = steadyStateSet(sys, tSim);
sim(sys);
set_param(strcat(sys,'/Fault Detection/PCA_apply'), 'Commented', 'off');
set_param(strcat(sys,'/Fault Detection/NOC_data'), 'Commented', 'on');
fprintf('Steady state parameters set!\n');
sysData = denoise(NOC.data);    
sysData = NOC.data;

% *** Set the number of consecutive alarms = fault
smDelay = 6;

% ----- Train PCA Model and check -----
% Specify time period of training

ttrain = tInit+1:(0.9*tData); 
ttest = (ttrain(end)+1):tData;

% Load the NOC data only for the training time period
Xu_train = sysData(ttrain,:);
outTr = TTankModel_PCAtrainFunc(Xu_train);

% Check training has completed successfully
sim(sys);

if sum(FaultDetect(ttest))/length(ttest) <= 0.1  % Check false alarm rate for Simulink result
    fprintf('PCA model successfully trained!\nFAR is below 1%% = %d\n',sum(FaultDetect(ttrain(end):ttest(end)))/length(ttest))
else
    fprintf('Training error!\n')
end
[cPlotLimit, cPlotTr] = cPlotTrain(ttrain, SPE_total, SPE_all);

%% Single fault condition

set_param(sys,'StopTime', num2str(tSim));
set_param(sys, 'StartTime', '0.0');

% Choose whether a baseline or CBM simulation must occur

reply = input('Baseline simulation? [Y/N]: \n', 's');

if upper(reply) == 'Y'
    baseline = 1; 
elseif upper(reply) == 'N'
    baseline = 0;
else
    baseline = 1;
end

% *** Define the fault time step and the bias of the faulty sensor

sensFail = str2double(input('Which sensor fails? [1 = L1 / 2 = T1 / 3 = L2 / 4 = T2]: \n', 's'));
sensStep = str2double(input('Enter sensor bias (L [=] m, T [=] C): \n', 's'));
sensTime = str2double(input('When does the sensor fail? (time in minutes): \n', 's'));

[sizeStep_Gc11,sizeStep_Gc23,sizeStep_Gc32,sizeStep_Gc44,...
    tStep_Gc11,tStep_Gc23,tStep_Gc32,tStep_Gc44] = faultCond(sensFail, sensStep, sensTime);

sensors = [sizeStep_Gc11 tStep_Gc11; sizeStep_Gc23 tStep_Gc23;sizeStep_Gc32 tStep_Gc32;sizeStep_Gc44 tStep_Gc44];
sensBias = [sizeStep_Gc11; sizeStep_Gc23; sizeStep_Gc32; sizeStep_Gc44];
faultNo = nnz(sensBias);    % Determine the number of faults to be simulated

intb4flt = 0;
tRestart = 0;
count = 0;
wrongSens = 0;

while faultNo > 0
    count = count + 1;
    fprintf('Starting iteration no.: %d\n', count);
    
    sensors = [sizeStep_Gc11 tStep_Gc11; sizeStep_Gc23 tStep_Gc23;sizeStep_Gc32 tStep_Gc32;sizeStep_Gc44 tStep_Gc44];
    sensBias = [sizeStep_Gc11; sizeStep_Gc23; sizeStep_Gc32; sizeStep_Gc44];
    fprintf('No. of faults to be simulated: %d\n', faultNo);
    sim(sys);
    fprintf('Fault condition simulated!\n')
    
    
    % ----------- Fault/Interlock detection -----------
    
    if baseline == 1 || wrongSens == 1
        if count == 1
            tInterlock = TimeOfInt(IntData, ttest, count);
            b4IntData = FaultData(tInit:tInterlock-tRestart,:);
        else
            tInterlock = TimeOfInt(IntData, ttest, count);
            b4Int2Data = FaultData(tInterlock,:);
        end
    else
        [tFaultDetect, tFaultAct] = TimeOfFault(FaultDetect, sensors, tRestart); % time of failure detected and actual
        tInterlock = TimeOfInt(IntData,ttest, count);
%               
        if tInterlock < tFaultDetect  % check whether interlock happens before fault detected
            intb4flt = 1;
            fprintf('Interlock activated!\n')
            b4IntData =  FaultData(tInit:tInterlock,:);
        else
            intb4flt = 0;
            fprintf('Fault detected at %d\n', tFaultDetect)
            
          if count == 1  
    % --- Plot monitoring charts and determine performance metrics ---
            
            [nocData,faultMonData] = monChartTr(ttrain, ttest, MHTtotal,...
                tFaultDetect, tInit, outTr.MHTcrit, SPE_total, outTr.Qcrit, smDelay, tSim, tFaultAct);
                        
            [speStats, mhtStats] = detectStats(outTr.MHTcrit,...
                outTr.Qcrit,faultMonData,smDelay, nocData);
            
            fprintf('MHT statistics:\nDD: %d\nMA: %d\nFA: %d\n', mhtStats.mhtDD, mhtStats.mhtMAR, mhtStats.mhtFAR)
            fprintf('SPE statistics:\nDD: %d\nMA: %d\nFA: %d\n', speStats.speDD, speStats.speMAR, speStats.speFAR)
            
            % Save the data before the fault is detected
            
            b4FaultData = FaultData(tInit:tFaultDetect-tRestart,:);
         
          end
          
            % ------ Fault identification -------
            
            cPlotF = cPlotFault(tFaultDetect, SPE_all, SPE_total, cPlotTr,cPlotLimit, tRestart, smDelay);
            fprintf('Contribution plot generated!\n');
        end
    end

   
    % ----------- System restart -------------
    
    tShutDown = 240;
    tStartUp = 240;
    
    if baseline == 1 || intb4flt == 1          % baseline sim or interlock happens before fault
        tMaint = 4320;
        tOffline = tShutDown + tMaint + tStartUp;
        [tRestart, sens, newSens, repSens, sensTot] = StartUpInt(tOffline, tInterlock, sensBias, sensors);
        
    elseif wrongSens == 1                      % wrong sensor was replaced
        tMaintWS = 4320;
        tOfflineWS = tShutDown + tMaintWS + tStartUp;
        [tRestartWS, sens, newSens, repSens, sensTot] = StartUpInt_2(tOffline, tInterlock, sensBias, sensors);
    else                                       % else a fault has happened first
        tMaint = 1440;
        tOffline = tShutDown + tMaint + tStartUp;
        [tRestart,sens,newSens, repVar,sensTot] = StartUpFault(tOffline,tFaultDetect, cPlotF,sensBias, sensors);
    end
    
    % Replace the sensors
    sensors = sensTot;
    tStep_Gc11 = sensTot(1,2);
    tStep_Gc23 = sensTot(2,2);
    tStep_Gc32 = sensTot(3,2);
    tStep_Gc44 = sensTot(4,2);
    
    sensBias = sens;
    sizeStep_Gc11 = sensBias(1);
    sizeStep_Gc23 = sensBias(2);
    sizeStep_Gc32 = sensBias(3);
    sizeStep_Gc44 = sensBias(4);
    
    fprintf('Sensors replaced!\n');
    
    % ----------- Restart the simulation and save the data --------------
    
    set_param(sys, 'StartTime', num2str(tRestart));
    sim(sys);
    fprintf('System successfully restarted at time %d!\n', tRestart);
    
    if FaultDetect(tInit:tSim-tRestart) == 1
        fprintf('Incorrect sensor replaced!\n\n')
        wrongSens = 1;
    else
        aftF2Time = tInit:tSim-tRestart;    % time period after restart
        aftF2Data = FaultData(aftF2Time,:); % Saving all MV and CV data after a restart
        faultNo = faultNo - 1;
    end
    
    fprintf('End of iteration no. %d\n', count);
    if faultNo == 0
        break
    end
end
%% -------------- Plot final data result -------------
% Put together results to get final result responses

% Determine how much time is removed for initialisation period
tTotInit = (1 + faultNo)*tInit; 

if baseline == 1 || intb4flt == 1
    disp('% Plotting without CBM')
    [finalMV, finalCV] = finalPlot(tInterlock, tOffline, aftF2Data, b4IntData);
elseif wrongSens == 1
    disp('% Plotting with incorrect sensor replacement')
    [finalMV, finalCV] = finalPlot_WS([tFaultDetect tInterlock+tRestart], [tOffline tOfflineWS], b4Int2Data, b4FaultData, aftF2Data, tSim, tTotInit);
else
    disp('% Plotting with CBM')
    [finalMV, finalCV] = finalPlot(tFaultDetect, tOffline, aftF2Data, b4FaultData);
end

% ------------- Economic performance --------------

% Determining the profit over the course of the whole simulation
econVars = struct('T1', finalCV(:,2), 'T2', finalCV(:,4));
tSim = length(finalCV(:,2)); % remove effect of tInit sections

if baseline == 1 || intb4flt == 1
    disp('% Economic performance with no CBM')
    totProfit = econPerf(tOffline, tInterlock ,tSim,tInit, newSens, econVars);
elseif wrongSens == 1
    disp('% Economic performance where the wrong sensor is replaced')
    totProfit = econPerf_WS([tOffline tOfflineWS], [tFaultDetect tInterlock+tRestart] ,tSim, newSens, econVars, tTotInit, tInit);
else
    disp('% Economic performance with CBM')
    totProfit = econPerf(tOffline, tFaultDetect ,tSim,tInit, newSens, econVars);
end