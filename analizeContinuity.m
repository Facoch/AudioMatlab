%this function returns the table 'x' containing the information about the
%potential cuts on my audio file
function [m]= analizeContinuity(audio,Fs, k, interval)

%define FFT parameters
Nfft= 8192;  
%generate the spectogram's matrices
[s,f,t,ps]=spectrogram(audio, Nfft, round(0.5*Nfft), Nfft, Fs,'yaxis');
%draw spectograms
%figure(k+3);
%spectrogram(audio, Nfft, round(0.5*Nfft), Nfft, Fs,'yaxis');  

%search index of 15,20 kHz (FROM, TO1, TO2)
FROM=searchFrequencyIndex(f,15000);
TO=searchFrequencyIndex(f,30000);

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
 
figure(k+4);
findpeaks(V,t,'MinPeakProminence',6,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.2, 'MinPeakHeight',-246,'Annotate','extents')
[m(2,:),m(1,:)]= findpeaks(V,t,'MinPeakProminence',6,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.2, 'MinPeakHeight',-246,'Annotate','extents');
for i=1:(numel(m)/2)
     time= (m(1,i)+interval*k);   
     m(1,i)=fix(time/60)+(time-fix(time/60)*60)/100;
end
m=m';
m(:,3)=2;
