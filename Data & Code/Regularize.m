function [D,degenerate] = Regularize(DistanceMatrix)

% turn output from NCD into well behaved  distance matrix

D=DistanceMatrix;
% b = max(max(D));
% D=D/b; 
for i=1:size (D,1)
     for j= 1:i-1
         D(i,j)= D(j,i);
     end
     D(i,i)=0;
end

bound=D;
for i=1: size(bound,1)
    bound(i,i)=NaN;
end
a =  min(min(bound));
if 0==a
    degenerate=1;
else
    degenerate=0;
end
     
        
