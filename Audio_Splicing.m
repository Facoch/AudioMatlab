clear all;  %clear the workspace
close all;
clc;

%import file
file= 'Campioni_Tagliati_96_PrimaParte.wav';
clear y Fs
[y,Fs] = audioread(file);

%inizialize some variables
duration = length(y)/Fs;
interval=duration;
M=[];
SplitLeft =1;   %1
Continuity=1;   %2 
mirCentroid =1; %3
mirSkew=1;      %4
mirBrigth=1;    %5
Channel=0;      %change channel (0 --> left, 1 --> right)

if(Channel)   
    y(:,[1 2])=y(:,[2 1]);
end
%y = y/max(abs(y));  %peak normalization

% Split
if(SplitLeft)
        m= analizeSplit(y(:,1)',Fs,0, interval);
        M=vertcat(M,m);
end
   
% Continuity
if(Continuity)
        m= analizeContinuity(y(:,1)',Fs,0, interval);
        M=vertcat(M,m); 
end

% MirSplit
if(mirCentroid)   
        m= mirAnalizeSplit(y(:,1)',Fs,0, interval);
        M=vertcat(M,m); 
end

% MirBrigth
if(mirBrigth)   
        m= mirAnalizeBrigth(y(:,1)',Fs,0, interval);
        M=vertcat(M,m); 
end

% MirSkew
if(mirSkew)   
        m= mirAnalizeSkew(y(:,1)',Fs,0, interval);
        M=vertcat(M,m); 
end
%sort by time the matrix of all possibile cuts
[V,I]=sort(M(:,1));
M = M(I,:);
M(:,5)=1:length(M);
M
