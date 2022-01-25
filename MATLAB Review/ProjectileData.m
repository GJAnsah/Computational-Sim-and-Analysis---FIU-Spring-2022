%BME6717 Data Project 1

% BME 6717: MATLAB Objects Dataset

% Data have been gathered on launching a projectile underwater with a fixed force,
% for multiple different launch angles. The data are organized in the object,
% Projectiles, obtained by loading the file
% UnderwaterProjectileData.mat, in the following way: The first column of the cell
% array contains the angle of launch, and the second column of the cell array contains
% the trajectory of the projectile until the sample just before impact with the sea
% floor as a 2D array, with row 1 being the horizontal coordinate (x) and row 2 being
% the vertical coordinate (y).

% Using "object oriented" and/or "modular" programming philosophy,
% write the code to determine the following:

% 1.	What launch angle is best for maximizing horizontal distance?
% 2.	What launch angle is best for maximizing height?
% 3.	What launch angle creates the minimum variability of time spent
% above the sea floor (“hang time”)?
% 4.	Ask and answer an additional question of your choosing about the data.

%% Creating cell array to store angles and all trials of that angle

Projectiles=importdata('UnderwaterProjectileData.mat');

[C,ia,ic] = unique([Projectiles{:,1}]);
freq=accumarray(ic,ic,[],@length);
n=length(C);

%angles cell array contains 2 columns
%column 1 is the angle
%column 2 contains the trajectories of each time that launch angle was used
angles = cell(n,2);

for k=1:n
    angles{k,1}=C(k);
    angles{k,2}=Projectiles(ic==k,2);
end


% Soluions
maxDist=cell(n,4);
maxheight=cell(n,4);
variability =cell(n,5);
maxTotDis=zeros(n,1);
cmp=vertcat(hsv(4),turbo(4));
all_times=[];

for i=1:n
    angle=Angle(angles{i},angles{i,2});
    [x,d]=xVals(angle);
    [y,h]=yVals(angle);
    time_of_flights=time(angle);
    all_times=vertcat(all_times,time_of_flights);
    
   
    figure(1)
    disp(angle,x,y,cmp(i,:))
    title('Trajectory of projectiles')
    xlabel('horizontal coordinates(m)')
    ylabel('vertical coordinates(m)')
    
    maxDist{i,1}=angles{i};
    maxDist{i,2}= max(d);
    maxDist{i,3}=mean(d);
    maxDist{i,4}=median(d);
    
    
    maxheight{i,1}=angles{i};
    maxheight{i,2}= max(h);
    maxheight{i,3}=mean(h);
    maxheight{i,4}=median(h);
    
    variability {i,1}=angles{i};
    variability {i,2}= iqr(time_of_flights);
    variability {i,3}=range(time_of_flights);
    variability {i,4}=var(time_of_flights);
    variability {i,5}=std(time_of_flights);
    
    
    figure (2)
    for k=1:freq(i)
        maxTotDis(i)=max(maxTotDis(i),max(sqrt(x{k}.^2+y{k}.^2)));
        plot(sqrt(x{k}.^2+y{k}.^2),'color',cmp(i,:))
        ylabel('projectile displacement(m)')
        xlabel('time(s)')
        title('magnitudes of the trajectories')
        hold on
    end

end


figure(3)
char=[];
for i=1:8
    char=[char,repmat(angles{i},1,freq(i))];
end
boxplot(all_times,char)
ylabel('time of flight(s)')
title('time variability of different launch angles')


[m,ix]=max(cellfun(@max, maxDist(:,2:end)));
angle_bestDistance= maxDist{ix(1)}

[m,ix]=max(cellfun(@max, maxheight(:,2:end)));
angle_bestHeight= maxheight{ix(1)}

[m,ix]=min(cellfun(@min, variability(:,2:end)));
angle_minVar= variability{ix(1)}

% How many times was each launch angle used?
freq

%which launch angle had the max total displacement
[m,ix]=max(maxTotDis);
disp(angles{ix})
%%
lineHandles = get( gca, 'Children' );

lineIndex=cumsum(freq,'reverse');
lines=zeros(n,1);
legends={n,1};
for i=1:n
lines(i)=lineHandles(lineIndex(i));
legends(i)={num2str(angles{i})};
end
legend(lines,legends)
leg = legend('show');
title(leg,'Launch Angle')