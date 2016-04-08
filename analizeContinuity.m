%this function returns the table 'x' containing the information about the
%potential cuts on my audio file
function [x]= analizeContinuity(audio,Fs, k, interval)

%define FFT parameters
des_df_Hz = 25;  %desired frequency resolution for the display, Hz
Nfft= 2*round(round(Fs / des_df_Hz));  %general rule for FFT resolution %1.6 is empirical

%generate the spectogram's matrices
[s,f,t,ps]=spectrogram(audio, Nfft, round(0.5*Nfft), Nfft, Fs,'yaxis');
%draw spectograms
%figure(k+1);
%spectrogram(audio, Nfft, round(0.5*Nfft), [], Fs,'yaxis'); 

%search index of 15,20 kHz (FROM, TO1, TO2)
FROM=searchFrequencyIndex(f,15000);
TO=searchFrequencyIndex(f,20000);

%inizialize parameters
Tempo=[];
D1=[];
D2=[];
DIMT = size(t);
COUNT=1;

 for j=1:DIMT(2)
    S1=0;
    S2=0;
    time=t(j)+interval*k;
    time=fix(time/60)+(time-fix(time/60)*60)/100;
    for i=FROM:TO  
        S1 = S1+abs((ps(i,j)-ps(i+1,j)));
        S2 = S2+abs((ps(i,j)-ps(i+2,j)));       
    end
    if(db(S1/(1+TO-FROM))>-246)
        D1(COUNT)=db(S1/(1+TO-FROM));
        D2(COUNT)=db(S2/(1+TO-FROM));
        Tempo(COUNT)=time;
        COUNT=COUNT+1;
    end
 end
 
x=table(Tempo', D1', D2','VariableNames',{'Tempo' 'Diff1' 'Diff2'});
