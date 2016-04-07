clear all;  %clear the workspace
close all;
clc;

%import file
file= 'Campioni_Tagliati_96_PrimaParte.wav';
clear y Fs
[y,Fs] = audioread(file);

%inizialize some variables
duration = length(y)/Fs;
Numero=[];
Tempo=[];
Valore=[];
h=table(Numero', Tempo', Valore','VariableNames',{'Numero' 'Tempo' 'Valore'});
interval=20;

%split the file in more parts 20 seconds each (more precision)
%left channel
if duration>interval
    for i=1:(1+duration/interval)
        split=y(1+Fs*interval*(i-1) : Fs*interval*i);
        x = analizeSplit(split, Fs, i-1, interval);
        h=[h; x];
        
    end
end
if duration<interval
    split=y(1: Fs*duration);
    x= analizeSplit(split,Fs,0, interval);
    h=[h; x]; 
end
disp(h);

%right channel
y1=y;
y1(:,[1 2])=y1(:,[2 1]);
g=table(Numero', Tempo', Valore','VariableNames',{'Numero' 'Tempo' 'Valore'});
if duration>interval
    for i=1:(1+duration/interval)
        split=y1(1+Fs*interval*(i-1) : Fs*interval*i);
        x = analizeSplit(split, Fs, i-1, interval); 
        g=[g; x];
    end
end
if duration<interval
    split=y1(1: Fs*duration);
    x= analizeSplit(split,Fs,0, interval);
    g=[g; x]; 
end

disp(g);






