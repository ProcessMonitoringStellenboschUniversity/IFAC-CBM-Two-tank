%% Start-up and shut down function
% This function allows the simulation to restart at a time period after shut
% down, maintenance and start-up.  From the contribution plot results, the
% identified faulty sensor is "replaced" and the simulation is
% restarted.

function [tRestart,sens, newSens, repVar, sensTot] = StartUpFault(tOffline, tStepF,cPlotF_spe, senBias, sensTot)

% Time when simulation must restart
tRestart = tStepF+tOffline;

% Sensor replacement based on Contribution Plots
repSens = zeros(1,8);
% check what cPLotF_spe - 1 is - check decimals!

for i = 1:8
        if cPlotF_spe(i) >= max(cPlotF_spe) % find which SPE contribution is the greatest
            repSens(i) = 1; % flag that variable as a possible symptom
        else
            repSens(i) = 0;
        end
end

repVar = find(repSens);

sensTot(sensTot == 0) = NaN;
[~, repSens] = min(sensTot(:,2));
sensTot(repSens, :) = 0;

sens = senBias;
if repVar == 1 || repVar == 5   % F1 - L1
    sens(1) = 0;                % remove sensor bias
    newSens = 0;                % A level sensor needs replacing
elseif repVar == 2 ||repVar == 7 % F2 - L2
    sens(3) = 0;
    newSens = 0;                
elseif repVar == 3 || repVar == 6 % F3 - T1
    sens(2) = 0;
    newSens = 1;                % A temperature sensor needs replacing
else
    sens(4) = 0;                % F4 - T2
    newSens = 1;
end
sensTot(isnan(sensTot)) = 0;
end