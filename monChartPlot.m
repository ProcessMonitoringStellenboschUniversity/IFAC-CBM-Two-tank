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

%% Combining the monitoring chart plots
% This function combines the monitoring charts geenrated before the 
% first fault and before the second fault 

function monChartPlot(nocData, nocData2, faultMon, faultMon2,tInit, tOffline, TOF)

% Offline data
xOffline1 = TOF(1):(TOF(1)+tOffline(1));
dataOffline1 = zeros(length(xOffline1),4);

xOffline2 = TOF(2):(TOF(2)+tOffline(2));
dataOffline2 = zeros(length(xOffline2),4);

% Concatenate SPE data


% plotting SPE overall
figure;
plot(nocData.tNOC, nocData.NOCspe, 'b-');
hold on
plot(faultMon.tfaultDelay, faultMon.speFaultDelay, 'm-'); 
hold on
plot(nocData2.tNOC, nocData2.NOCspe, 'b-');
hold on
plot(faultMon2.tfaultDelay, faultMon2.speFaultDelay, 'm-');
hold on
plot([nocData.tNOC(1) faultMon2.tfaultDelay(end)], [SPEcrit SPEcrit], 'r--');
xlim([tInit faultMon2.tfaultDelay(end)]);
ylim([0 5]);
xlabel('Time (min)');
ylabel('Squared prediction error');
hold off

% plotting MHT overall
figure;
plot(nocData.tNOC, nocData.NOCmht, 'b-');
hold on
plot(faultMon.tfaultDelay, faultMon.mhtFaultDelay, 'm-');
hold on
plot(nocData2.tNOC, nocData2.NOCmht, 'b-');
hold on
plot(faultMon2.tfaultDelay, faultMon2.mhtFaultDelay, 'm-');
hold on
plot([nocData.tNOC(1) faultMon2.tfaultDelay(end)], [MHTcrit MHTcrit], 'r--');
xlim([tInit faultMon2.tfaultDelay(end)]);
ylim([0 30]);
xlabel('Time (min)');
ylabel('Modified Hotellings T-statistic');
hold off

end