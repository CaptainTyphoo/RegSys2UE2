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

% Parameter des Systems
parSys.Atank     = 1.539e-2;      % Grundfl?che Tank
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

% Abtastzeit
parSys.Ta = 0.2;                

% Anfangsbedingung
parSys.h1_0 = 0.18; % aus Maple
parSys.h2_0 = 0.10;
parSys.h3_0 = 0.22;

% Maximale Zufluesse
parSys.qZ1max = 4.5e-3/60;        % Maximaler Zufluss Z1
parSys.qZ3max = 4.5e-3/60;        % Maximaler Zufluss Z3
parSys.qZ1min = 0;                % Minimaler Zufluss Z1
parSys.qZ3min = 0;                % Minimaler Zufluss Z3

Sollwertfilter;

% Ruhelagen
%h10 = .1800312371;
%qZ10 = 0.3454039310e-4; % m3/s

% Fehlerdynamik
% Eigenwerte bei -0.1
parSys.a0 = 1e-2; 
parSys.a1 = 0.2; 

params;

% Linearisierung
% dq12_dh1(dh12min)
eq12_h1gh2_dh1_subs = 0.2e1 * alpha12_0 * Dh12 * rho / eta * g / lambdac12 * (0.1e1 - tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(dh12min)) / lambdac12) ^ 2) * A12 + alpha12_0 * tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(dh12min)) / lambdac12) * A12 * sqrt(0.2e1) * sqrt(g) * (abs(dh12min) ^ (-0.1e1 / 0.2e1)) / 0.2e1;
% dq12_dh1(0)
eq12_h1gh2_dh1_d = 4 * alpha12_0 * A12 * Dh12 * rho * g / eta / lambdac12;
% Steigung von dq12_dh1
k_dh1 = (eq12_h1gh2_dh1_subs - eq12_h1gh2_dh1_d)/dh12min;
% Parameter fuer Geradengleichung von dq12_dh1
parSys.k_dh1 = k_dh1;
parSys.d_dh1 = eq12_h1gh2_dh1_d;

% dq12_dh2(dh12min)
eq12_h1gh2_dh2_subs = -0.2e1 * alpha12_0 * Dh12 * rho / eta * g / lambdac12 * (0.1e1 - tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(dh12min) / lambdac12) ^ 2) * A12 - alpha12_0 * tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(dh12min) / lambdac12) * A12 * sqrt(0.2e1) * sqrt(g) * dh12min ^ (-0.1e1 / 0.2e1) / 0.2e1;
% dq12_dh2(0)
eq12_h1gh2_dh2_d = -4 * alpha12_0 * A12 * Dh12 * rho * g / eta / lambdac12;
% Steigung von dq12_dh2
k_dh2 = (eq12_h1gh2_dh2_subs - eq12_h1gh2_dh2_d)/dh12min;
% Parameter fuer Geradengleichung von dq12_dh2
parSys.k_dh2 = k_dh2;
parSys.d_dh2 = eq12_h1gh2_dh2_d;