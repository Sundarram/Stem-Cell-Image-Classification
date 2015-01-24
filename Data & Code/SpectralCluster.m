%% SPECTRAL CLUSTERING 

function [idx Y] = SpectralCluster(A,k)

NREP=5;
if (1==k)
    idx=ones(size(A,2),1);
    return;
end
for i=1:size(A,1)
    D(i,i)=sum(A(i,:));
end

L=D^(-.5)*A*D^(-.5);
L=Regularize(L); % remove the miniscule asymmetry from L

[eVec eVal]=eig(L);

X=[eVec(:,end) eVec(:,1:k-1)];
for i=1:size(X,1)
    Y(i,:)=X(i,:)./norm(X(i,:));
end

idx=kmeans(Y,k,'emptyaction','singleton','replicates',NREP);


function [D,degenerate] = Regularize(DistanceMatrix)

% turn output from NCD into well behaved  distance matrix

D=DistanceMatrix;
% b = max(max(D));
% D=D/b; 
for i=1:size(D,1)
      for j= 1:size(D,1)
%        for j= 1:i-1
%            D(i,j)= D(j,i);
          D(i,j)= max(D(i,j),D(j,i));
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
     
        