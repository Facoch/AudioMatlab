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
mirSplit =1;    %3 
Channel=0;      %change channel (0 --> left, 1 --> right)

if(Channel)   
    y(:,[1 2])=y(:,[2 1]);
end
%y = y/max(abs(y));  %peak normalization

% Split
if(SplitLeft)
    if duration>interval
        for i=1:(1+duration/interval)
            if i<=fix(duration/interval)
                split=y(1+Fs*interval*(i-1) : Fs*interval*i+1);
            end
            if i>fix(duration/interval)
                split=y(1+Fs*interval*(i-1): Fs*duration+1);
            end
            m = analizeSplit(split, Fs, i-1, interval);
            M=vertcat(M,m);

        end
    end
    if duration<=interval
        split=y(1: Fs*duration);
        m= analizeSplit(split,Fs,0, interval);
        M=vertcat(M,m);
    end
end
   
% Continuity
if(Continuity)
    if duration>interval
        for i=1:(1+duration/interval)
            if i<=fix(duration/interval)
                split=y(1+Fs*interval*(i-1) : Fs*interval*i+1);
            end
            if i>fix(duration/interval)
                split=y(1+Fs*interval*(i-1): Fs*duration+1);
            end
            m = analizeContinuity(split, Fs, i-1, interval);
            M= vertcat(M,m);

        end
    end
    if duration<=interval
        split=y(1: Fs*duration);
        [m]= analizeContinuity(split,Fs,0, interval);
        M=vertcat(M,m); 
    end
end

% MirSplit
if(mirSplit)   
    if duration>interval
        for i=1:(1+duration/interval)
            if i<=fix(duration/interval)
                split=y(1+Fs*interval*(i-1) : Fs*interval*i+1);
            end
            if i>fix(duration/interval)
                split=y(1+Fs*interval*(i-1): Fs*duration+1);
            end
            m = mirAnalizeSplit(split, Fs, i-1, interval);
            M= vertcat(M,m);

        end
    end
    if duration<=interval
        split=y(1: Fs*duration);
        [m]= mirAnalizeSplit(split,Fs,0, interval);
        M=vertcat(M,m); 
    end
end

%sort by time the matrix of all possibile cuts
[V,I]=sort(M(:,1));
M = M(I,:);
M(:,4)=1:length(M);
M
