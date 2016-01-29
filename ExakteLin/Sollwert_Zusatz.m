

% Anfangszustand
parSollwertfilter.x0_Filter=[0;0;0;0];
parSollwertfilter.Ta=0.001;
% Charakteristisches Polynom
p=poly(-1*eye(4));

s=tf('s');
Hs=tf(p(end),p);    % Uebertragungsfkt. des Sollwertfilters (Verstaerkung = 1)
Hsp=Hs*s;           % Differenzierer fuer 1. Ableitung von y_soll
Hspp=Hsp*s;         % Differenzierer fuer 2. Ableitung von y_soll
Hsppp=Hspp*s;  
% Diskretisierung
Hz=c2d(Hs,parSollwertfilter.Ta);
Hzp=c2d(Hsp,parSollwertfilter.Ta);
Hzpp=c2d(Hspp,parSollwertfilter.Ta);
Hzppp=c2d(Hsppp,parSollwertfilter.Ta);
% als State-Space-Model implementieren
Filter_disc=ss(Hzppp);

parSollwertfilter.a=Filter_disc.a;
parSollwertfilter.b=Filter_disc.b;
parSollwertfilter.c=Filter_disc.c;
parSollwertfilter.d=Filter_disc.d;