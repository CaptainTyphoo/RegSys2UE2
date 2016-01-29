%set_parameter;
Atant =      1.539e-2;      % Grundfl?che Tank
rho =        1000;          % Dichte Wasser
eta =        8.9e-4;        % Dynamische Viskosit?t Wasser
g =         9.81;          % Gravitationskonstante
alpha1 =    0.0583;        % Kontraktionskoeffizient AV1
DA1 =        15e-3;         % Durchmesser AV1
alpha2 =    0.1039;        % Kontraktionskoeffizient AV2
A2 =         1.0429e-4;     % Querschnittsflaeche AV2
alpha3 =    0.0600;        % Kontraktionskoeffizient AV3
DA3 =       15e-3;         % Durchmesser AV3
alpha12_0 = 0.3038;        % Kontraktionskoeffizient ZV12
A12 =      5.5531e-5;     % Querschnittsflaeche ZV12
Dh12 =      7.7e-3;        % hydraulischer Durchmesser
lambdac12 =  24000;         % kritische Fliesszahl ZV12
alpha23_0 = 0.1344;        % Kontraktionskoeffizient ZV23
D23       = 15e-3;         % Durchmesser ZV23
lambdac23 = 29600;         % Kritische Fliesszahl ZV23
hmin      = 0.05;          % Minimale Fuellhoehe
hmax      = 0.55;          % Maximale Fuellhoehe
U12 = 4.*A12./Dh12;
dh12min=    1e-4; 


%% Nicht Linear
deltah=-0.25:1e-5:0.25;

dq12_dh1 = 0.8e1 .* alpha12_0 .* A12 .^ 2 ./ U12 .* rho ./ eta .* g ./ lambdac12 .* (0.1e1 - tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(abs(deltah)) ./ lambdac12) .^ 2) + alpha12_0 .* tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(abs(deltah)) ./ lambdac12) .* A12 .* sqrt(0.2e1) .* sqrt(g) .* (abs(deltah)) .^ (-0.1e1 ./ 0.2e1) ./ 0.2e1;
dq12_dh2 = -(0.8e1 .* alpha12_0 .* A12 .^ 2 ./ U12 .* rho ./ eta .* g ./ lambdac12 .* (0.1e1 - tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(abs(deltah)) ./ lambdac12) .^ 2) + alpha12_0 .* tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(abs(deltah)) ./ lambdac12) .* A12 .* sqrt(0.2e1) .* sqrt(g) .* (abs(deltah)) .^ (-0.1e1 ./ 0.2e1) ./ 0.2e1);


%% Linarisierung


% dq12_dh1(dh12min)
eq12_h1gh2_dh1_subs = 0.2e1 * alpha12_0 * Dh12 * rho / eta * g / lambdac12 * (0.1e1 - tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(dh12min)) / lambdac12) ^ 2) * A12 + alpha12_0 * tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(abs(dh12min)) / lambdac12) * A12 * sqrt(0.2e1) * sqrt(g) * (abs(dh12min) ^ (-0.1e1 / 0.2e1)) / 0.2e1;
% dq12_dh1(0)
eq12_h1gh2_dh1_d = 4 * alpha12_0 * A12 * Dh12 * rho * g / eta / lambdac12;
% Steigung von dq12_dh1
k_dq12_dh1 = (eq12_h1gh2_dh1_subs - eq12_h1gh2_dh1_d)/dh12min;

% dq12_dh2(dh12min)
eq12_h1gh2_dh2_subs = -0.2e1 * alpha12_0 * Dh12 * rho / eta * g / lambdac12 * (0.1e1 - tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(dh12min) / lambdac12) ^ 2) * A12 - alpha12_0 * tanh(0.2e1 * Dh12 * rho / eta * sqrt(0.2e1) * sqrt(g) * sqrt(dh12min) / lambdac12) * A12 * sqrt(0.2e1) * sqrt(g) * dh12min ^ (-0.1e1 / 0.2e1) / 0.2e1;
% dq12_dh2(0)
eq12_h1gh2_dh2_d = -4 * alpha12_0 * A12 * Dh12 * rho * g / eta / lambdac12;
% Steigung von dq12_dh2
k_dq12_dh2 = (eq12_h1gh2_dh2_subs - eq12_h1gh2_dh2_d)/dh12min;


dq12_dh1_lin=eq12_h1gh2_dh1_d+k_dq12_dh1.*abs(deltah);
dq12_dh2_lin=eq12_h1gh2_dh2_d+k_dq12_dh2.*abs(deltah);



%% Plot
figure();
plot(deltah,dq12_dh1);
hold on
plot(deltah,dq12_dh1_lin);
title('dq12dh1');
figure();
plot(deltah,dq12_dh2);
hold on;
plot(deltah,dq12_dh2_lin);
title('dq12dh2');




   