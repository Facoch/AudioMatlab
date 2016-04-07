%this function search in the vector 'f' the index of the required frequency 'freq'
function [x]= searchFrequencyIndex(f,freq)
DIMF=size(f);
x=round(freq*DIMF(1)/f(DIMF(1)));
while round(f(x))>freq
        x=x-1;
end
while round(f(x))<freq
        x=x+1;
end
