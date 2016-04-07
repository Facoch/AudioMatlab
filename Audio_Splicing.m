clear all;  %pulisco il workspace
close all;
clc;


file= '3Campioni_Tagliati_96.wav';
[y,Fs] = audioread(file);
info = audioinfo(file);


T=1/32000;
f=0:1:32000;
taudio = T*fft(y, length(f));

t = 0:seconds(1/Fs):seconds(info.Duration);
t = t(1:end-1);

left=y(:,1); % Left channel 

%subplot (3,1,1);    plot(f,20*log10(abs(taudio)));
%subplot (3,1,2);    plot(t,y);
NUMEL = round(numel(left)/1000);
NUMELOVER = round(50/100*NUMEL);

[s,f,t,ps]= spectrogram(left,NUMEL,NUMELOVER,[],Fs,'yaxis');

spectrogram(left,NUMEL,NUMELOVER,[],Fs,'yaxis', 'MinThreshold',-200);
%xlim([1.1 1.4]); 


%ricerca precisa estremi 8'000 - 40'000
DIMF=size(f);
FROM=searchFrequencyIndex(f,8000);
TO=searchFrequencyIndex(f,40000);  
    

DIMT = size(t);
COUNT=1;
STOT=0;

for j=1:DIMT(2)
    
    S=0;
    for i=FROM:TO
        S = S+ps(i,j);
        STOT = STOT+ps(i,j);
    end
    pw=db(S/(1+TO-FROM));    % pw=10*log(S/(TO-FROM)); 
    if(-240<pw)
        disp('Alto');
         Numero(COUNT)=COUNT;
         Tempo(COUNT)=fix(t(j)/60)+(t(j)-fix(t(j)/60)*60)/100;
         Valore(COUNT)=pw;
        COUNT=COUNT+1;
        end
end
    
T=table(Numero', Tempo', Valore');
disp(T);

disp('STOT');
disp(db(STOT/((1+TO-FROM)*(DIMT(2)))));



%PROSSIME COSE: 
%           capire suddivisione brano
%           trovare valori base riconoscimento (quindi non comparativo interno)
%           trovare modo per info generali sul file audio/pezzo di brano



