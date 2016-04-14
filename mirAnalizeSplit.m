%this function returns the matrix 'm' containing the information about the
%potential cuts on my audio file
function [m]= mirAnalizeSplit(audio,Fs, k, interval)

mirverbose(0); %mir doesn't write in command window
AU = miraudio(audio',Fs);
SPEC = mirspectrum(AU, 'Frame','dB','Min', 15000, 'Max',35000);
c= mircentroid(SPEC);
TIME= get(SPEC, 'XScale') %CAPIRE COME MAI
DATA= mirgetdata(c)/100;
duration=length(audio)/Fs;
T=[duration/numel(DATA):duration/numel(DATA):duration];

%calculate the moving average at 40%
movingAverage = smooth(DATA,0.4,'moving');
%cuts the V values under moving average
DATA(DATA<movingAverage') = movingAverage(DATA<movingAverage');

%find peaks
figure(k+5);
findpeaks(DATA,T,'MinPeakProminence',0.6,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.1, 'MinPeakHeight',-245,'Annotate','extents')
[m(2,:),m(1,:)]=findpeaks(DATA,T,'MinPeakProminence',0.6,'MinPeakDistance', 0.15, 'MaxPeakWidth', 0.1, 'MinPeakHeight',-245,'Annotate','extents');
for i=1:length(m)
     time= (m(1,i)+interval*k);   
     m(1,i)=fix(time/60)+(time-fix(time/60)*60)/100;
end
m=m';
m(:,3)=3;


