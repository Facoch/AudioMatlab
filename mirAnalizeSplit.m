%this function returns the matrix 'm' containing the information about the
%potential cuts on my audio file
function [m]= mirAnalizeSplit(audio,Fs, k, interval)

mirverbose(0); %mir doesn't write in command window
AU = miraudio(audio',Fs);
SPEC = mirspectrum(AU, 'Frame','dB','Min', 15000, 'Max',35000);

centroid= mircentroid(SPEC);	%calculate the centroid of each frame
DATA= mirgetdata(centroid)/100;

duration=length(audio)/Fs;
T=[duration/numel(DATA):duration/numel(DATA):duration];

%calculate the moving average at 40%
movingAverage = smooth(DATA,0.4,'moving');
%cuts the DATA values under moving average
DATA(DATA<movingAverage') = movingAverage(DATA<movingAverage');

%find peaks
[m(2,:),m(1,:),w,p]=findpeaks(DATA,T,'MinPeakProminence',0.6,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.1, 'MinPeakHeight',-245,'Annotate','extents');
figure(k+5);
plot(T,DATA,m(1,:),m(2,:),'o')
m(3,:)=3;
m(4,:)=1/6;
m(5,:)=p/((sum(p)-0.6*numel(p)));




