function M= merger(A,B, str)

[rb,cb]=size(B);
if(strcmp(str,'analizeSplit'))
    fileID = fopen('result.txt','w');   
else
fileID = fopen('result.txt','a');
end
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


k=0.1;
   while(i1<=ca && i2<=cb)
      ok=1;
      if(abs(A(1,i1)-B(1,i2))<k)            %se sono abbastanza vicini --> sostituisco con la loro fusione
           M(1,j)=(A(1,i1)*A(4,i1)*6+B(1,i2))/(A(4,i1)*6+1);     %media pesata tempi
           M(2:3,j)=A(2:3,i1);
           M(4,j)=A(4,i1)+B(4,i2);
           M(5,j)=A(5,i1)+B(5,i2);
           i1=i1+1;
           i2=i2+1;
           j=j+1;
           ok=0;
      end 
       if  ok                       %se non è entrato nell'if precedente
           ok1=1;
           if A(1,i1)<=B(1,i2)              %se il primo di A viene prima del primo di B
               M(:,j)=A(:,i1);              %-->aggiungo il primo di A
               i1=i1+1;
               j=j+1;
               ok1=0;
           end
           if  ok1 && A(1,i1)>B(1,i2)    %se il primo di B viene prima del primo di A (e non sono entrato nel precendente if)
               M(:,j)=B(:,i2);              %-->aggiungo il primo di B
               i2=i2+1;
               j=j+1;
           end
       end
   end
   
   while(i1<=ca)                            %se rimangono valori in A (B è finito)
        if(j>1 && abs(M(1,j-1)-A(1,i1))<k)      %se M non è vuoto ma il valore del primo M è abbastanza vicino al primo di A
            M(4,j-1)=max(M(4,j-1),A(4,i1));     %-->aggiorno p1 e p2 e lascio quel valore    
            M(5,j-1)=max(M(5,j-1),A(5,i1));
            i1=i1+1;
        else                                    %se il valore del primo M è diverso dal primo di A (o M vuoto)
            M(:,j)=A(:,i1);                     %-->aggiungo il primo di A
            i1=i1+1;
            j=j+1;
        end
   end
   while(i2<=cb)                            %se rimangono valori in B (A è finito)
        if(j>1 && abs(M(1,j-1)-B(1,i2))<k)  %se M non è vuoto e il valore del primo M è abbastanza vicino al primo di B
            M(4,j-1)=max(M(4,j-1),B(4,i2)); %-->aggiorno p1 e p2 e lascio quel valore
            M(5,j-1)=max(M(5,j-1),B(5,i2));
            i2=i2+1;
        else                                    %se il valore del primo M è diverso dal primo di B (o M vuoto)
            M(:,j)=B(:,i2);                     %-->aggiungo il primo di B
            i2=i2+1;
            j=j+1;
        end
   end 