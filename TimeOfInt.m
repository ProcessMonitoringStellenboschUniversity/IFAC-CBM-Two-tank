%% Time of Interlock function
% This function determines the time the interlock occurs
 
function [tInterlock, varInt] = TimeOfInt(IntDetect, ttest, count)
[detInt,varInt] = find(IntDetect);
% Determine the first detected interlock time (after initialisation time)
if count == 1
    timeDetect = detInt > (ttest(end)+100);
    tInt = detInt(timeDetect);
    tInterlock = min(tInt);
else
    timeDetect = detInt > 100;
    tInt = detInt(timeDetect);
    tInterlock = min(tInt);
end
end