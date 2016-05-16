function p3 = CFR (y, da, a, Fs, picco)

y = y(round(Fs*da):round(Fs*a));
M=[];
m=[];
for p =1:16
MAX=0; 
for j=1:48
y1 = y(j*10:length(y));%(Fs*70+Fs*0.5:Fs*83); 

V=[];

length(y1)/length(picco(p,:));
parfor i=1:fix(length(y1)/length(picco(p,:)))
    
    split=y1(1+length(picco(p,:))*(i-1):length(picco(p,:))*i);
    [Cxy, F]=mscohere(picco(p,:),split,[],[],[],Fs);
    V(i)=mean(Cxy);%(round(3*length(Cxy)/4):length(Cxy)));
end
if(max(V)>MAX)
    MAX = max(V);
    M = V;
    
end
end
 duration=length(y1)/Fs;
 T=duration/numel(M):duration/numel(M):duration;
[temp1, temp2,w,z]=findpeaks(M,T,'MinPeakProminence',0.5, 'Npeaks',1,'Annotate','extents');
if ~isempty(temp1)
    m(p,1)=p;
    m(p,2)=temp1;
    m(p,3)=temp2;
end
%plot(T,M);
end



n=m;
if ~isempty(n)
    n(n(:,3)==0,:)=[];
    n(abs(n(:,3)-max(n(:,3)))>0.01,:)=[];
    p3 = sum(n(:,2))
else
    p3=0
end
