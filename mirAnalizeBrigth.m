%this function returns the matrix 'm' containing the information about the
%potential cuts on my audio file
function [m]= mirAnalizeBrigth(audio,Fs, k, interval)

mirverbose(0); %mir doesn't write in command window
AU = miraudio(audio',Fs);
SPEC = mirspectrum(AU, 'Frame',0.1,'dB','Min', 15000, 'Max',35000);

brightness = mirbrightness(SPEC,'CutOff',20000); %BRIGHTNESS and measuring the amount of energy above a fixed frequency
b= mirgetdata(brightness)*100;

%creating the vector of the times with same length of the data vector
duration=length(audio)/Fs;
t=duration/numel(b):duration/numel(b):duration;

%calculate the moving average at 40%
movingAverage = smooth(b,0.4,'moving');
%cuts the V values under moving average
b(b<movingAverage') = movingAverage(b<movingAverage');

%find peaks
[m(2,:),m(1,:),~,p]=findpeaks(b,t,'MinPeakProminence',0.8,'MinPeakDistance', 0.15,'Threshold',1e-4,'Annotate','extents');

%plot graph with peaks
figure(k+7);
plot(t,b,m(1,:),m(2,:),'o')
xlim([t(1) t(end)]);
grid on;

%add information
m(3,:)=5;           %number of algorythm
m(4,:)=1/6;         %probability p1
m(5,:)=p/sum(p);    %probability p2





