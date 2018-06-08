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

%% User set fault conditions function
%   This function uses user fault condition inputs to include a fault
%   condition 

function [sizeStep_Gc11,sizeStep_Gc23,sizeStep_Gc32,sizeStep_Gc44,tStep_Gc11,tStep_Gc23,tStep_Gc32,tStep_Gc44 ] = faultCond(sensFail,sensStep, sensTime)

if sensFail == 1
    sizeStep_Gc11 = sensStep;
    tStep_Gc11 = sensTime;
    sizeStep_Gc23 = 0;
    tStep_Gc23 = 0;
    sizeStep_Gc32 = 0;
    tStep_Gc32 = 0;
    sizeStep_Gc44 = 0;
    tStep_Gc44 = 0;
elseif sensFail == 2
    sizeStep_Gc23 = sensStep;
    tStep_Gc23 = sensTime;
    sizeStep_Gc11 = 0;
    tStep_Gc11 = 0;
    sizeStep_Gc32 = 0;
    tStep_Gc32 = 0;
    sizeStep_Gc44 = 0;
    tStep_Gc44 = 0;
elseif sensFail == 3
    sizeStep_Gc32 = sensStep;
    tStep_Gc32 = sensTime;
    sizeStep_Gc11 = 0;
    tStep_Gc11 = 0;
    sizeStep_Gc23 = 0;
    tStep_Gc23 = 0;
    sizeStep_Gc44 = 0;
    tStep_Gc44 = 0;
elseif sensFail == 4
    sizeStep_Gc44 = sensStep;
    tStep_Gc44 = sensTime;
    sizeStep_Gc11 = 0;
    tStep_Gc11 = 0;
    sizeStep_Gc23 = 0;
    tStep_Gc23 = 0;
    sizeStep_Gc32 = 0;
    tStep_Gc32 = 0;
end    

end

