function [fs,centers]=tse_imkmeans(f,k,sampleRatio)
%TSE_IMKMEANS Automatically segment an image by applying kmeans clustering
%in the space of pixels.
%
%  [FS,CENTERS]=TSE_IMKMEANS(F,K,SAMPLERATIO) returns the image FS obtained after
%  segmentation of input image F using K classes and sampling a certain amount  of pixels
% given by SAMPLERATIO. The coordinates of  cluster centers are returned in
% CENTERS.
%

if nargin<3, sampleRatio=0.1;end

[m,n,p]=size(f);
nb=floor(m*n*sampleRatio);

% array of data points containing only a ratio of the total number of
% pixels
data=zeros(nb,p);
for q=1:nb
    i=ceil(rand*m);
    j=ceil(rand*n);
    data(q,:)=f(i,j,:);
end

[centers,nbpoints,classe]=mykmeans(data,k);
% [idx,centers]=kmeans(data,k);
% nbpoints=hist(idx,1:k);

[v,idx]=sort(nbpoints,'descend');
centers=centers(idx,:,:);

% assign each pixel of f to the closest centroid
fs=zeros(m,n,'uint8');
pt=zeros(1,p);
for i=1:m
    for j=1:n
        pt(1,:)=f( i,j, :) ;
        min_diff = (pt- centers( 1,:) );
        min_diff = min_diff * min_diff';
        curAssignment = 1;
        for c = 2 : size(centers,1)
          diff2c = ( pt - centers( c,:) );
          diff2c = diff2c * diff2c';
          if( min_diff >= diff2c)
            curAssignment = c;
            min_diff = diff2c;
          end
        end
        fs(i,j)=curAssignment;
    end
end
end



function[centroid, pointsInCluster, assignment]= mykmeans(data, nbCluster)
% usage
% function[centroid, pointsInCluster, assignment]=
% myKmeans(data, nbCluster)
%
% Output:
% centroid: matrix in each row are the Coordinates of a centroid
% pointsInCluster: row vector with the nbDatapoints belonging to
% the centroid
% assignment: row Vector with clusterAssignment of the dataRows
%
% Input:
% data in rows
% nbCluster : nb of centroids to determine
%
% (c) by Christian Herta ( www.christianherta.de )
%
data_dim = length(data(1,:));
nbData   = length(data(:,1));


% init the centroids randomly
data_min = min(data);
data_max = max(data);
data_diff = data_max - data_min ;
% every row is a centroid
centroid = ones(nbCluster, data_dim) .* rand(nbCluster, data_dim);
for i=1 : 1 : length(centroid(:,1))
  centroid( i , : ) =   centroid( i , : )  .* data_diff;
  centroid( i , : ) =   centroid( i , : )  + data_min;
end
% end init centroids



% no stopping at start
pos_diff = 1.;

% main loop until
while pos_diff > 0.0

  % E-Step
  assignment = zeros(nbData);
  % assign each datapoint to the closest centroid
  for d = 1 : nbData;

    min_diff = ( data( d, :) - centroid( 1,:) );
    min_diff = min_diff * min_diff';
    curAssignment = 1;

    for c = 2 : nbCluster;
      diff2c = ( data( d, :) - centroid( c,:) );
      diff2c = diff2c * diff2c';
      if( min_diff >= diff2c)
        curAssignment = c;
        min_diff = diff2c;
      end
    end

    % assign the d-th dataPoint
    assignment(d) = curAssignment;

  end

  % for the stoppingCriterion
  oldPositions = centroid;

  % M-Step
  % recalculate the positions of the centroids
  centroid = zeros(nbCluster, data_dim);
  pointsInCluster = zeros(nbCluster, 1);

  for d = 1: length(assignment);
    centroid( assignment(d),:) = centroid( assignment(d),:)+data(d,:);
    pointsInCluster( assignment(d), 1 )=pointsInCluster( assignment(d), 1 )+1;
  end

  for c = 1: nbCluster;
    if( pointsInCluster(c, 1) ~= 0)
      centroid( c , : ) = centroid( c, : ) / pointsInCluster(c, 1);
    else
      % set cluster randomly to new position
      centroid( c , : ) = (rand( 1, data_dim) .* data_diff) + data_min;
    end
  end

  %stoppingCriterion
  pos_diff = sum (sum( (centroid - oldPositions).^2 ) );

end
end
