%Berechnung Ruhelagen
%set_parameter;
Atank     = 1.539e-2;      % Grundfläche Tank
rho       = 1000;          % Dichte Wasser
eta       = 8.9e-4;        % Dynamische Viskosität Wasser
g         = 9.81;          % Gravitationskonstante
alphaA1   = 0.0583;        % Kontraktionskoeffizient AV1
DA1       = 15e-3;         % Durchmesser AV1
alphaA2   = 0.1039;        % Kontraktionskoeffizient AV2
A2        = 1.0429e-4;     % Querschnittsflaeche AV2
alphaA3   = 0.0600;        % Kontraktionskoeffizient AV3
DA3       = 15e-3;         % Durchmesser AV3
alpha12_0 = 0.3038;        % Kontraktionskoeffizient ZV12
A12       = 5.5531e-5;     % Querschnittsflaeche ZV12
Dh12      = 7.7e-3;        % hydraulischer Durchmesser
lambdac12 = 24000;         % kritische Fliesszahl ZV12
alpha23_0 = 0.1344;        % Kontraktionskoeffizient ZV23
D23       = 15e-3;         % Durchmesser ZV23
lambdac23 = 29600;         % Kritische Fliesszahl ZV23
hmin      = 0.05;          % Minimale Fuellhoehe
hmax      = 0.55;          % Maximale Fuellhoehe

syms('h1','u');

h2 = 0.1;

q12_h1gh2 = alpha12_0 * tanh(0.8e1 * A12 / U12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(h1 - h2)) / lambdac12) * A12 * sqrt(0.2e1) * sqrt(g) * sqrt((h1 - h2));
q12_h2gh1 = alpha12_0 * tanh(0.8e1 * A12 / U12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(h1 - h2)) / lambdac12) * A12 * sqrt(0.2e1) * sqrt(g) * sqrt((h2 - h1));
qA1 = alphaA1 * DA1 ^ 2 * pi * sqrt(0.2e1) * sqrt(0.1e1 / rho) * sqrt(rho * g * h1) / 0.4e1;
qA2 = alphaA2 * A2 * sqrt(0.2e1) * sqrt( g * h2);

%gleichung 1
%0 = (-q12_h1gh2 - qA1)/A1;

%0 = qA1 + qA2 - u;
%q12_h1gh2 - qA2 = 0;

[h1g,ug] = solve(qA1 + qA2 - u, q12_h1gh2 - qA2);
[h1k,uk] = solve(qA1 + qA2 - u, q12_h2gh1 - qA2);
h1g = double(h1g)
ug = double(ug)

%Ruhelage macht keinen Sinn, da dann Tank 2 ausrinnt
h1k = double(h1k)
uk = double(uk)