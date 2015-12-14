function [] = animation( h1,h2,h3,q12,q23,a1,a2,a3,z1,z3,Ta,model,anim_on,video_on)

%Animation of the 2 and 3 Tank Model
%
%  Input 2 Tank Model:
%   model              ... Integer, model = 2
%   h1,h2,q12,a1,a2,z1 ... 1xn Vector 
%   h3,q23,a3,z3       ... doens not matter
%    
% Input 3 Tank Model:
%   model                           ... Integer, model = 3
%   h1,h2,h3,q12,q23,a1,a2,a3,z1,z3 ... 1xn Vector  
%
%Input for both
%   Ta       ... Double : Sampling time of input values
%   anim_on  ... Integer: If not 0, animation os shown
%   video_on ... Integer: If anim_on=1 and video_on=1, animation is saved
%                         as "Tank.avi"
%        


if(min(anim_on)==0)
    return;
end

pfad='Tank.avi';

if(video_on==1)
    writerObj = VideoWriter(pfad);
    writerObj.FrameRate=25;
    open(writerObj);
end

h_max = 0.5;         % 500 ml
z_max = 7.5e-5;      % 4.5l/min
a_max= max([a1;a2]); % max. occuring a


%Normalize h to [0 10]
h1=h1.*10./h_max;
h2=h2.*10./h_max;
if(model==3)
    h3=h3.*10./h_max;
end

%Reduce so that 400s are a 20s video
reduce=400/20/(25*Ta);

h1=h1(1:reduce:end);
h2=h2(1:reduce:end);
if(model==3)
    h3=h3(1:reduce:end);
end

a1=a1(1:reduce:end);
a2=a2(1:reduce:end);
if(model==3)
    a3=a3(1:reduce:end);
end

z1=z1(1:reduce:end);
if(model==3)
    z3=z3(1:reduce:end);
end

q12=q12(1:reduce:end);
if(model==3)
    q23=q23(1:reduce:end);
end

%% Parameter and Start Plot
tank_width=15;
tank_heigth=10;
tisch_height=0.5;
a_width=0.1*tank_width;
z_width=0.1*tank_width;

sin_temp  = 0:tank_width/100:tank_width;
if(model==3)
sin2_temp = 0:tank_width/100:3.4*tank_width+10 + 2;
else
sin2_temp = 0:tank_width/100:2.2*tank_width+10 + 2;   
end

z1_color  = [0.5,0.5,0.5];
rohr1_col = [0.5,0.5,0.5];
tank_col  = [0.9,0.9,0.9];
tisch_col = [0.4,0.1,0.4];
abw_col   = [0.2,0.2,1];


%Figure
animation_plot=figure('Name','Simulation Plot Window','NumberTitle','off','units','normal','outerposition',[0 0 1 1]);
hold on;

if(model==3)
    xlim([-5 3.4*tank_width+5]);
else
    xlim([-5 2.2*tank_width+5]);
end
ylim([-5 tank_heigth+5]);
axis square;

%Tanks
rectangle('Position',[0 0 tank_width tank_heigth],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
rectangle('Position',[1.2*tank_width 0 tank_width tank_heigth],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
if(model==3)
    rectangle('Position',[2.4*tank_width 0 tank_width tank_heigth],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
end

% SOll H2
line([1.2*tank_width,2.2*tank_width],[0.2/h_max*10,0.2/h_max*10])

%Zwischenrohr 1 - 2
rectangle('Position',[tank_width 0.05*tank_heigth 0.2*tank_width 0.05*tank_heigth],'FaceColor',rohr1_col,'EdgeColor',[0,0,0]);
%Zwischenrohr 2 - 3
if(model==3)
    rectangle('Position',[2.2*tank_width 0.05*tank_heigth 0.2*tank_width 0.05*tank_heigth],'FaceColor',rohr1_col,'EdgeColor',[0,0,0]);
end

%Zufluss 1
rectangle('Position',[-2.75 -5 1.25 tank_heigth+7.5],'FaceColor',z1_color,'EdgeColor',z1_color);
rectangle('Position',[-2.75 tank_heigth+2.5 2.75+0.15*tank_width 0.75],'FaceColor',z1_color,'EdgeColor',z1_color);


%Zufluss 3
if(model==3)
    rectangle('Position',[3.4*tank_width+1 -5 1.25 tank_heigth+7.5],'FaceColor',z1_color,'EdgeColor',z1_color);
    rectangle('Position',[3.4*tank_width-2.75 tank_heigth+2.5 2.75+0.15*tank_width 0.75],'FaceColor',z1_color,'EdgeColor',z1_color);
end

%Tisch
if(model==3)
    rectangle('Position',[-5 -tisch_height-1 3.4*tank_width+10 tisch_height],'FaceColor',tisch_col,'EdgeColor',[0,0,0]);
else
    rectangle('Position',[-5 -tisch_height-1 2.2*tank_width+10 tisch_height],'FaceColor',tisch_col,'EdgeColor',[0,0,0]);    
end

%Tankbeine
rectangle('Position',[0.1*tank_width -1 0.1*tank_width 1],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
rectangle('Position',[0.8*tank_width -1 0.1*tank_width 1],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
rectangle('Position',[1.3*tank_width -1 0.1*tank_width 1],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
rectangle('Position',[2.0*tank_width -1 0.1*tank_width 1],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
if(model==3)
    rectangle('Position',[2.5*tank_width -1 0.1*tank_width 1],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
    rectangle('Position',[3.2*tank_width -1 0.1*tank_width 1],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
end

%Ablussrohre
rectangle('Position',[0.45*tank_width -4 0.1*tank_width 4],'FaceColor',rohr1_col,'EdgeColor',[0,0,0]);
rectangle('Position',[1.65*tank_width -4 0.1*tank_width 4],'FaceColor',rohr1_col,'EdgeColor',[0,0,0]);
if(model==3)
    rectangle('Position',[2.85*tank_width -4 0.1*tank_width 4],'FaceColor',rohr1_col,'EdgeColor',[0,0,0]);
end
% Wasser im Boden

boden1=plot(sin2_temp-5,0.1*sin(sin2_temp)-1-2,'Color',abw_col,'LineWidth',20);
if(model==3)
    boden2=rectangle('Position',[-5 -5 3.4*tank_width+10 2],'FaceColor',abw_col,'EdgeColor',abw_col);
else
    boden2=rectangle('Position',[-5 -5 2.2*tank_width+10 2],'FaceColor',abw_col,'EdgeColor',abw_col);   
end

%Tischbeine
rectangle('Position',[0 -5 0.1*tank_width 5-tisch_height-1],'FaceColor',tisch_col,'EdgeColor',[0,0,0]);
if(model==3)
    rectangle('Position',[2.1*tank_width -5 0.1*tank_width 5-tisch_height-1],'FaceColor',tisch_col,'EdgeColor',[0,0,0]);
end

%Dummys
tank1=line([0,0],[0,0]);
tank2=line([0,0],[0,0]);
tank3=line([0,0],[0,0]);

pfeil1=line([0,0],[0,0]);
pfeil2=line([0,0],[0,0]);
pfeil3=line([0,0],[0,0]);

a1_p=line([0,0],[0,0]);
a2_p=line([0,0],[0,0]);
a3_p=line([0,0],[0,0]);

z1_p=line([0,0],[0,0]);
z3_p=line([0,0],[0,0]);


%%
for i=1:length(h1)
    
    figure(animation_plot);
    
    %delete old eleemts
    delete(tank1);
    delete(tank2);
    delete(tank3);
    
    delete(pfeil1);
    delete(pfeil2);
    delete(pfeil3);
    
    delete(a1_p);
    delete(a2_p);
    delete(a3_p);
    
    delete(z1_p);
    delete(z3_p);
    
    delete(boden1);
    delete(boden2);
    
    %plot water h1 and h2 and h3
    tank1=plot(sin_temp,0.1*sin(sin_temp+i*0.1)+h1(i),'Color',[0,0,1],'LineWidth',2);
    tank2=plot(sin_temp+1.2*tank_width,0.1*sin(sin_temp+i*0.1)+h2(i),'Color',[0,0,1],'LineWidth',2);
    if(model==3)
        tank3=plot(sin_temp+2.4*tank_width,0.1*sin(sin_temp+i*0.1)+h3(i),'Color',[0,0,1],'LineWidth',2);
    end
    
    %Plot arrow for direction of q12
    if(q12<0)
        pfeil1=line([1.05*tank_width 1.15*tank_width] ,[0.075*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        pfeil2=line([1.05*tank_width 1.075*tank_width],[0.075*tank_heigth 0.090*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        pfeil3=line([1.05*tank_width 1.075*tank_width],[0.075*tank_heigth 0.060*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        
    elseif(q12>0)
        pfeil1=line([1.05*tank_width 1.15*tank_width] ,[0.075*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        pfeil2=line([1.125*tank_width 1.15*tank_width],[0.090*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        pfeil3=line([1.125*tank_width 1.15*tank_width],[0.060*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
    end

        
    %Plot arrow for direction of q12
    if(model==3)
        if(q23(i)<0)
            pfeil1=line([2.25*tank_width 2.35*tank_width] ,[0.075*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
            pfeil2=line([2.25*tank_width 2.275*tank_width],[0.075*tank_heigth 0.090*tank_heigth],'Color',[0,0,1],'LineWidth',2);
            pfeil3=line([2.25*tank_width 2.275*tank_width],[0.075*tank_heigth 0.060*tank_heigth],'Color',[0,0,1],'LineWidth',2);

        elseif(q23(i)>0)
            pfeil1=line([2.25*tank_width 2.35*tank_width] ,[0.075*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
            pfeil2=line([2.325*tank_width 2.35*tank_width],[0.090*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
            pfeil3=line([2.325*tank_width 2.35*tank_width],[0.060*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        end
    end
    
    
    %Plot a1 and a2 and a3
    a1_p=rectangle('Position',[0.45*tank_width+a_width*(a1(i)*(0.5-1)/a_max+0.5) -4 a_width*a1(i)/a_max 4],'FaceColor',abw_col,'EdgeColor',abw_col);
    a2_p=rectangle('Position',[1.65*tank_width+a_width*(a2(i)*(0.5-1)/a_max+0.5) -4 a_width*a2(i)/a_max 4],'FaceColor',abw_col,'EdgeColor',abw_col);
    if(model==3)
        a3_p=rectangle('Position',[2.85*tank_width+a_width*(a3(i)*(0.5-1)/a_max+0.5) -4 a_width*a3(i)/a_max 4],'FaceColor',abw_col,'EdgeColor',abw_col);
    end
    
    %Plot z1 und z3
    z1_p=rectangle('Position',[0.05*tank_width+0.5+z_width*(z1(i)*(0.5-1)/z_max) 0.1*sin(0.15+i*0.1+0.6)+h1(i) z_width*z1(i)/z_max tank_heigth-0.1*sin(0.15+i*0.1+0.6)-h1(i)+2.5],'FaceColor',[0,0,1],'EdgeColor',[0,0,1]);
    if(model==3)
        z3_p=rectangle('Position',[3.4*tank_width-2.75+z_width*(z_max-z3(i))/z_max 0.1*sin(0.15+i*0.1+0.6)+h3(i) z_width*z3(i)/z_max tank_heigth-0.1*sin(0.15+i*0.1+0.6)-h3(i)+2.5],'FaceColor',[0,0,1],'EdgeColor',[0,0,1]);
    end
    
    %Blot ground water
    boden1=plot(sin2_temp-5,0.1*sin(sin2_temp+i*0.1)-1-2,'Color',abw_col,'LineWidth',10);
    if(model==3)
        boden2=rectangle('Position',[-5 -5 3.4*tank_width+10 2],'FaceColor',abw_col,'EdgeColor',abw_col);
    else
        boden2=rectangle('Position',[-5 -5 2.2*tank_width+10 2],'FaceColor',abw_col,'EdgeColor',abw_col);     
    end
    
    if(video_on==1)
        writeVideo(writerObj,getframe);
        title(sprintf('Frame %d/%d',i,length(h1)));
    else
        pause(0.000001);
    end
    
end
% Video speichern
if(video_on==1)
    close(writerObj);
end

end

