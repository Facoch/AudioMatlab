%function [x]= mirTest(audio,Fs, k, interval)
clear all;  %clear the workspace
close all;
clc;
file= '3Campioni_Tagliati_96.wav';
clear y Fs
[y,Fs] = audioread(file);

y=y(:,1);

for i=880:897
    audio=y(i*960:(i+1)*960,1);
    a = miraudio(audio,Fs);
    mirautocor(a, 'Freq','Enhanced')
%     xlim([0,0.0005])
%     ylim([-0.02,0.03])
    
end

audio=y(8800*96:8970*96,1);
a = miraudio(audio,Fs);
sound(audio, Fs);

s = mirspectrum(a, 'Frame', 0.001, 0.5,'dB') %,'Min', 12000, 'Max',35000)

%mirexport('Prova.txt', c);
%mirplay(a)
% mirenvelope(a)
% mircepstrum(a)
%d= mirgetdata(mirpeaks(a));
%e = mirfeatures('3Campioni_Tagliati_96.wav', 'Segment', 0.05)

