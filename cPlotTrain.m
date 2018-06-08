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

%% Contribution plot for training data
% This function determine the contribution plots based on training data as
% well as the contribution limit of each process variable under NOC

function [cPlotLimit, cPlotTr] = cPlotTrain(ttrain, SPEtot, SPEall)

% Defining the training data for SPE and MHT
SPEtrain = SPEall(ttrain,:);
SPEtrTot = SPEtot(ttrain,1);

% Fraction that each variable contributes to the SPE or MHT value for training
% data
cPlotTr_vars = zeros(length(ttrain),8);

for n = 1:length(ttrain)
    for m = 1:8
    cPlotTr_vars(n,m) =  SPEtrain(n,m)./SPEtrTot(n);
    end
end

% Calculate 90th percentile of each variable as its threshold
cPlotLimit = prctile(cPlotTr_vars,90,1);

% Calculating the average contribution each variable from training data and
% then determining the normalised contribution of each variable based on each variable's 
% threshold during training time
cPlotTr = mean(cPlotTr_vars,1);

% Plotting the training SPE contributions
% figure;
% plot(1:8, cPlotTr, 'k-*');
% ylabel('Normalized SPE contribution');
% xlabel('Variable no.');
% title('Training');
% hold on
% plot([0 9], [1 1], 'r--');
% hold on
% plot(1:8, cPlotLimit, 'b-*');
% hold off

end