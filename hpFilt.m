
function [m]= hpFilt(audio,Fs, k, interval)

highpassFilt = designfilt('highpassiir','FilterOrder',8, ...
         'PassbandFrequency',22e3,'PassbandRipple',0.2, ...
         'SampleRate',96000);
audio=audio';
audioFilt = filter(highpassFilt,audio);
duration = length(audio)/Fs;
T=[duration/numel(audioFilt):duration/numel(audioFilt):duration];

%find peaks
[m(2,:),m(1,:),w,p]=findpeaks(abs(audioFilt),T,'MinPeakProminence',0.0005,'MinPeakDistance', 0.1,'Annotate','extents')
figure(k+8);
plot(T,abs(audioFilt),m(1,:),m(2,:),'o')
m(3,:)=6;	
m(4,:)=1/6;
m(5,:)=p/((sum(p)-0.0005*numel(p)));

