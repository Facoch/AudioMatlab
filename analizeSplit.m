%this function returns the table 'x' containing the information about the
%potential cuts on my audio file
function [x]= analizeSplit(audio,Fs, k, interval)

%define FFT parameters
des_df_Hz = 25;  %desired frequency resolution for the display, Hz
Nfft= 2*round(round(Fs / des_df_Hz));  %general rule for FFT resolution %1.6 is empirical

%generate the spectogram's matrices
[s,f,t,ps]=spectrogram(audio, Nfft, round(0.5*Nfft), Nfft, Fs,'yaxis');
%draw spectograms
figure(k+1);
spectrogram(audio, Nfft, round(0.5*Nfft), [], Fs,'yaxis'); 

%search index of 15,20,35 kHz (FROM, TO1, TO2)

FROM=searchFrequencyIndex(f,15000);
TO1=searchFrequencyIndex(f,20000);
TO2=searchFrequencyIndex(f,35000);

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
Numero=[];
Tempo=[];
Valore=[];
COUNT=1;
for j=1:DIMT(2)             %tempi del vettore t
     time= (t(j)+interval*k);   
     time=fix(time/60)+(time-fix(time/60)*60)/100;
     pw = db(mean(ps(FROM:TO2,j)));                 %media compresa tra FROM e TO2
     %fprintf('\ns= %f  ps= %f  t= %f',db(mean(s(:,j))), pw, time);
     if(-244<pw)
             Numero(COUNT)=COUNT;
             Tempo(COUNT)=time;
             Valore(COUNT)=pw;
             COUNT=COUNT+1;
            end
end
%print a table that collects 3 vectors and some other interesting values
[MAX,I]=max(Valore);

x=table(Numero', Tempo', Valore','VariableNames',{'Numero' 'Tempo' 'Valore'});
fprintf('Media= %.2f   Media tutti=%.2f\nMAX= %.2f  at Time= %.4f\n',mean(Valore),MEDTOT, MAX, Tempo(I));
fprintf('\n---------------------------\n');

% pw = db(mean(ps(FROM:TO2,j))); INVERTIRE db E mean? COSA CAMBIA PER NOI??


