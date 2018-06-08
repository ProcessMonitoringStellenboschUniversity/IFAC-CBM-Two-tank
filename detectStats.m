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

%% Performance metrics calculation
% This function determines the detection delay, missed alarm rate,
% and false alarm rate

function [speStats, mhtStats] = detectStats(MHTcrit, SPEcrit, faultMonData,smDelay, nocData)

% Detection delay - number of samples before fault detected
DD_mht = zeros(length(faultMonData.mhtFaultAD),1);
DD_spe = zeros(length(faultMonData.speFaultAD),1);

for i = 1: length(faultMonData.mhtFaultAD)
   DD_mht(i) = faultMonData.mhtFaultAD(i) > MHTcrit; 
   DD_spe(i) = faultMonData.speFaultAD(i) > SPEcrit;
end

DDlogic = logical(DD_mht);
DDlogSPE = logical(DD_spe);
mhtDD = length(faultMonData.mhtFaultAD) - sum(DDlogic);
speDD = length(faultMonData.speFaultAD) - sum(DDlogSPE);
fprintf('mhtDD = %d\nspeDD = %d\n',mhtDD, speDD)

% Missed alarms - not exceeding threshold for fault condition data
MAmht = zeros(length(faultMonData.mhtFaultAD),1); 
MAspe = zeros(length(faultMonData.speFaultAD),1);
mhtCountMA = 0;
speCountMA = 0;

for i = smDelay: length(faultMonData.tfaultAD)
    dataWindow = ((i+1)-smDelay:i);
    for q = 1 : length(dataWindow)
        MAmht(q) = faultMonData.mhtFaultAD(q) < MHTcrit; % fixed
        MAspe(q) = faultMonData.speFaultAD(q) < SPEcrit;
    end
    if sum(MAmht) == smDelay 
        mhtCountMA = mhtCountMA + 1;
        fprintf('sum(MAmht) = %d\nLength tfaultAD = %d\n', sum(MAmht), length(faultMonData.tfaultAD))
    end
    if sum(MAspe) == smDelay
        speCountMA = speCountMA + 1;
        fprintf('sum(MAspe) = %d\nLength tfaultAD = %d\n', sum(MAspe), length(faultMonData.tfaultAD))
    end
end
mhtMAR = mhtCountMA/length(faultMonData.tfaultAD);
speMAR = speCountMA/length(faultMonData.tfaultAD);

% False alarms - exceeding threshold for NOC data
FAmht = zeros(length(nocData.NOCmht),1);
FAspe = zeros(length(nocData.NOCmht),1);
mhtCount = 0;
speCount = 0;
for i = smDelay: length(nocData.tNOC)
    dataWindow = ((i+1) - smDelay :i);
    
    for q = 1 : length(dataWindow)
        FAmht(i) = nocData.NOCmht(q) > MHTcrit; 
        FAspe(i) = nocData.NOCspe(q) > SPEcrit;
    end
    
    if sum(FAmht) == smDelay % If the total alarms found above are equal to the no. of consec alarms = fault, then increase false alarm counter
        mhtCount = mhtCount + 1;
    end
    if sum(FAspe) == smDelay
        speCount = speCount + 1;
    end
end
mhtFAR = mhtCount/length(nocData.tNOC);
speFAR = speCount/length(nocData.tNOC);

mhtStats = struct('mhtDD',mhtDD, 'mhtMAR', mhtMAR, 'mhtFAR', mhtFAR);
speStats = struct('speDD', speDD, 'speMAR', speMAR, 'speFAR', speFAR);

end