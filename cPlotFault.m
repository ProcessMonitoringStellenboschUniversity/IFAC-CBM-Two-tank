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

%% Contribution plots function 
%  This function determines the normalised SPE contributions of each variable
%  at fault detection time.

function cPlotF = cPlotFault(tFaultDet, SPEall, SPEtot, cPlotTr, cPlotLimit, tRestart, smDelay)

% Extracting data for fault detection event at the time of fault detection
SPEfault = SPEall(tFaultDet-smDelay-tRestart+1:tFaultDet-tRestart,:); 
SPEtotal = SPEtot(tFaultDet-smDelay-tRestart+1:tFaultDet-tRestart,:);

% Fraction that each variable contributes to the total SPE at the fault time
% instance
[N, ~] = size(SPEfault);
cPlotF_vars = zeros(N, 8);
for n = 1 : N
    for m = 1: 8
        cPlotF_vars(n,m) =  SPEfault(n,m)./SPEtotal(n);
    end
end
% Calculating the average contribution of each variable from fault data and
% normalising using each variable's threshold
cPlotF = mean(cPlotF_vars,1)./cPlotTr;

% Plot SPE contributions
figure;
bar(1:8, cPlotF, 'm')
ylabel('SPE contribution');
xlabel('Variable no.');
ylim([0 1.5]);
hold on
plot([0 9], [1 1], 'r--')
hold on
plot(1:8, cPlotLimit, 'k-*')
hold off
legend('Relative contributions','Maximum','Training contributions')
end