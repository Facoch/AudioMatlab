%this function returns the matrix 'm' containing the information about the
%potential cuts on my audio file
function [m]= hpFilt(audio,Fs, k, interval)

audio=audio';
%create the high pass filter
highpassFilt = designfilt('highpassiir','FilterOrder',8, ...
         'PassbandFrequency',22e3,'PassbandRipple',0.2, ...
         'SampleRate',96000);

%filtering the audio
audioFilt = filter(highpassFilt,audio);

%creating the vector of the times with same length of the data vector
duration = length(audio)/Fs;
t=duration/numel(audioFilt):duration/numel(audioFilt):duration;

%find peaks
[m(2,:),m(1,:),~,p]=findpeaks(abs(audioFilt),t,'MinPeakProminence',0.0005,'MinPeakDistance', 0.1,'Annotate','extents');

%plot graph with peaks
figure(k+8);
plot(t,abs(audioFilt),m(1,:),m(2,:),'o')
xlim([t(1) t(end)]);
grid on;

%add information
m(3,:)=6;           %number of algorythm
m(4,:)=1/6;         %probability p1
m(5,:)=p/sum(p);    %probability p2

