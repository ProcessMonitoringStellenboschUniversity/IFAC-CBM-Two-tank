%% Steady state parameter set function
% This function sets the steady state parameters, controller settings,
% intitalises the fault conditions, and runs the simulation once to obtain
% data for PCA training

function [ssOut,sizeStep_Gc11,sizeStep_Gc23,sizeStep_Gc32,sizeStep_Gc44,tStep_Gc11,tStep_Gc23,tStep_Gc32,tStep_Gc44]   = steadyStateSet(sys,tRun)

% //Sensor fault parameter intialise
% Controller 1
sizeStep_Gc11 = 0;  % L1 - F1
tStep_Gc11 = 0;

% Controller 2
sizeStep_Gc23 = 0; % T1 - F3
tStep_Gc23 = 0;

% Controller 3
sizeStep_Gc32 = 0; % L2 - F2
tStep_Gc32 = 0;

% Controller 4
sizeStep_Gc44 = 0; % T2 - F4
tStep_Gc44 = 0;

set_param(sys,'StopTime', num2str(tRun));
set_param(sys, 'StartTime', '0.0');
set_param(strcat(sys,'/Fault Detection/PCA_apply'), 'Commented', 'on');
set_param(strcat(sys,'/Fault Detection/NOC_data'), 'Commented', 'off');

% Initial and steady state values
L1ss = 2;           %[m]
L2ss = 2.4;         %[m] 
T1ss = 80;          %[C] 
T2ss = 85;          %[C]
T1in = 25;          %[C]
T2in = 25;          %[C]
T5in = 30;          %[C]
T3ss = 150;         %[C]
T4ss = 150;         %[C]
F1ss = 0.1814;      %[m3/min] 
F2ss = 0.0269;      %[m3/min]
F3ss = 0.3658;      %[m3/min]  
F4ss = 0.042;       %[m3/min] 
F5ss = 0.1;         %[m3/min]
F1out = 0.2814;     %[m3/min]
F2out = 0.3083;     %[m3/min]

% Parameters
a = 5e5; %[cal/(min C)]
b = 0.5;
cp = 1;     %[cal/(gC)]
rho = 1e6;  %[g/m3]
A1 = 1;     % [m]
A2 = A1;    % [m]
kL = 0.199; % [m3/min/m0.5] 

% MV max and min
F1max = F1ss*2;
F1min = F1ss/2;
F2max = F2ss*2;
F2min = F2ss/2;
F3max = F3ss*2;
F3min = F3ss/2;
F4max = F4ss*2;
F4min = F4ss/2;

% CV min and max
L1max = L1ss*2;
L1min = L1ss/2;
T1max = T1ss*2;
T1min = T1ss/2;
L2max = L2ss*2;
L2min = L2ss/2;
T2max = T2ss*2;
T2min = T2ss/2;

% Controller settings
alpha = 0.1;    % for derivative filter
% // Gc11
Kc11 = 0.075/3;
tauI11 = 65.75/3;
tauD11 = 12.05/3;
kv1 = F1ss/50;
% // Gc23 - T1 - F3
Kc23 = 0.039;
tauI23 = 54.05;
tauD23 = 3.36;
kv2 = F2ss/50;
% // Gc32 - L2 - F2
Kc32 = 0.072/4;
tauI32 = 70.38/4;  
tauD32 = 14.79/4;  
kv3 = F3ss/50;
% // Gc44
Kc44 = 0.012/2;  
tauI44 = 59.28/2;
tauD44 = 7.32/2;
kv4 = F4ss/50;

% Noise 
% Process noise variances
noiseT1in = 0.475E-4; % from Yoon article
noiseT2in = 0.475E-4;
noiseT3 = 0.475E-4;
noiseT4 = 0.475E-4;

% Sensor noise variances - Lindner
noiseT1 = 0.05;
noiseT2 = 0.05;
noiseL1 = 0.05; 
noiseL2 = 0.05;

% Collect data for output
ssOut.L1ss = L1ss;
ssOut.L2ss = L2ss;
ssOut.T1ss = T1ss;
ssOut.T2ss = T2ss;
ssOut.T1in = T1in;
ssOut.T2in = T2in;
ssOut.T5in = T5in;
ssOut.T3ss = T3ss;
ssOut.T4ss = T4ss;
ssOut.F1ss = F1ss;
ssOut.F2ss = F2ss;
ssOut.F3ss = F3ss;
ssOut.F4ss = F4ss;
ssOut.F5ss = F5ss;
ssOut.F1out = F1out;
ssOut.F2out = F2out;
ssOut.a = a;
ssOut.b = b;
ssOut.cp = cp;
ssOut.rho = rho;
ssOut.A1 = A1;
ssOut.A2 = A2;
ssOut.kL = kL;
ssOut.F1max = F1max;
ssOut.F1min = F1min;
ssOut.F2max = F2max;
ssOut.F2min = F2min;
ssOut.F3max = F3max;
ssOut.F3min = F3min;
ssOut.F4max = F4max;
ssOut.F4min = F4min;
ssOut.L1max = L1max;
ssOut.L1min = L1min;
ssOut.L2max = L2max;
ssOut.L2min = L2min;
ssOut.T1max = T1max;
ssOut.T1min = T1min;
ssOut.T2max = T2max;
ssOut.T2min = T2min;
ssOut.alpha = alpha;
ssOut.Kc11 = Kc11;
ssOut.tauI11 = tauI11;
ssOut.tauD11 = tauD11;
ssOut.kv1 = kv1;
ssOut.Kc23 = Kc23;
ssOut.tauI23 = tauI23;
ssOut.tauD23 = tauD23;
ssOut.kv2 = kv2;
ssOut.Kc32 = Kc32;
ssOut.tauI32 = tauI32;
ssOut.tauD32 = tauD32;
ssOut.kv3 = kv3;
ssOut.Kc44 = Kc44;
ssOut.tauI44 = tauI44;
ssOut.tauD44 = tauD44;
ssOut.kv4 = kv4;
ssOut.noiseT1in = noiseT1in;
ssOut.noiseT2in = noiseT2in;
ssOut.noiseT3 = noiseT3;
ssOut.noiseT4 = noiseT4;
ssOut.noiseT1 = noiseT1;
ssOut.noiseT2 = noiseT2;
ssOut.noiseL1 = noiseL1;
ssOut.noiseL2 = noiseL2;
end