%this function returns the matrix 'm' containing the information about the
%potential cuts on my audio file
function [m]= analizeContinuity(audio,Fs, k, interval)

%define FFT parameters
Nfft= 8192;  
%generate the spectogram's matrices
[s,f,t,ps]=spectrogram(audio, Nfft, Fs/50, Nfft, Fs,'yaxis','MinThreshold', -205);
%draw spectograms
%figure(k+3);
%spectrogram(audio, Nfft, Fs/50), Nfft, Fs,'yaxis','MinThreshold', -205);  

%search index of 15,20 kHz (FROM, TO1, TO2)
FROM=searchFrequencyIndex(f,15000);
TO=searchFrequencyIndex(f,35000);

%inizialize parameters
DIMT = size(t);
COUNT=1;
V=[DIMT(2)];
 for j=1:DIMT(2)
    S1=0;
    S2=0;
    for i=FROM:TO  
        S1 = S1+abs((ps(i,j)-ps(i+1,j)));
        S2 = S2+abs((ps(i,j)-ps(i+10,j)));       
    end
    pw=db(S2/(1+TO-FROM));
    V(j)=pw;
 end

%calculate the moving average at 40%
movingAverage = smooth(V,0.4,'moving');
%cuts the V values under moving average
V(V<movingAverage') = movingAverage(V<movingAverage');

%find peaks
figure(k+4);
findpeaks(V,t,'MinPeakProminence',5,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.2, 'MinPeakHeight',-245,'Annotate','extents')
[m(2,:),m(1,:)]= findpeaks(V,t,'MinPeakProminence',5,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.2, 'MinPeakHeight',-245,'Annotate','extents');
for i=1:length(m)
     time= (m(1,i)+interval*k);   
     m(1,i)=fix(time/60)+(time-fix(time/60)*60)/100;
end
m=m';
m(:,3)=2;
