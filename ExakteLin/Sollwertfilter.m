parSollwertfilter.Ta=0.2;
lambda=-2;
parSollwertfilter.x0_Filter=[0;0;0];



p= poly(lambda*eye(3));

s=tf('s');
Hs=tf(p(end),p);
Hsp= Hs*s;
Hspp=Hsp*s;

Hz=c2d(Hs,parSollwertfilter.Ta);
Hzp=c2d(Hsp,parSollwertfilter.Ta);
Hzpp=c2d(Hspp,parSollwertfilter.Ta);

Filter_disc=ss([Hz;Hzp;Hzpp]);

parSollwertfilter.a=Filter_disc.a;
parSollwertfilter.b=Filter_disc.b;
parSollwertfilter.c=Filter_disc.c;
parSollwertfilter.d=Filter_disc.d;