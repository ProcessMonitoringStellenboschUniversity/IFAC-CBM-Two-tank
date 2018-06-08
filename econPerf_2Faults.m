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

%% Economic performance function
% This function determines the profit of the process over time, including
% the effect of downtime, and sensor replacement.

function totProfit = econPerf_2Faults(tOffline, TOF, tSim, newSens, econVars, tTotInit, tInit)
tempSens_price = 2800; % Rands
lvlSens_price = 3500; % Rands
labour_price = 40; % Rand per hour
lps_price =  4.95; % Rand per hour

% Calculating the costs that make up expenses
% Sensor replacement cost
expSens = zeros(1,2);
for i = 1:2
    if newSens(i) == 1
        expSens(i) = tempSens_price;
    else
        expSens(i) = lvlSens_price;
    end
end
% Steam, labour and sensor cost
expSensDiv = zeros(length(tTotInit:tSim),1);
expStm = zeros(length(tTotInit:tSim),1);
expLab = zeros(length(tTotInit:tSim),1);

for i = tInit: TOF(1)
   expStm(i) =  lps_price/60; % Steam cost per minute throughout simulation
   expLab(i) = 0;
   expSensDiv(i) = 0;
end
for i = TOF(1):(TOF(1)+tOffline(1)+tInit)
   expStm(i) = 0; 
   expLab(i) = labour_price/60;
   expSensDiv(i) = expSens(1)/60;
end
for i = (TOF(1)+tOffline(1)+tInit):TOF(2)
   expStm(i) =  lps_price/60; % Steam cost per minute throughout simulation
   expLab(i) = 0;
   expSensDiv(i) = 0;
end
for i = TOF(2):(TOF(2)+tOffline(2)+tInit)
   expStm(i) = 0; 
   expLab(i) = labour_price/60;
   expSensDiv(i) = expSens(2)/60;
end
for i = (TOF(2)+tOffline(2)+tInit):tSim
    expStm(i) = lps_price/60;
    expLab(i) = 0;
    expSensDiv(i) = 0;
end
expense = expSensDiv + expLab + expStm;
incT1 = zeros(tSim,1);
incT2 = zeros(tSim,1);
incTot = zeros(tSim,1);

% Calculating income
for i = tInit:TOF(1) 
    if econVars.T1(i) <= 85 && econVars.T1(i) >= 75 % if T1 is within the desired range, get paid
        incT1(i) = 90/60;
    else
        incT1(i) = 0; % If limits are exceeded no income is made
    end
    if econVars.T2(i) <= 90 && econVars.T2(i) >= 80 % if T2 is within the desired range, get paid
        incT2(i) = 90/60;
    else
        incT2(i) = 0; 
    end
    incTot(i) = incT1(i) + incT2(i);
end
for i = TOF(1):(TOF(1)+tOffline(1)+tInit) 
        incT1(i) = 0; % If the process is shut down, zero income is made.
        incT2(i) = 0;
        incTot(i) = incT1(i) + incT2(i);
end
for i = (TOF(1)+tOffline(1)+tInit):TOF(2)
    if econVars.T1(i) <= 85 && econVars.T1(i) >= 75 % if T1 is within the desired range, get paid
        incT1(i) = 90/60;
    else
        incT1(i) = 0; % If limits are exceeded no income is made
    end
    if econVars.T2(i) <= 90 && econVars.T2(i) >= 80 % if T2 is within the desired range, get paid
        incT2(i) = 90/60;
    else
        incT2(i) = 0; 
    end
    incTot(i) = incT1(i) + incT2(i);
end
for i = TOF(2):(TOF(2)+tOffline(2)+tInit) 
        incT1(i) = 0; % If the process is shut down, zero income is made.
        incT2(i) = 0;
        incTot(i) = incT1(i) + incT2(i);
end
for i = (TOF(2)+tOffline(2)+tInit):tSim
    if econVars.T1(i) <= 85 && econVars.T1(i) >= 75 % if T1 is within the desired range, get paid
        incT1(i) = 90/60;
    else
        incT1(i) = 0; % If limits are exceeded no income is made
    end
    if econVars.T2(i) <= 90 && econVars.T2(i) >= 80 % if T2 is within the desired range, get paid
        incT2(i) = 90/60;
    else
        incT2(i) = 0; 
    end
    incTot(i) = incT1(i) + incT2(i);
end

profit = zeros(tSim,1);
for i = 1: tSim
    profit(i) = incTot(i) - expense(i);
end
figure;
plot((1:tSim), profit);
totProfit = sum(profit,1);
fprintf('Total profit: R %.2f\n', totProfit);
end