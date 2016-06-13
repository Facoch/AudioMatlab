%this function returns the matrix 'm' containing the information about the
%potential cuts on my audio file
function [m]= mirAnalizeSplit(audio,Fs, k, interval)

mirverbose(0); %mir doesn't write in command window
AU = miraudio(audio',Fs);
SPEC = mirspectrum(AU, 'Frame','dB','Min', 15000, 'Max',35000);

centroid= mircentroid(SPEC);	%calculate the centroid of each frame
DATA= mirgetdata(centroid)/100;

%creating the vector of the times with same length of the data vector
duration=length(audio)/Fs;
t=duration/numel(DATA):duration/numel(DATA):duration;

%calculate the moving average at 40%
movingAverage = smooth(DATA,0.4,'moving');
%cuts the DATA values under moving average
DATA(DATA<movingAverage') = movingAverage(DATA<movingAverage');

%find peaks
[m(2,:),m(1,:),~,p]=findpeaks(DATA,t,'MinPeakProminence',0.6,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.1, 'MinPeakHeight',-245,'Annotate','extents');

%plot graph with peaks
figure(k+5);
plot(t,DATA,m(1,:),m(2,:),'o')
xlim([t(1) t(end)]);
grid on;

%add information
m(3,:)=3;           %number of algorythm
m(4,:)=1/6;         %probability p1
m(5,:)=p/sum(p);    %probability p2




