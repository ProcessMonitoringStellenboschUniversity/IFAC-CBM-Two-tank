%% Time of Interlock function
% This function determines the time the interlock occurs
 
function [tInterlock, varInt] = TimeOfInt_2Faults(IntDetect, tStart, tInit)

[detInt, varInt] =find(IntDetect);
% Determine the first detected interlock time
timeDetect = (detInt+tStart) > (tStart+tInit);
tIntDet = min(detInt(timeDetect));
tInterlock = tIntDet(1) + tStart;
end