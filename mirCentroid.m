clear all;  %clear the workspace
close all;
clc;

file= '3Campioni_Tagliati_96.wav';
[y,Fs] = audioread(file);
y=y(:,1);

%mir-functions
a = miraudio(y,Fs);
s = mirspectrum(a, 'Frame', 0.01, 0.5,'dB','Min', 17000, 'Max',35000);
mircentroid(s)