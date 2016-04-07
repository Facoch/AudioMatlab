%this function returns the table 'x' containing the information about the
%potential cuts on my audio file
function [x]= analizeSplit(audio,Fs, k, interval)



%define FFT parameters
des_df_Hz = 25;  %desired frequency resolution for the display, Hz
Nfft= 1.6*round(round(Fs / des_df_Hz));  %general rule for FFT resolution %1.6 is empirical

%generate the spectogram's matrices
[s,f,t,ps]=spectrogram(audio, Nfft, round(0.5*Nfft), Nfft, Fs,'yaxis');
%draw spectograms
figure(k+1);
spectrogram(audio, Nfft, round(0.4*Nfft), Nfft, Fs,'yaxis','MinThreshold',-200);
%xlim([1.1 1.4]); 

%search index of 15,20,40 kHz (FROM, TO1, TO2)
FROM=searchFrequencyIndex(f,13000);
TO1=searchFrequencyIndex(f,20000);
TO2=searchFrequencyIndex(f,40000);
   

DIMT = size(t);
% il seguente ciclo for è solo per cercare di avere una 'media' dei valori
% così da impostare il 'valore soglia' nel prossimo ciclo for
% questa parte è da migliorare molto!
STOT=0;
COUNT=0;
for j=1:DIMT(2)         %tempi del vettore t
    S=0;
    for i=FROM:TO1      %Frequenze da FROM a TO1
        S = S+ps(i,j);
    end
    if (-250<db(S/(1+TO1-FROM)))          %sommo solo i tempi di non silenzio
        STOT = STOT+db(S/(1+TO1-FROM));
        COUNT=COUNT+1;
    end
end
MEDTOT= (STOT/COUNT);
COUNT=1;

%Il seguente ciclo scorre tutti i tempi e somma i valori di 'ps' per
%frequenze comprese tra FROM (15kHz) e TO2 (40kHz); se la media è superiore
%del 'valore soglia' quell'istante della canzone è un possibile taglio sul 
%nastro quindi ne salvo le informazioni in Numero, Tempo e Valore.

Numero=[];
Tempo=[];
Valore=[];
for j=1:DIMT(2)         %tempi del vettore t
    S=0;
    for i=FROM:TO2      %frequenza da FROM a TO2
        S = S+ps(i,j);
    end
    pw=db(S/(1+TO2-FROM));    
    if(MEDTOT+5<pw)         %confronto con valore soglia (MEDTOT è la media mentre 5 è un valore empirico
         time= t(j)+interval*k;
         Numero(COUNT)=COUNT;
         Tempo(COUNT)=fix(time/60)+((time-fix(time/60)*60)/100);
         Valore(COUNT)=pw;
         COUNT=COUNT+1;
        end
end

%print a table that collects 3 vectors and some other interesting values
[MAX,I]=max(Valore);

x=table(Numero', Tempo', Valore','VariableNames',{'Numero' 'Tempo' 'Valore'});
fprintf('Media= %.2f   Media tutti=%.2f\nMAX= %.2f  at Time= %.4f\n',mean(Valore),MEDTOT, MAX, Tempo(I));
fprintf('\n---------------------------\n');




