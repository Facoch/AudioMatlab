%this function returns the matrix 'm' containing the information about the
%potential cuts on my audio file
function [m]= analizeContinuity(audio,Fs, k, interval)

%define FFT parameters
Nfft= round(21*8192/40);  

%generate the spectrogram's matrices
[~,f,t,ps]=spectrogram(audio, Nfft, Fs/50, Nfft, Fs,'yaxis','MinThreshold', -205);
%draw spectrograms
%figure(k+3);
%spectrogram(audio, Nfft, Fs/50), Nfft, Fs,'yaxis','MinThreshold', -205);  

%search index of 15,20 kHz (FROM, TO1, TO2)
FROM=searchFrequencyIndex(f,15000);
TO=searchFrequencyIndex(f,35000);

%inizialize parameters
DIMT = size(t);
V=DIMT(2);
 for j=1:DIMT(2)
    
    S=0;
    for i=FROM:TO  
        
        S = S+abs((ps(i,j)-ps(i+10,j)));       
    end
    pw=db(S/(1+TO-FROM));
    V(j)=pw;
 end

%calculate the moving average at 40%
movingAverage = smooth(V,0.4,'moving');
%cuts the V values under moving average
V(V<movingAverage') = movingAverage(V<movingAverage');

%find peaks
[m(2,:),m(1,:),~,p]= findpeaks(V,t,'MinPeakProminence',7,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.15, 'MinPeakHeight',-245,'Annotate','extents');

%plot graph with peaks
figure(k+4);
findpeaks(V,t,'MinPeakProminence',7,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.15, 'MinPeakHeight',-245,'Annotate','extents')
% plot(t,V,m(1,:),m(2,:),'o')
% xlim([t(1) t(end)]);
% grid on;

%add information
m(3,:)=2;           %number of algorythm
m(4,:)=1/6;         %probability p1
m(5,:)=p/sum(p);    %probability p2

