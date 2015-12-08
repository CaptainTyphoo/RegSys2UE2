%set_parameter;
Atant =      1.539e-2;      % Grundfläche Tank
rho =        1000;          % Dichte Wasser
eta =        8.9e-4;        % Dynamische Viskosität Wasser
g =         9.81;          % Gravitationskonstante
alpha1 =    0.0583;        % Kontraktionskoeffizient AV1
DA1 =        15e-3;         % Durchmesser AV1
alpha2 =    0.1039;        % Kontraktionskoeffizient AV2
A2 =         1.0429e-4;     % Querschnittsflaeche AV2
alpha3 =    0.0600;        % Kontraktionskoeffizient AV3
DA3 =       15e-3;         % Durchmesser AV3
alpha_120 = 0.3038;        % Kontraktionskoeffizient ZV12
A12 =      5.5531e-5;     % Querschnittsflaeche ZV12
Dh12 =      7.7e-3;        % hydraulischer Durchmesser
lambdac12 =  24000;         % kritische Fliesszahl ZV12
alpha23_0 = 0.1344;        % Kontraktionskoeffizient ZV23
D23       = 15e-3;         % Durchmesser ZV23
lambdac23 = 29600;         % Kritische Fliesszahl ZV23
hmin      = 0.05;          % Minimale Fuellhoehe
hmax      = 0.55;          % Maximale Fuellhoehe
U12 = 4.*A12./Dh12;

deltah = -1;
plotsize = -1:1e-3:1;
sizer = size(plotsize,2);

dq12_h1gh2_dh1 = zeros(1,sizer);
dq12_h1gh2_dh2 = zeros(1,sizer);
for i = 1:sizer
    if deltah > 0 %if h1 > h2
        dq12_h1gh2_dh1(1,i) = 0.8e1 .* alpha_120 .* A12 .^ 2 ./ U12 .* rho ./ eta .* g ./ lambdac12 .* (0.1e1 - tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(deltah) ./ lambdac12) .^ 2) + alpha_120 .* tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(deltah) ./ lambdac12) .* A12 .* sqrt(0.2e1) .* sqrt(g) .* (deltah) .^ (-0.1e1 ./ 0.2e1) ./ 0.2e1;
        dq12_h1gh2_dh2(1,i) = -0.8e1 .* alpha_120 .* A12 .^ 2 ./ U12 .* rho ./ eta .* g ./ lambdac12 .* (0.1e1 - tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(deltah) ./ lambdac12) .^ 2) - alpha_120 .* tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(deltah) ./ lambdac12) .* A12 .* sqrt(0.2e1) .* sqrt(g) .* (deltah) .^ (-0.1e1 ./ 0.2e1) ./ 0.2e1;
    else %if h2 > h1
        dq12_h1gh2_dh1(1,i) = (-1)*(-0.8e1 .* alpha_120 .* A12 .^ 2 ./ U12 .* rho ./ eta .* g ./ lambdac12 .* (0.1e1 - tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(-deltah) ./ lambdac12) .^ 2) - alpha_120 .* tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(-deltah) ./ lambdac12) .* A12 .* sqrt(0.2e1) .* sqrt(g) .* (-deltah) .^ (-0.1e1 ./ 0.2e1) ./ 0.2e1);
        dq12_h1gh2_dh2(1,i) = (-1)*(0.8e1 .* alpha_120 .* A12 .^ 2 ./ U12 .* rho ./ eta .* g ./ lambdac12 .* (0.1e1 - tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(-deltah) ./ lambdac12) .^ 2) + alpha_120 .* tanh(0.8e1 .* A12 ./ U12 .* rho ./ eta .* sqrt(0.2e1) .* sqrt(g) .* sqrt(-deltah) ./ lambdac12) .* A12 .* sqrt(0.2e1) .* sqrt(g) .* (-deltah) .^ (-0.1e1 ./ 0.2e1) ./ 0.2e1);
    end
    deltah = deltah + 1e-3;
end

%plot(plotsize,dq12_h1gh2_dh1);
plot(plotsize,dq12_h1gh2_dh2);