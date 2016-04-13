%this function returns the table 'x' containing the information about the
%potential cuts on my audio file
function [m]= mirAnalizeSplit(audio,Fs, k, interval)

%audio=audio(:,1);
AU = miraudio(audio',Fs);
SPEC = mirspectrum(AU, 'Frame','dB','Min', 15000, 'Max',35000);
c= mircentroid(SPEC);
%TIME= get(s, 'XScale'); ?
DATA= mirgetdata(c)/100;
duration=length(audio)/Fs;
T=[duration/numel(DATA):duration/numel(DATA):duration];

%find peaks
figure(k+5);
findpeaks(DATA,T,'MinPeakProminence',0.7,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.1, 'MinPeakHeight',-245,'Annotate','extents')
[m(2,:),m(1,:)]=findpeaks(DATA,T,'MinPeakProminence',0.7,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.1, 'MinPeakHeight',-245,'Annotate','extents');
for i=1:(numel(m)/2)
     time= (m(1,i)+interval*k);   
     m(1,i)=fix(time/60)+(time-fix(time/60)*60)/100;
end
m=m';
m(:,3)=3;


