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
SplitRight =0;  %1
Continuity=1;   %2 
mirSplit =1;    %3   

% Split left channel
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

% Split right channel
if(SplitRight)
    y1=y;
    y1(:,[1 2])=y1(:,[2 1]);
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
   
% Continuity left channel
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

% MirSplit left channel
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
M
