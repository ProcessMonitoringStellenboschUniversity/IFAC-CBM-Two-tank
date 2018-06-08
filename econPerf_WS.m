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

%% Economic performance function - for incorrect sensor replacement
% This function determines the profit of the process over time, including
% the effect of downtime, and sensor replacement.

function totProfit = econPerf_WS(tOffline, TOF, tSim, newSens, econVars, tInit)

tempSens_price = 200; % USD ($1 = R14)
lvlSens_price = 250; % USD
labour_price = 2.86; % USD per hour
lps_price =  0.35; % USD per hour

% Calculating the costs that make up expenses
% Sensor replacement cost

if newSens == 1
    expSens = tempSens_price;
else
    expSens = lvlSens_price;
end

% Steam, labour and sensor cost
expSensDiv = zeros(length((TOF+tOffline+tInit):tSim),1);
expStm = zeros(length((TOF+tOffline+tInit):tSim),1);
expLab = zeros(length((TOF+tOffline+tInit):tSim),1);

for i = 1:length(TOF:TOF+tOffline+tInit)
   expStm(i) = 0; 
   expLab(i) = labour_price/60;
   expSensDiv(i) = expSens/(length(TOF:TOF+tOffline+tInit));
end
for i = length(TOF:TOF+tOffline+tInit):length((TOF+tOffline+tInit):tSim)
   expStm(i) =  lps_price/60; % Steam cost per minute throughout simulation
   expLab(i) = 0;
   expSensDiv(i) = 0;
end

expense = expSensDiv + expLab + expStm;

incT1 = zeros(length((TOF+tOffline+tInit):tSim),1);
incT2 = zeros(length((TOF+tOffline+tInit):tSim),1);
incTot = zeros(length((TOF+tOffline+tInit):tSim),1);

% Calculating income
for i = 1:length(TOF:TOF+tOffline+tInit) 
        incT1(i) = 0; % If the process is shut down, zero income is made.
        incT2(i) = 0;
        incTot(i) = incT1(i) + incT2(i);
end
for i = length(TOF:TOF+tOffline+tInit):length((TOF+tOffline+tInit):tSim)
    if econVars.T1(i) <= 85 && econVars.T1(i) >= 75 % USD 7 is earned per hour of producing water within correct T range
        incT1(i) = 7/60;
    else
        incT1(i) = 0; % If limits are exceeded no income is made
    end
    if econVars.T2(i) <= 90 && econVars.T2(i) >= 80 % if T2 is within the desired range, get paid
        incT2(i) = 7/60;
    else
        incT2(i) = 0; 
    end
    incTot(i) = incT1(i) + incT2(i);
end

profit = zeros(length((TOF+tOffline+tInit):tSim),1);
for i = 1: length((TOF+tOffline+tInit):tSim)
    profit(i) = incTot(i) - expense(i);
end
figure;
plot((1:length((TOF+tOffline+tInit):tSim)), profit);
totProfit = sum(profit,1);
fprintf('Total profit ws: R %.2f\n', totProfit);
end