%this function returns the table 'x' containing the information about the
%potential cuts on my audio file
function [x]= analizeSplit(audio,Fs, k, interval)

%define FFT parameters
des_df_Hz = 25;  %desired frequency resolution for the display, Hz
Nfft1= 8192;  %general rule for FFT resolution %2 is empirical
Nfft2=512;

%generate the spectogram's matrices
[s,f,t,ps]=spectrogram(audio, Nfft1, round(0.5*Nfft1), Nfft1, Fs,'yaxis');
%draw spectograms
figure(k+1);
spectrogram(audio, Nfft1, round(0.5*Nfft1), Nfft1, Fs,'yaxis'); 


%search index of 15,20,35 kHz (FROM, TO1, TO2)
FROM=searchFrequencyIndex(f,10000*Fs/96000);
TO1=searchFrequencyIndex(f,30000*Fs/96000);
TO2=searchFrequencyIndex(f,35000*Fs/96000);
f(FROM)
f(TO2)
size(f)

DIMT = size(t);
% il seguente ciclo for � solo per cercare di avere una 'media' dei valori
% cos� da impostare il 'valore soglia' nel prossimo ciclo for
% questa parte � da migliorare molto!
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
%frequenze comprese tra FROM (15kHz) e TO2 (40kHz); se la media � superiore
%del 'valore soglia' quell'istante della canzone � un possibile taglio sul 
%nastro quindi ne salvo le informazioni in Numero, Tempo e Valore.
Numero=[];
Tempo=[];
Valore=[];
COUNT=1;
V=[DIMT(2)];
for j=1:DIMT(2)             %tempi del vettore t
     time= (t(j)+interval*k);   
     time=fix(time/60)+(time-fix(time/60)*60)/100;
     pw = db(mean(s(FROM:TO2,j)));                 %media compresa tra FROM e TO2
     V(j)=pw;
     %fprintf('\ns= %f  ps= %f  t= %f',db(mean(s(:,j))), pw, time);
     if(-243<pw)
             Numero(COUNT)=COUNT;
             Tempo(COUNT)=time;
             Valore(COUNT)=pw;
             COUNT=COUNT+1;
            end
end
%print a table that collects 3 vectors and some other interesting values
[MAX,I]=max(Valore);
figure(k+2);
plot(t,V);
figure(k+3);
findpeaks(V,t,'MinPeakProminence',5,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.2, 'MinPeakHeight',-245,'Annotate','extents')
%[idx,C] = kmeans(ps, DIMT(2))
x=table(Numero', Tempo', Valore','VariableNames',{'Numero' 'Tempo' 'Valore'});
fprintf('Media= %.2f   Media tutti=%.2f\nMAX= %.2f  at Time= %.4f\n',mean(Valore),MEDTOT, MAX, Tempo(I));
fprintf('\n---------------------------\n');

% pw = db(mean(ps(FROM:TO2,j))); INVERTIRE db E mean? COSA CAMBIA PER NOI??


