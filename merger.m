function M= merger(A,B, str)

[rb,cb]=size(B);
if(strcmp(str,'analizeSplit'))
    fileID = fopen('tagli.txt','w');
end    
fileID = fopen('tagli.txt','a');
fprintf(fileID,'\r\nRisultati di %s\r\n Secondi    Valore   Algoritmo n°   Probabilità',str);
for i=1:cb
    fprintf(fileID,'\r\n%7.4f    %7.2f         %d            %3.2f',B(:,i));
end
fclose(fileID);

M=[];
[ra,ca]=size(A);
[rb,cb]=size(B);
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
if (ra~=4 || rb~=4)
    disp('Dimensioni matrici errate');
    return;
end

i1=1; i2=1; j=1; 
[V,I]=sort(A(1,:));
A = A(:,I);
clear V I
[V,I]=sort(B(1,:));
B = B(:,I);


k=0.2;
   while(i1<=ca && i2<=cb)
      ok=1;
      if(abs(A(1,i1)-B(1,i2))<k)
           M(1:3,j)=A(1:3,i1);
           M(4,j)=A(4,i1)+B(4,i2);
           i1=i1+1;
           i2=i2+1;
           j=j+1;
           ok=0;
      end 
       if (ok && j>1)
           while(i1<=ca && abs(M(1,j-1)-A(1,i1))<k)
               M(4,j-1)=max(M(4,j-1),A(4,i1));
               i1=i1+1;
               ok=0;
           end
           while(i2<=cb && abs(M(1,j-1)-B(1,i2))<k)
               M(4,j-1)=max(M(4,j-1),B(4,i2));
               i2=i2+1;
               ok=0;
           end
           
      end
       if  ok 
           if A(1,i1)<=B(1,i2)
               M(:,j)=A(:,i1);
               i1=i1+1;
               j=j+1;
           end
           if  A(1,i1)>B(1,i2)
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