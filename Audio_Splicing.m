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
%choose which algorithms enable
SplitLeft =1;   %1
Continuity=1;   %2 
mirCentroid =1; %3
mirSkew=1;      %4
mirBrigth=1;    %5
hpFilter=1;     %6
cohere=0;       %7
Channel=0;      %change channel (0 --> left, 1 --> right)

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

if isempty(M)
    disp('Nessun taglio trovato'); 
    return  
end
[rm, cm]=size(M);
%add the index column
M(6,:)=1:cm;
%replace p2 with the p2 average
M(5,:)= 100*M(5,:)./(M(4,:)*6);


%added real cuts
Real = fopen('real_cuts.txt','r');
get = fgetl(Real);
while(strcmp(file,get)==0 &&  ischar(get))
    get = fgetl(Real);
end
A= fscanf(Real, '%f');
fclose(Real);
A=A';
for i=1:cm
    for j=1:length(A)
      if abs(M(1,i)-A(j))<0.15
        M(7,i)=A(j);
      end
    end
end

M'
%print to file of the final table
Result = fopen('result.txt','a');
fprintf(Result,'\r\n\r\nRISULTATI FINALI\r\nSecondi    Valore    Algoritmo n°  Probabilità  Probabilità2   Numero        CUT');
for i=1:cm
    fprintf(Result,'\r\n%7.4f   %7.2f        %d           %3.2f         %3.2f          %2d       %7.2f',M(:,i));
end
fclose(Result);

%clean the table from near data
k=0.1;
[rm,cm]=size(M);
n=[];
n(:,1)=M(:,1);
COUNT=2;
i=2;
while(i~=cm+1)
    while(i~=cm+1 && abs(n(1,COUNT-1)-M(1,i))<k)
    fprintf('accorpato il secondo: %d', n(1,COUNT-1));
    n(1,COUNT-1)=(n(1,COUNT-1)*n(4,COUNT-1)*6+M(1,i)*M(4,i)*6)/(n(4,COUNT-1)*6+M(4,i)*6);
    n(4,COUNT-1)=n(4,COUNT-1)+M(4,i);
    n(5,COUNT-1)=n(5,COUNT-1)+M(5,i);
    i=i+1; 
    end
    n(:,COUNT)=M(:,i);
    i=i+1;
    COUNT=COUNT+1;
end
n'
%clean the table from unlikely data
n(:,((n(4,:)<0.18)+(n(5,:)<9))==2)=[];
n(:,((n(4,:)<0.34)+(n(5,:)<8))==2)=[];
n(:,((n(4,:)<0.51)+(n(5,:)<6))==2)=[];
n(:,((n(4,:)<0.68)+(n(5,:)<5))==2)=[];
n(:,((n(4,:)<0.84)+(n(5,:)<4))==2)=[];
n'   

%start the coherence process for all the more likely data
if(cohere)
    [rm, cm]=size(n);
    picco = LoadPicco();
    p3=[];
    for i=1:cm
        fprintf('valuto il numero %d', i);
        p3(i) = CFR(y, n(1,i)-0.1,n(1,i)+0.1, Fs, picco)
    end
    n(6,:) = p3;
    Result = fopen('result.txt','a');
    fprintf(Result,'\r\n\r\nRISULTATI FINALI\r\nSecondi    Valore    Algoritmo n°  Probabilità  Probabilità2    Probabilità3        CUT');
    for i=1:cm
        fprintf(Result,'\r\n%7.4f   %7.2f        %d           %4.2f         %4.2f             %4.2f         %7.2f',n(:,i));
    end
    fclose(Result);
end

toc