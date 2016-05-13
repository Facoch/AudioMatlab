function M= merger(A,B, str)

[rb,cb]=size(B);
if(strcmp(str,'analizeSplit'))
    fileID = fopen('result.txt','w');
end    
fileID = fopen('result.txt','a');
fprintf(fileID,'\r\nRisultati di %s\r\n Secondi    Valore   Algoritmo n°   Probabilità   Probabilità2',str);
for i=1:cb
    fprintf(fileID,'\r\n%7.4f    %7.2f         %d            %3.2f          %3.2f',B(:,i));
end
fclose(fileID);

M=[];
[ra,ca]=size(A);

if (ca==0 && cb==0)
    disp('Matrici entrambe vuote');
    M=B;
    return;
end
if (ca==0)
    disp('Prima matrice vuota');
    M=B;
    return;
end
if (cb==0)
    disp('Seconda matrice vuota');
    M=A;
    return;
end
if (ra~=5 || rb~=5)
    disp('Dimensioni matrici errate');
    return;
end

i1=1; i2=1; j=1; 
% [V,I]=sort(A(1,:));
% A = A(:,I);
% clear V I
% [V,I]=sort(B(1,:));
% B = B(:,I);


k=0.2;
   while(i1<=ca && i2<=cb)
      ok=1;
      if(abs(A(1,i1)-B(1,i2))<k)
           M(1:3,j)=A(1:3,i1);
           M(4,j)=A(4,i1)+B(4,i2);
           M(5,j)=A(5,i1);
           i1=i1+1;
           i2=i2+1;
           j=j+1;
           ok=0;
      end 
       if  ok 
           if A(1,i1)<=B(1,i2)
               M(:,j)=A(:,i1);
               i1=i1+1;
               j=j+1;
           end
           if  i1<=ca && A(1,i1)>B(1,i2)
               M(:,j)=B(:,i2);
               i2=i2+1;
               j=j+1;
           end
       end
   end
   while(i1<=ca)
        if(j>1 && abs(M(1,j-1)-A(1,i1))<k)
            M(4,j-1)=max(M(4,j-1),A(4,i1));
            i1=i1+1;
        else
            M(:,j)=A(:,i1);
            i1=i1+1;
            j=j+1;
        end
   end
   while(i2<=cb)
        if(j>1 && abs(M(1,j-1)-B(1,i2))<k)
            M(4,j-1)=max(M(4,j-1),B(4,i2));
            i2=i2+1;
        else
            M(:,j)=B(:,i2);
            i2=i2+1;
            j=j+1;
        end
   end 

[rm,cm]=size(M);
I=[];
I(:,1)=M(:,1);
COUNT=2;
i=2;
while(i~=cm+1)
    while(i~=cm+1 && abs(I(1,COUNT-1)-M(1,i))<k)
    I(2,COUNT-1)=max(I(2,COUNT-1),M(2,i));
    i=i+1;
    end
    I(:,COUNT)=M(:,i);
    i=i+1;
    COUNT=COUNT+1;
end
M=I;