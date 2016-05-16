clear all;  %clear the workspace
close all;
clc;

%import file
file = inputdlg({'Enter file name:'}, 'Name',[1 50],{'Campioni_Tagliati_96_PrimaParte'});
file =file{1};
tic
%file= 'Campioni_Tagliati_96_PrimaParte';
clear y Fs
[y,Fs] = audioread(strcat(file,'.wav'));

%inizialize some variables
duration = length(y)/Fs;
interval=duration;
M=[];
SplitLeft =1;   %1
Continuity=1;   %2 
mirCentroid =1; %3
mirSkew=1;      %4
mirBrigth=1;    %5
hpFilter=1;     %6
cohere=1;       %7
Channel=1;      %change channel (0 --> left, 1 --> right)

if(Channel)   
    y(:,[1 2])=y(:,[2 1]);
end
%y = y/max(abs(y));  %peak normalization?

% Split
if(SplitLeft)
        m= analizeSplit(y(:,1)',Fs,0, interval);
        M=merger(M,m, 'analizeSplit');
end
   
% Continuity
if(Continuity)
        m= analizeContinuity(y(:,1)',Fs,0, interval);
        M=merger(M,m,'analizeContinuity'); 
end

% MirSplit
if(mirCentroid)   
        m= mirAnalizeSplit(y(:,1)',Fs,0, interval);
        M=merger(M,m,'mirAnalizeSplit'); 
end

% MirSkew
if(mirSkew)   
        m= mirAnalizeSkew(y(:,1)',Fs,0, interval);
        M=merger(M,m,'mirAnalizeSkew'); 
end

% MirBrigth
if(mirBrigth)   
        m= mirAnalizeBrigth(y(:,1)',Fs,0, interval);
        M=merger(M,m,'mirAnalizeBrigth');  
end

% hpFilter
if(hpFilter)   
        m= hpFilt(y(:,1)',Fs,0, interval);
        M=merger(M,m,'hpFilt');  
end

%add the index column
[rm, cm]=size(M);
M(6,:)=1:cm;

%T = array2table(M','VariableNames',{'Secondi','Valore','Algoritmo', 'Probability','Numero'})
Real = fopen('real_cuts.txt','r');
get = fgetl(Real);
while(strcmp(file,get)==0 &&  ischar(get))
    get = fgetl(Real);
end
A= fscanf(Real, '%f');
fclose(Real);
A=A'
for i=1:cm
    for j=1:length(A)
      if abs(M(1,i)-A(j))<0.4
        M(7,i)=A(j);
      end
    end
end
M'

Result = fopen('result.txt','a');
fprintf(Result,'\r\n\r\nRISULTATI FINALI\r\nSecondi    Valore    Algoritmo n°  Probabilità  Probabilità2   Numero        CUT');
for i=1:cm
    fprintf(Result,'\r\n%7.4f   %7.2f        %d           %3.2f         %3.2f          %2d       %7.2f',M(:,i));
end
fclose(Result);

if(cohere)
    n=M;
    n(:,((n(4,:)<0.17)+(n(5,:)<0.27))==2)=[];
    n(:,((n(4,:)<0.33)+(n(5,:)<0.24))==2)=[];
    n(:,((n(4,:)<0.50)+(n(5,:)<0.2))==2)=[];
    n(:,((n(4,:)<0.67)+(n(5,:)<0.18))==2)=[]
    [rm, cm]=size(n);
    picco = LoadPicco();
    c=[];
    for i=1:cm
        fprintf('valuto il numero %d', i);
        c(i) = CFR(y, n(1,i)-0.2,n(1,i)+0.2, Fs, picco);
    end
    n(8,:) = c;
    Result = fopen('result.txt','a');
    fprintf(Result,'\r\n\r\nRISULTATI FINALI\r\nSecondi    Valore    Algoritmo n°  Probabilità  Probabilità2   Numero        CUT    Probabilità3');
    for i=1:cm+1
        fprintf(Result,'\r\n%7.4f   %7.2f        %d           %3.2f         %3.2f          %2d       %7.2f     %3.2f',n(:,i));
    end
    fclose(Result);
end
toc