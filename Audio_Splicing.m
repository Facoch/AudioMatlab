clear all;  %clear the workspace
close all;
clc;

%import file
file= 'Campioni_Tagliati_96_PrimaParte.wav';
clear y Fs
[y,Fs] = audioread(file);
duration = length(y)/Fs;

%split the file in more parts 40 seconds each (more precision)
if duration>40
    for i=1:(1+duration/40)
        split=y(1+Fs*40*(i-1) : Fs*40*i);
        left=split(1,:);
        x = analizeSplit(left, Fs, i-1); 
        %here I can use x table ... 
    end
end
if duration<40
    x= analizeSplit(y,Fs,0, duration);
    
end







