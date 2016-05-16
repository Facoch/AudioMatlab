clear all;  %clear the workspace
close all;
clc;



[picco,Fs] = audioread('Campioni_Tagliati_96_PrimaParte.wav');

picco1 = picco(Fs*21.27:Fs*21.275+1,1);
% picco3 = picco(Fs*39.36:Fs*39.365,1);
%picco4 = picco(Fs*54.912:Fs*54.917,1);
%picco5 = picco(Fs*79.585:Fs*79.590,1);  %V
 %picco6 = picco(Fs*97.476:Fs*97.481,1);  %V

 au = miraudio(picco1,Fs)
 mirspectrum(au, 'Frame',0.0003, 0.5,'dB')

filename = 'picco1.wav';
audiowrite(filename,picco1,Fs);
% 
% [y1,Fs] = audioread('prova.wav');
% au = miraudio(y1,Fs);
% figure(3);
% s = mirspectrum(au, 'Frame',0.0002, 0.5,'dB')
