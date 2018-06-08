%% Two-tank model and simulation


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

%% Monitoring chart after a restart
% This function plots the monitoring charts for MHT and SPE after a shut
% down after a fault condition. The time periods used are the NOC time
% before the fault, and the time period when the fault is actually included to
% the time the fault is detected.

function [nocStatsData, faultMonData] = monChartF(MHT, tFaultDet, tInit, tFaultAct, MHTcrit, SPE, SPEcrit, tRestart, smDelay, monChartTrMHT, monChartTrSPE, tSim)

% The data for the time period before the actual fault
tNOC = tRestart+tInit:tFaultAct;
tNOC2 = tInit:tFaultAct-tRestart;
mhtNOC = MHT(tNOC2,:);
speNOC = SPE(tNOC2,:);
nocStatsData = struct('NOCmht', mhtNOC, 'NOCspe', speNOC, 'tNOC', tNOC);

% The fault data between when the fault actually happened and when it was
% detected

% For plotting purposes
tfaultDelay = tFaultDet-smDelay:tFaultDet;
tfaultDelay2 = tFaultDet-smDelay-tRestart:tFaultDet-tRestart;
mhtFaultDelay = MHT(tfaultDelay2,:);
speFaultDelay = SPE(tfaultDelay2,:);

% For calculating DD and MAR
tfaultActDet = tFaultAct:tFaultAct+(tFaultDet-tFaultAct);
tfaultActDet2 = tFaultAct-tRestart: tFaultDet-tRestart;
mhtFaultAD = MHT(tfaultActDet2);
speFaultAD = SPE(tfaultActDet2);
faultMonData = struct('mhtFaultAD', mhtFaultAD, 'speFaultAD', speFaultAD, 'tfaultAD', tfaultActDet, 'tfaultDelay', tfaultDelay, 'mhtFaultDelay', mhtFaultDelay, 'speFaultDelay', speFaultDelay);

% Plotting the data sets
    % MHT %
figure;
tr = plot(monChartTrMHT.ttrain(1:360:length(monChartTrMHT.ttrain)), monChartTrMHT.NOCtrain(1:360:length(monChartTrMHT.ttrain)), 'k-');
hold on
te = plot(monChartTrMHT.ttest(1:360:length(monChartTrMHT.ttest)), monChartTrMHT.NOCtest(1:360:length(monChartTrMHT.ttest)), 'g-');
hold on
op = plot(monChartTrMHT.tOp(1:360:length(monChartTrMHT.tOp)), monChartTrMHT.NOCnormMHT(1:360:length(monChartTrMHT.NOCnormMHT)), 'b-');
hold on
plot(monChartTrMHT.tfaultDelay(1:360:length(monChartTrMHT.tfaultDelay)), monChartTrMHT.mhtFaultDelay(1:360:length(monChartTrMHT.mhtFaultDelay)), 'b-');
hold on
det = plot([monChartTrMHT.tFaultDet1 monChartTrMHT.tFaultDet1], [0 max(monChartTrMHT.mhtFaultDelay)], '-m', 'Linewidth', 2);
hold on
plot(tNOC(1:360:length(tNOC)), mhtNOC(1:360:length(mhtNOC)), 'b-');
hold on
plot(tfaultDelay(1:360:length(tfaultDelay)), mhtFaultDelay(1:360:length(mhtFaultDelay)), 'b-');
hold on
plot([tFaultDet tFaultDet], [0 max(mhtFaultDelay)], 'm-', 'Linewidth',2);
hold on
lim = plot([0 tSim], [MHTcrit MHTcrit], 'r--', 'Linewidth', 2);
xlim([tInit tSim]);
ylim([0 30]);
xlabel('Time (weeks)');
xticks([0 20160 40320 60480 80640 100800 tSim]);
xticklabels({'0', '2', '4', '6', '8', '10', '12'})
legend([tr, te,op,det,lim],{'NOC train', 'NOC test', 'NOC data', 'Fault detection', 'Threshold'})
ylabel('Modified Hotellings T-statistic');
hold off


    % SPE %
figure;
trQ = plot(monChartTrSPE.ttrain(1:360:length(monChartTrSPE.ttrain)), monChartTrSPE.NOCtrainQ(1:360:length(monChartTrSPE.NOCtrainQ)), 'k-');
hold on
teQ = plot(monChartTrSPE.ttest(1:360:length(monChartTrSPE.ttest)), monChartTrSPE.NOCtestQ(1:360:length(monChartTrSPE.NOCtestQ)), 'g-');
hold on
opQ = plot(monChartTrSPE.tOp(1:360:length(monChartTrSPE.tOp)), monChartTrSPE.NOCnormQ(1:360:length(monChartTrSPE.NOCnormQ)), 'b-');
hold on
plot(monChartTrSPE.tfaultDelay(1:360:length(monChartTrSPE.tfaultDelay)), monChartTrSPE.speFaultDelay(1:360:length(monChartTrSPE.speFaultDelay)), 'b-');
hold on
deQ = plot([monChartTrSPE.tFaultDet1 monChartTrSPE.tFaultDet1], [0 max(monChartTrSPE.speFaultDelay)], 'm-', 'Linewidth', 2);
hold on
plot(tNOC(1:360:length(tNOC)), speNOC(1:360:length(speNOC)), 'b-');
hold on
plot(tfaultDelay, speFaultDelay, 'b-'); 
hold on
plot([tFaultDet tFaultDet], [0 4], 'm-', 'Linewidth', 2);
hold on
limQ = plot([0 tSim], [SPEcrit SPEcrit], 'r--', 'Linewidth',2);
xlim([tInit tSim]);
ylim([0 4]);
xlabel('Time (weeks)');
xticks([0 20160 40320 60480 80640 100800 tSim]);
xticklabels({'0', '2', '4', '6', '8', '10', '12'})
legend([trQ, teQ,opQ,deQ,limQ],{'NOC train', 'NOC test', 'NOC data', 'Fault detection', 'Threshold'})
ylabel('Squared prediction error');
hold off

end