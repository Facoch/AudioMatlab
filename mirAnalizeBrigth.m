%this function returns the matrix 'm' containing the information about the
%potential cuts on my audio file
function [m]= mirAnalizeBrigth(audio,Fs, k, interval)

mirverbose(0); %mir doesn't write in command window
AU = miraudio(audio',Fs);
SPEC = mirspectrum(AU, 'Frame',0.1,'dB','Min', 15000, 'Max',35000);

brightness = mirbrightness(SPEC,'CutOff',20000); %BRIGHTNESS and measuring the amount of energy above a fixed frequency
b= mirgetdata(brightness)*100;
 
duration=length(audio)/Fs;
T=[duration/numel(b):duration/numel(b):duration];

%calculate the moving average at 40%
movingAverage = smooth(b,0.4,'moving');
%cuts the V values under moving average
b(b<movingAverage') = movingAverage(b<movingAverage');

%find peaks
figure(k+7);
findpeaks(b,T,'MinPeakProminence',0.8,'MinPeakDistance', 0.15,'Threshold',1e-4,'Annotate','extents')
[m(2,:),m(1,:)]=findpeaks(b,T,'MinPeakProminence',0.8,'MinPeakDistance', 0.15,'Threshold',1e-4,'Annotate','extents');
m(3,:)=5;
m(4,:)=0.2;





