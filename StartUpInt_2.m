%% Start up procedure for an interlock
% This function calculates the restart time if an interlock occurs before a
% fault or if an interlock occurs in the system without any FDD

% For a fault where incorrect sensor is replaced

function [tRestart,sens, newSens, repSens, sensTot] = StartUpInt_2(tOffline, tIntlk, sensBias, sensTot)

tRestart = tIntlk + tOffline;

% Replacing the correct sensor for the interlock time, find non-zero sensor bias
sensTot(sensTot == 0) = NaN;
[~, repSens] = max(sensTot(:,1)); % finding the sensor that wasnt replaced
sensBias(repSens) = 0;
sensTot(repSens, :) = 0;

sens = sensBias;
if repSens == 1 || repSens == 3   % level sensors
    newSens = 0;               
elseif repSens == 2 ||repSens == 4 % temperature sensors
    newSens = 1;                
end
sensTot(isnan(sensTot)) = 0;
end