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

%% Plot final run results function
% This function puts together the results from the different simulations
% into one plot

function [finalMV, finalCV] = finalPlot_WS(TOF, tOffline, b4IntData, b4Fault1Data, b4Fault2Data, aftF2Data, tSim, tTotInit)


% Offline data
xOffline1 = TOF(1)+1:(TOF(1)+tOffline(1));
dataOffline1 = zeros(length(xOffline1),4); % after first fault

xOffline2 = TOF(2)+1:(TOF(2)+tOffline(2));
dataOffline2 = zeros(length(xOffline2),4); % after second fault

xOffline3 = TOF(3)+1:(TOF(3)+tOffline(3));
dataOffline3 = zeros(length(xOffline3),4); % after wrong sensor

% Concatenate MVs
finalMV = vertcat(b4Fault1Data(:,1:4),dataOffline1, b4Fault2Data(:,1:4), dataOffline2, b4IntData(:, 1:4), dataOffline3,aftF2Data(:,1:4));
finalCV = vertcat(b4Fault1Data(:,5:8),dataOffline1, b4Fault2Data(:,5:8), dataOffline2, b4IntData(:, 5:8), dataOffline3, aftF2Data(:,5:8));

figure;
plot(finalMV(1:360:length(finalMV), 1:4))
xlabel('Time (weeks)');
xlim([0 length(finalMV)/360]);
xticks([0 20160/360 40320/360 60480/360 80640/360 100800/360 length(finalMV)/360]);
xticklabels({'0', '2', '4', '6', '8', '10', '12'})
ylabel('Flow rate (m^3/min)');
legend('F1','F2','F3','F4','Location','southeast');

figure;
subplot(2,1,1);
plot(finalCV(1:360:length(finalCV),[1 3]))
xlabel('Time (weeks)');
xlim([0 length(finalCV)/360]);
xticks([0 20160/360 40320/360 60480/360 80640/360 100800/360 length(finalCV)/360]);
xticklabels({'0', '2', '4', '6', '8', '10', '12'})
ylabel('Level (m)');
legend('L1','L2','Location','southeast');

subplot(2,1,2)
plot(finalCV(1:360:length(finalCV),[2 4]))
xlabel('Time (weeks)');
xlim([0 length(finalCV)/360]);
xticks([0 20160/360 40320/360 60480/360 80640/360 100800/360 length(finalCV)/360]);
xticklabels({'0', '2', '4', '6', '8', '10', '12'})
ylabel('Temperature (^oC)');
legend('T1','T2','Location','southeast');
end