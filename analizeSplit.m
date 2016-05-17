%this function returns the matrix 'm' containing the information about the
%potential cuts on my audio file
function [m]= analizeSplit(audio,Fs, k, interval)

%define FFT parameters
Nfft= round(21*8192/40);  

%generate the spectogram's matrices
[~,f,t,ps]=spectrogram(audio, Nfft, Fs/50, Nfft, Fs);

%draw spectograms
figure(k+1);
spectrogram(audio, Nfft, Fs/50, Nfft, Fs,'yaxis'); 
%spectrogram(audio,hanning(Nfft),Fs/50,Nfft,Fs,'yaxis'); %hanning spectrogram

%search index of 15,20,35 kHz (FROM, TO1, TO2)
FROM=searchFrequencyIndex(f,15000);%*Fs/96000);
TO=searchFrequencyIndex(f,35000);%*Fs/96000);

DIMT = size(t);
V=DIMT(2);
%calculate frame by frame the mean of all the power spectral density 'ps' 
%belonging to frequences [FROM, TO]Il seguente ciclo scorre tutti i tempi 
%e calcola la media delle potenze. Put it in the array V, same length of t
for j=1:DIMT(2)             		%tempi del vettore t
     V(j)=db(mean(ps(FROM:TO,j))); 	%media dei valori compresi tra FROM e TO2
end

%calculate the moving average at 40%
movingAverage = smooth(V,0.4,'moving');
%cuts the V values under moving average
V(V<movingAverage') = movingAverage(V<movingAverage');


%find peaks
[m(2,:),m(1,:),w,p]=findpeaks(V,t,'MinPeakProminence',10,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.2, 'MinPeakHeight',-245,'Annotate','extents');

%plot graph with peaks
figure(k+2);
plot(t,V,m(1,:),m(2,:),'o');
xlim([t(1) t(end)]);
grid on;

%add information
m(3,:)=1;           %number of algorythm
m(4,:)=1/6;         %probability p1
m(5,:)=p/sum(p);    %probability p2





