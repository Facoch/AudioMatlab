%this function returns the table 'x' containing the information about the
%potential cuts on my audio file
function [m]= analizeSplit(audio,Fs, k, interval)

%define FFT parameters
Nfft= 8192;  
%generate the spectogram's matrices
[s,f,t,ps]=spectrogram(audio, Nfft, round(0.5*Nfft), Nfft, Fs,'yaxis');
%draw spectograms
figure(k+1);
spectrogram(audio, Nfft, round(0.5*Nfft), Nfft, Fs,'yaxis'); 


%search index of 15,20,35 kHz (FROM, TO1, TO2)
FROM=searchFrequencyIndex(f,17000);%*Fs/96000);
TO1=searchFrequencyIndex(f,30000);%*Fs/96000);
TO2=searchFrequencyIndex(f,35000);%*Fs/96000);


DIMT = size(t);
% il seguente ciclo for è solo per cercare di avere una 'media' dei valori
% così da impostare il 'valore soglia' nel prossimo ciclo for
% questa parte è da migliorare molto!
STOT=0;
COUNT=0;
for j=1:DIMT(2)         %tempi del vettore t
    
    pw = db(mean(ps(FROM:TO1,j)));      %media compresa tra FROM e TO1
    if (-250<pw)          %sommo solo i tempi di non silenzio
        STOT = STOT+pw;
        COUNT=COUNT+1;   
    end
end
MEDTOT= (STOT/COUNT);


%Il seguente ciclo scorre tutti i tempi e somma i valori di 'ps' per
%frequenze comprese tra FROM (15kHz) e TO2 (40kHz); se la media è superiore
%del 'valore soglia' quell'istante della canzone è un possibile taglio sul 
%nastro quindi ne salvo le informazioni in Numero, Tempo e Valore.
COUNT=1;
V=[DIMT(2)];
for j=1:DIMT(2)             %tempi del vettore t
     pw = db(mean(ps(FROM:TO2,j)));                 %media compresa tra FROM e TO2
     V(j)=pw;
end

%find peaks
figure(k+2);
findpeaks(V,t,'MinPeakProminence',5,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.2, 'MinPeakHeight',-245,'Annotate','extents')
[m(2,:),m(1,:)]=findpeaks(V,t,'MinPeakProminence',5,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.2, 'MinPeakHeight',-245,'Annotate','extents');
for i=1:(numel(m)/2)
     time= (m(1,i)+interval*k);   
     m(1,i)=fix(time/60)+(time-fix(time/60)*60)/100;
end
m=m';
m(:,3)=1;


