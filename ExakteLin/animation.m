function [] = animation( h1,h2,q12,a1,a2,z1,anim_on,video_on)

if(min(anim_on)==0)
    return;
end
pfad='test.avi';

if(video_on==1)
    writerObj = VideoWriter(pfad);
    writerObj.FrameRate=25;
    open(writerObj);
end

h_max=0.5;          % 500 ml
z_max= 7.5e-5;      % 4.5l/min
a_max=max([a1;a2]); % maximal auftretendes a

h1=h1.*10./h_max;
h2=h2.*10./h_max;



%Reduce
h1=h1(1:10:end);
h2=h2(1:10:end);
a1=a1(1:10:end);
a2=a2(1:10:end);
z1=z1(1:10:end);
q12=q12(1:10:end);


tank_width=15;
tank_heigth=10;
tisch_height=0.5;
a_width=0.1*tank_width;
z_width=0.1*tank_width;

sin_temp  = 0:tank_width/100:tank_width;
sin2_temp = 0:tank_width/100:2.2*tank_width+10 + 2;


z1_color  = [0.5,0.5,0.5];
rohr1_col = [0.5,0.5,0.5];
tank_col  = [0.9,0.9,0.9];
tisch_col = [0.4,0.1,0.4];
abw_col   = [0.2,0.2,1];

%Figure
animation_plot=figure('Name','Simulation Plot Window','NumberTitle','off','units','normal','outerposition',[0 0 1 1]);
hold on;
xlim([-5 2.2*tank_width+5]);
ylim([-5 tank_heigth+5]);
axis square;

%Tanks
rectangle('Position',[0 0 tank_width tank_heigth],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
rectangle('Position',[1.2*tank_width 0 tank_width tank_heigth],'FaceColor',tank_col,'EdgeColor',[0,0,0]);

% SOll H2
line([1.2*tank_width,2.2*tank_width],[0.2/h_max*10,0.2/h_max*10])

%Zwischenrohr 1 - 2
rectangle('Position',[tank_width 0.05*tank_heigth 0.2*tank_width 0.05*tank_heigth],'FaceColor',rohr1_col,'EdgeColor',[0,0,0]);

%Zufluss
rectangle('Position',[-2.75 -5 1.25 tank_heigth+7.5],'FaceColor',z1_color,'EdgeColor',z1_color);
rectangle('Position',[-2.75 tank_heigth+2.5 2.75+0.15*tank_width 0.75],'FaceColor',z1_color,'EdgeColor',z1_color);

%Tisch
rectangle('Position',[-5 -tisch_height-1 2.2*tank_width+10 tisch_height],'FaceColor',tisch_col,'EdgeColor',[0,0,0]);

rectangle('Position',[0.1*tank_width -1 0.1*tank_width 1],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
rectangle('Position',[0.8*tank_width -1 0.1*tank_width 1],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
rectangle('Position',[1.3*tank_width -1 0.1*tank_width 1],'FaceColor',tank_col,'EdgeColor',[0,0,0]);
rectangle('Position',[2.0*tank_width -1 0.1*tank_width 1],'FaceColor',tank_col,'EdgeColor',[0,0,0]);

%Ablussrohr
rectangle('Position',[0.45*tank_width -4 0.1*tank_width 4],'FaceColor',rohr1_col,'EdgeColor',[0,0,0]);
rectangle('Position',[1.65*tank_width -4 0.1*tank_width 4],'FaceColor',rohr1_col,'EdgeColor',[0,0,0]);

% Wasser im Boden

boden1=plot(sin2_temp-5,0.1*sin(sin2_temp)-1-2,'Color',abw_col,'LineWidth',20);
boden2=rectangle('Position',[-5 -5 2.2*tank_width+10 2],'FaceColor',abw_col,'EdgeColor',abw_col);


%Tischbeine
rectangle('Position',[0 -5 0.1*tank_width 5-tisch_height-1],'FaceColor',tisch_col,'EdgeColor',[0,0,0]);
rectangle('Position',[2*tank_width -5 0.1*tank_width 5-tisch_height-1],'FaceColor',tisch_col,'EdgeColor',[0,0,0]);


%Dummys
tank1=line([0,0],[0,0]);
tank2=line([0,0],[0,0]);
pfeil1=line([0,0],[0,0]);
pfeil2=line([0,0],[0,0]);
pfeil3=line([0,0],[0,0]);
a1_p=line([0,0],[0,0]);
a2_p=line([0,0],[0,0]);
z1_p=line([0,0],[0,0]);


%%
for i=1:length(h1)
    
    figure(animation_plot);
    
    %delete old eleemts
    delete(tank1);
    delete(tank2);
    delete(pfeil1);
    delete(pfeil2);
    delete(pfeil3);
    delete(a1_p);
    delete(a2_p);
    delete(z1_p);
    delete(boden1);
    delete(boden2);
    
    %plot water h1 and h2
    tank1=plot(sin_temp,0.1*sin(sin_temp+i*0.1)+h1(i),'Color',[0,0,1],'LineWidth',2);
    tank2=plot(sin_temp+1.2*tank_width,0.1*sin(sin_temp+i*0.1)+h2(i),'Color',[0,0,1],'LineWidth',2);
    
    %Plot arrow for direction of q12
    if(q12<0)
        pfeil1=line([1.05*tank_width 1.15*tank_width] ,[0.075*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        pfeil2=line([1.05*tank_width 1.075*tank_width],[0.075*tank_heigth 0.090*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        pfeil3=line([1.05*tank_width 1.075*tank_width],[0.075*tank_heigth 0.060*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        
    else
        pfeil1=line([1.05*tank_width 1.15*tank_width] ,[0.075*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        pfeil2=line([1.125*tank_width 1.15*tank_width],[0.090*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
        pfeil3=line([1.125*tank_width 1.15*tank_width],[0.060*tank_heigth 0.075*tank_heigth],'Color',[0,0,1],'LineWidth',2);
    end
    
    %Plot a1 and a2
    a1_p=rectangle('Position',[0.45*tank_width+a_width*(a1(i)*(0.5-1)/a_max+0.5) -4 a_width*a1(i)/a_max 4],'FaceColor',abw_col,'EdgeColor',abw_col);
    a2_p=rectangle('Position',[1.65*tank_width+a_width*(a2(i)*(0.5-1)/a_max+0.5) -4 a_width*a2(i)/a_max 4],'FaceColor',abw_col,'EdgeColor',abw_col);
    
    %Plot z1
    z1_p=rectangle('Position',[0.05*tank_width+z_width*(z1(i)*(0.5-1)/z_max+0.5) 0.1*sin(0.15+i*0.1+0.6)+h1(i) z_width*z1(i)/z_max tank_heigth-0.1*sin(0.15+i*0.1)-h1(i)+2.5],'FaceColor',[0,0,1],'EdgeColor',[0,0,1]);
    
    %Blot ground water
    boden1=plot(sin2_temp-5,0.1*sin(sin2_temp+i*0.1)-1-2,'Color',abw_col,'LineWidth',10);
    boden2=rectangle('Position',[-5 -5 2.2*tank_width+10 2],'FaceColor',abw_col,'EdgeColor',abw_col);
    
    
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

