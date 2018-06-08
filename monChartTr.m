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

%% Monitoring chart plotting function - for first fault
% This function determines and plots the monitoring statistics of the MHT
% and the SPE, including NOC training data, testing data, and faulty data.

function [nocData, faultMonData, monChartTrMHT, monChartTrSPE] = monChartTr(ttrain, ttest, MHT, tFaultDet, tInit, MHTcrit, SPEtot, SPEcrit, smDelay, tSim, tFaultAct)

% Train data
NOCtrain = MHT(ttrain,1);
NOCtrainQ = SPEtot(ttrain,:);

% Test data
NOCtest = MHT(ttest,:);
NOCtestQ = SPEtot(ttest,:);

% Normal operation
tOp = ttest(end):tFaultDet; % - smDelay
% tNOC = ttest(end):tFaultAct;
NOCnormMHT = MHT(tOp,1);
NOCnormQ = SPEtot(tOp,1);
nocData = struct('NOCmht', NOCnormMHT, 'NOCspe', NOCnormQ, 'tNOC', tOp);

% ---- Fault data ----
% For plotting purposes
tfaultDelay = tFaultDet-smDelay:tSim; % changed for poster tFaultDet-smDelay:tFaultDet;
mhtFaultDelay = MHT(tfaultDelay,:);
speFaultDelay = SPEtot(tfaultDelay,:);

% For calculating DD and MAR
tfaultActDet = tFaultAct:tFaultDet;
mhtFaultAD = MHT(tfaultActDet);
speFaultAD = SPEtot(tfaultActDet);
faultMonData = struct('mhtFaultAD', mhtFaultAD, 'speFaultAD', speFaultAD,'mhtFaultDelay', mhtFaultDelay, 'speFaultDelay', speFaultDelay, 'tfaultDelay', tfaultDelay, 'tfaultAD', tfaultActDet, 'tFaultDet1', tFaultDet);

% Plot monitoring chart for MHT - plotting every 6 hours --- POSTER
% modified
figure;
tr = plot(ttrain(1: 10 : length(ttrain)), NOCtrain(1: 10 : length(NOCtrain)), 'k-'); 
hold on
te = plot(ttest(1: 10 : length(ttest)), NOCtest(1: 10 : length(NOCtest)), 'g-') ;
hold on
op = plot(tOp(1: 10 : length(tOp)), NOCnormMHT(1: 10 : length(NOCnormMHT)), 'b-') ;
hold on
plot(tfaultDelay(1: 10 : length(tfaultDelay)),mhtFaultDelay(1: 10 : length(mhtFaultDelay)), '-c')
hold on
det = plot([tFaultDet tFaultDet], [0 max(mhtFaultDelay)], 'm-', 'Linewidth',2);
hold on
lim = plot([tInit tSim], [MHTcrit MHTcrit],'--r', 'Linewidth',2);
ylim([0 100])
xlim([tInit tSim])
% xticks([0 2000 4000 6000 8000 10000]);
% xticklabels({'0', '2', '4', '6', '8', '10'})
xlabel('Time (weeks)')
legend([tr, te,op,det,lim],{'NOC train', 'NOC test', 'NOC data', 'Fault detection', 'Threshold'})
ylabel('Modified Hotelling T-statistic')
hold off

monChartTrMHT = struct('ttrain', ttrain, 'NOCtrain', NOCtrain, 'ttest', ttest, 'NOCtest', NOCtest,'tOp',tOp,'NOCnormMHT', NOCnormMHT,'tfaultDelay', tfaultDelay, 'mhtFaultDelay', mhtFaultDelay, 'tFaultDet1', tFaultDet);

% Plot monitoring chart for SPE - every 6 hours
figure;
trQ = plot(ttrain(1: 10 : length(ttrain)), NOCtrainQ(1: 10 : length(NOCtrainQ)), 'k-') ;
hold on
teQ = plot(ttest(1: 10 : length(ttest)), NOCtestQ(1: 10 : length(NOCtestQ)), 'g-') ;
hold on
opQ = plot(tOp(1: 10 : length(tOp)), NOCnormQ(1: 10 : length(NOCnormMHT)), 'b-') ;
hold on
plot(tfaultDelay(1: 10 : length(tfaultDelay)),speFaultDelay(1: 10 : length(speFaultDelay)), '-c')
hold on
deQ = plot([tFaultDet tFaultDet], [0 max(speFaultDelay)], 'm-', 'Linewidth',2);
hold on
limQ = plot([tInit tSim], [SPEcrit SPEcrit],'--r');
ylim([0 8])
xlim([tInit tSim])
% xticks([0 20160 40320 60480 80640 100800 tSim]);
% xticklabels({'0', '2', '4', '6', '8', '10', '12'})
xlabel('Time (weeks)')
legend([trQ, teQ,opQ,deQ,limQ],{'NOC train', 'NOC test', 'NOC data', 'Fault detection', 'Threshold'})
ylabel('Squared prediction error')
hold off

monChartTrSPE = struct('ttrain', ttrain, 'NOCtrainQ', NOCtrainQ, 'ttest', ttest, 'NOCtestQ', NOCtestQ,'tOp',tOp,'NOCnormQ', NOCnormQ,'tfaultDelay', tfaultDelay, 'speFaultDelay', speFaultDelay, 'tFaultDet1', tFaultDet);


end