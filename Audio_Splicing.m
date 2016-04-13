clear all;  %clear the workspace
close all;
clc;
file= 'Campioni_Tagliati_96_PrimaParte.wav';
clear y Fs
[y,Fs] = audioread(file);
%import file


   
%inizialize some variables
duration = length(y)/Fs;
Numero=[];
Tempo=[];
Valore=[];
h=table(Numero', Tempo', Valore','VariableNames',{'Numero' 'Tempo' 'Valore'});
interval=duration;
M=[];
%split the file in more parts 'interval' seconds each (more precision)
%left channel
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


% %right channel
% y1=y;
% y1(:,[1 2])=y1(:,[2 1]);
% g=table(Numero', Tempo', Valore','VariableNames',{'Numero' 'Tempo' 'Valore'});
% if duration>interval
%     for i=1:(1+duration/interval)
%         
%         if i<=fix(duration/interval)
%             split=y1(1+Fs*interval*(i-1) : Fs*interval*i+1);
%         end
%         if i>fix(duration/interval)
%             split=y1(1+Fs*interval*(i-1): Fs*duration+1);
%         end
%         x = analizeSplit(split, Fs, i-1, interval);    
%         g=[g; x];
%     end
% end
% if duration<=interval
%     split=y1(1: Fs*duration);
%     x= analizeSplit(split,Fs,0, interval);
%     g=[g; x]; 
% end
% 
% disp(g);


% 
%inizialize some variables

%split the file in more parts 'interval' seconds each (more precision)
%left channel
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


%MIR TEST left channel
% if duration>interval
%     for i=1:(1+duration/interval)
%         if i<=fix(duration/interval)
%             split=y(1+Fs*interval*(i-1) : Fs*interval*i+1,1);
%         end
%         if i>fix(duration/interval)
%             split=y(1+Fs*interval*(i-1): Fs*duration,1);
%         end
%         x = mirTest(split, Fs, i-1, interval);
%         
%     end
% end
% if duration<=interval
%     split=y(1: Fs*duration,1);
%     x= mirTest(split,Fs,0, interval);
% end
% disp(h);

%sort by time the matrix of all possibile cuts
[V,I]=sort(M(:,1));
M = M(I,:);
M
