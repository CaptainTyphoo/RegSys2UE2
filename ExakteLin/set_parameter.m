% Parameterdatei Dreitank
% Uebung Regelungssysteme
%
% Erstellt:  19.10.2010 T. Utz
% Geaendert: 14.7.2011 F. Koenigseder
%            06.11.2014 S. Flixeder
% --------------------------------------
%

 clear all;
 close all;

%% Parameter 
% 2 oder 3 Tank Modell
Tank = 3;

%Parameterabweichungen
parSys.DA1_Abw = 1.1;% 1.1;
parSys.DA3_Abw = 1.2;% 1.2;

% Sollwert-Spruenge 
parSys.deltay1d = 0.1;   %  0.3;
parSys.deltay2d = -0.05; % -0.2;



% Parameter des Systems
parSys.Atank     = 1.539e-2;      % Grundflaeche Tank
parSys.rho       = 1000;          % Dichte Wasser
parSys.eta       = 8.9e-4;        % Dynamische Viskosit?t Wasser
parSys.g         = 9.81;          % Gravitationskonstante
parSys.alphaA1   = 0.0583;        % Kontraktionskoeffizient AV1
parSys.DA1       = 15e-3;         % Durchmesser AV1
parSys.alphaA2   = 0.1039;        % Kontraktionskoeffizient AV2
parSys.A2        = 1.0429e-4;     % Querschnittsflaeche AV2
parSys.alphaA3   = 0.0600;        % Kontraktionskoeffizient AV3
parSys.DA3       = 15e-3;         % Durchmesser AV3
parSys.alpha12_0 = 0.3038;        % Kontraktionskoeffizient ZV12
parSys.A12       = 5.5531e-5;     % Querschnittsflaeche ZV12
parSys.Dh12      = 7.7e-3;        % hydraulischer Durchmesser
parSys.lambdac12 = 24000;         % kritische Fliesszahl ZV12
parSys.alpha23_0 = 0.1344;        % Kontraktionskoeffizient ZV23
parSys.D23       = 15e-3;         % Durchmesser ZV23
parSys.lambdac23 = 29600;         % Kritische Fliesszahl ZV23
parSys.hmin      = 0.05;          % Minimale Fuellhoehe
parSys.hmax      = 0.55;          % Maximale Fuellhoehe
parSys.dh12min   = 0.1e-3; 
parSys.dh23min   = 0.1e-3; 

% Abtastzeit
parSys.Ta = 0.2;                

% Anfangsbedingung
if Tank < 2.5
    parSys.h1_0 = 0.18;
    parSys.h2_0 = 0.1;
    parSys.h3_0 = 0.1;
else
    parSys.h1_0 = 0.18; %0.1
    parSys.h2_0 = 0.1; %0.05
    parSys.h3_0 = 0.1; %0.05 od 0.1
end

% Maximale Zufluesse
parSys.qZ1max = 4.5e-3/60;        % Maximaler Zufluss Z1
parSys.qZ3max = 4.5e-3/60;        % Maximaler Zufluss Z3
parSys.qZ1min = 0;                % Minimaler Zufluss Z1
parSys.qZ3min = 0;                % Minimaler Zufluss Z3


%Sollwertfilter berechnen
Sollwertfilter;

% Ruhelagen fuer 2 Tank Modell aus Maple
% h20 = 0.1
% h10 = .1800312371;
% qZ10 = 0.3454039310e-4; % m3/s


%% Fehlerdynamik

% 2 Tank Modell (Eigenwerte bei -0.1)
lambda=0.1;
parInit.a0 = lambda^2; 
parInit.a1 = 2*lambda; 

% 3-Tank Regler (Eigenwerte bei -0.1)
lambda=0.1;
parInit.a10 = lambda^2;  
parInit.a11 =  2*lambda; 
parInit.a20 = 0.1;      
parInit.a1I = 5e-5;
parInit.a2I = 2e-3;


%% Linearisierung

%Abkuerzungen fuer die folgenden Berechnungen
params;

% dq12_dh1(dh12min)
eq12_h1gh2_dh1_subs = 0.2e1 * alpha12_0 * Dh12 * rho / eta * g / lambdac12 * (0.1e1 - tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(dh12min)) / lambdac12) ^ 2) * A12 + alpha12_0 * tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(dh12min)) / lambdac12) * A12 * sqrt(0.2e1) * sqrt(g) * (abs(dh12min) ^ (-0.1e1 / 0.2e1)) / 0.2e1;
% dq12_dh1(0)
eq12_h1gh2_dh1_d = 4 * alpha12_0 * A12 * Dh12 * rho * g / eta / lambdac12;
% Steigung von dq12_dh1
k_dq12_dh1 = (eq12_h1gh2_dh1_subs - eq12_h1gh2_dh1_d)/dh12min;
% Parameter fuer Geradengleichung von dq12_dh1
parSys.k_dq12_dh1 = k_dq12_dh1;
parSys.d_dq12_dh1 = eq12_h1gh2_dh1_d;

% dq12_dh2(dh12min)
eq12_h1gh2_dh2_subs = -0.2e1 * alpha12_0 * Dh12 * rho / eta * g / lambdac12 * (0.1e1 - tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(dh12min) / lambdac12) ^ 2) * A12 - alpha12_0 * tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(dh12min) / lambdac12) * A12 * sqrt(0.2e1) * sqrt(g) * dh12min ^ (-0.1e1 / 0.2e1) / 0.2e1;
% dq12_dh2(0)
eq12_h1gh2_dh2_d = -4 * alpha12_0 * A12 * Dh12 * rho * g / eta / lambdac12;
% Steigung von dq12_dh2
k_dq12_dh2 = (eq12_h1gh2_dh2_subs - eq12_h1gh2_dh2_d)/dh12min;
% Parameter fuer Geradengleichung von dq12_dh2
parSys.k_dq12_dh2 = k_dq12_dh2;
parSys.d_dq12_dh2 = eq12_h1gh2_dh2_d;

% dq23_dh1(dh23min)
eq23_h2gh3_dh2_subs =  alpha23_0 * D23 ^ 3 * rho / eta * g / lambdac23 * (0.1e1 - tanh(0.2e1 * D23 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(dh23min)) / lambdac23) ^ 2) * pi / 0.2e1 + alpha23_0 * tanh(0.2e1 * D23 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(dh23min)) / lambdac23) * D23 ^ 2 * pi * sqrt(0.2e1) * sqrt(g) * (abs(dh23min) ^ (-0.1e1 / 0.2e1)) / 0.8e1;
% dq23_dh1(0)
eq23_h2gh3_dh2_d = D23 ^ 3 * alpha23_0 * pi * rho * g / eta / lambdac23;
% Parameter fuer Geradengleichung von dq23_dh1
parSys.k_dq23_dh2 = (eq23_h2gh3_dh2_subs - eq23_h2gh3_dh2_d)/dh23min;
parSys.d_dq23_dh2 = eq23_h2gh3_dh2_d;

% dq23_dh2(dh23min)
eq23_h2gh3_dh3_subs =  -alpha23_0 * D23 ^ 3 * rho / eta * g / lambdac23 * (0.1e1 - tanh(0.2e1 * D23 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(dh23min)) / lambdac23) ^ 2) * pi / 0.2e1 - alpha23_0 * tanh(0.2e1 * D23 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(dh23min)) / lambdac23) * D23 ^ 2 * pi * sqrt(0.2e1) * sqrt(g) * (abs(dh23min) ^ (-0.1e1 / 0.2e1)) / 0.8e1;
% dq23_dh2(0)
eq23_h2gh3_dh3_d =  -D23 ^ 3 * alpha23_0 * pi * rho * g / eta / lambdac23;
% Parameter fuer Geradengleichung von dq23_dh2
parSys.k_dq23_dh3 = (eq23_h2gh3_dh3_subs - eq23_h2gh3_dh3_d)/dh23min;
parSys.d_dq23_dh3 = eq23_h2gh3_dh3_d;

