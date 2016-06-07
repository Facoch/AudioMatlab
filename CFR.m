function p3 = CFR (y, da, a, Fs, picco)

if da<0
    da=1;
end
if a>length(y)
    a=length(y);
end
y = y(round(Fs*da):round(Fs*a));
M=[];
m=[];%zeros(16,3);
tic
for p =1:16
    MAX=0;
    
    for j=1:48
        y1 = y(j*10:length(y));
        V=[];%zeros(fix(length(y1)/length(picco(p,:))));
        parfor i=1:fix(length(y1)/length(picco(p,:)))
            split=y1(1+length(picco(p,:))*(i-1):length(picco(p,:))*i);
            [Cxy, ~]=mscohere(picco(p,:),split,[],[],[],Fs);
            V(i)=mean(Cxy);%(round(3*length(Cxy)/4):length(Cxy)));
        end
        if(max(V)>MAX)
            MAX = max(V);
            M = V;
        end
    end
    %disp(p);
    if isempty(M)
        p3=0;
        return
    end
    duration=length(y1)/Fs;
    T=duration/numel(M):duration/numel(M):duration;
    [temp1, temp2,~,~]=findpeaks(M,T,'MinPeakProminence',0.5, 'Npeaks',1,'Annotate','extents');
    if ~isempty(temp1)
        m(p,1)=p;
        m(p,2)=temp1;
        m(p,3)=temp2;
    end
    
    %plot(T,M);
end
toc
n=m;
n
if ~isempty(n)
    n(n(:,3)==0,:)=[];
    n(abs(n(:,3)-max(n(:,3)))>0.02,:)=[];
    p3 = sum(n(:,2))
 else
    p3=0
 end