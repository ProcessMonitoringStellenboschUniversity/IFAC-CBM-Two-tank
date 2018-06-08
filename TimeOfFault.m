%% Time of fault
% This function determines the time of fault detection

function [tFaultDetect, tFaultAct] = TimeOfFault(FaultDetect, sensors, tStart)

% Determine what time the actual fault occurred
tsens_fault = zeros(4,1);

for i = 1:4
       if sensors(i,1) ~= 0
           tsens_fault(i) = sensors(i,2);
       end
end
[~,~,tFaultAct] = find(tsens_fault);

% Determine the detected fault time
faultDetDiff = diff(FaultDetect); % where do the fault conditions happen (change from 0 to 1 and from 1 to 0)
allDiff = find(faultDetDiff);       
timeDetect = allDiff(end);  % The time of detection is when change in fault conditions stop
tFaultDetect = timeDetect + tStart;
end