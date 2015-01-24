function [kGap Gap S idx] = GapSpectral(DistanceMatrix,nMaxClusters,bAlgorithmicInformationDistance)

if nargin<3
    bAlgorithmicInformationDistance=1;
end
B = 50; % size of Monte Carlo distribution
if nMaxClusters>size(DistanceMatrix,1)
    nMaxClusters = size(DistanceMatrix,1)-1;
end

D =   Regularize(DistanceMatrix);
bound=D;
for i=1: size(bound,1)
    bound(i,i)=NaN;
end
a =  min(min(bound));%;
b = max(max(bound));
UV =  a + (b-a)*rand(size (D,1),size (D,2),B); % uniform distribution
for k=1:nMaxClusters
    if (1==k) %
        % one happy cluster
        idx = ones(size (D,1),1);
    else
        idx = SpectralCluster(D,k);
    end
    W(k)=WkSpectral(k,idx,D);
    for ib =1:B
        uni =  UV(:,:,ib);
        uni = Regularize(uni); % make uni a valid distance matrix
        if (1==k) %
            % one happy cluster
            idx = ones(size (D,1),1);
        else
            idx = SpectralCluster(uni,k);
        end
        Wb(ib,k)=WkSpectral(k,idx,uni);;
    end
    Wkb = Wb(:,k);
    lkb = log(Wkb);
    if bAlgorithmicInformationDistance
        Gap(k) = 1/B*sum(Wkb) - W(k);
        sdk = std(Wkb,1);
    else
        Gap(k) = 1/B*sum(lkb) - log(W(k));
        sdk = std(lkb,1);
    end
    S(k)=sdk * sqrt(1+1/B);
    %     Gap
    %     S
end

figure
errorbar( [1:nMaxClusters],Gap,S)
set(gca,'XTick',[1:nMaxClusters])

k=1;
while ((k<nMaxClusters) && (Gap(k) < Gap(k+1)-S(k+1)))
    k=k+1;
end
kGap=k;
if (kGap>1)
    idx = SpectralCluster(D,kGap);
else
    idx = ones(size (D,1),1);
end
