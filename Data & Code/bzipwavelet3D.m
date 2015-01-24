%% BZIP2 Compression of Approximation Coefficients - 3D wavelets
% Loading the Images
input3D=[];
ROOT='Images\';
for t=1:48
     
    fname=[ROOT 'input3D_' num2str(t,'%02d') '.jpg'];
    input3D(:,:,t)=imread(fname);
end

tic
wav='db2'; % Using Daubechies 2 wavelet type
N=1; % no. of decomposition levels
compressedsize=[];
input3Dfilt=[];
for i=1:size(input3D,3)
    
    input3Dfilt(:,:,i)=stdfilt(input3D(:,:,i), getnhood(strel('disk',3)));
end
for i=1:2:size(input3D,3)
  
    wdec = wavedec3(input3Dfilt(:,:,i:i+1),N,wav); %'sym4'
    %npixels = wdec.sizes(end-1,1)*wdec.sizes(end-1,2);
    %npixels = size(wdec.dec{1},1)*size(wdec.dec{1},2)*size(wdec.dec{1},3);
    
    dlmwrite('dec1.txt',wdec.dec{1}(:),'delimiter',' ');
    system('bzip2 -k dec1.txt');
    compressioninfo=dir('dec1.txt.bz2');
    compressedsize((i+1)/2)=compressioninfo.bytes;
    system('del dec1.txt');
    system('del dec1.txt.bz2');
end

comb=[];

%%Computing Combination coefficients
for i=1:2:size(input3D,3)
    for j=1:2:size(input3D,3)
        comb(:,:,1) = [input3Dfilt(:,:,i) input3Dfilt(:,:,j)]; 
        comb(:,:,2) = [input3Dfilt(:,:,i+1) input3Dfilt(:,:,j+1)]; 
%         comb(:,:,3) = input3D(:,:,j); 
%         comb(:,:,4) = input3D(:,:,j+1);
        wdeccomb = wavedec3(comb(:,:,1:2),N,wav); %'sym4'
%         combpixels=size(wdeccomb.dec{1},1)*size(wdeccomb.dec{1},2)*size(wdeccomb.dec{1},3);
        
        dlmwrite('deccomb.txt',wdeccomb.dec{1}(:),'delimiter',' ');
        system('bzip2 -k deccomb.txt');
        compressioninfo2=dir('deccomb.txt.bz2');
        compressedsizecomb((i+1)/2,(j+1)/2)=compressioninfo2.bytes;
    system('del deccomb.txt');
    system('del deccomb.txt.bz2');
    
    end
end

%% Compute Normalized Compression Distance
NCDbzip=[];
for i=1:size(input3D,3)/2
    for j=1:size(input3D,3)/2
        NCDbzip(i,j) = (compressedsizecomb(i,j) - min(compressedsize(i), compressedsize(j)))/(max(compressedsize(i), compressedsize(j)));
    end
end
 %% GAP SPECTRAL 
 nMaxClusters=6; 
 [kGap Gap S idx] = GapSpectral(NCDbzip,nMaxClusters);
 printme=sprintf('No. of clusters= %d',kGap);
 disp(printme);
%% Spectral Clustering
[idx1 Y] = SpectralCluster(NCDbzip, 2);

figure, hold on;
plot(Y(1:12,1), Y(1:12,2),'r*', 'MarkerSize',8);
plot(Y(13:24, 1), Y(13:24, 2), 'bo','MarkerSize',8);
legend('Mitotic','Non-mitotic');
ylabel('\lambda_2');
xlabel('\lambda_1');
title('Spectral Representation');
axis([-1.5 0 -1 1]);
set(gcf, 'Color', 'w');


