%this function returns the matrix 'm' containing the information about the
%potential cuts on my audio file
function [m]= mirAnalizeSkew(audio,Fs, k, interval)

mirverbose(0); %mir doesn't write in command window
AU = miraudio(audio',Fs);
SPEC = mirspectrum(AU, 'Frame',0.1,'dB','Min', 15000, 'Max',35000);

skewness = mirskewness(SPEC);        %SKEWNESS: asymmetry coefficient
s= mirgetdata(skewness)*100;

%creating the vector of the times with same length of the data vector
duration=length(audio)/Fs;
t=duration/numel(s):duration/numel(s):duration;

%calculate the moving average at 40%
movingAverage = smooth(s,0.4,'moving');
%cuts the V values under moving average
s(s>movingAverage') = movingAverage(s>movingAverage');

%find peaks
[m(2,:),m(1,:),~,p]=findpeaks(s,t,'MinPeakProminence',0.8,'MinPeakDistance', 0.15,'Threshold',1e-4,'Annotate','extents');

%plot graph with peaks
figure(k+6);
plot(t,s,m(1,:),m(2,:),'o')
xlim([t(1) t(end)]);
grid on;

%add information
m(3,:)=4;           %number of algorythm
m(4,:)=1/6;         %probability p1
m(5,:)=p/sum(p);    %probability p2






