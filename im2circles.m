%% Import/Adjust Image

clear; close;

im = imread('GreatWave.jpg');
im = im2double(im);
im = medfilt3(im,[5,5,1],'symmetric');
%im = imadjust(im,stretchlim(im,[0.01 0.99]),[0 1]);
%im = imresize(im,2);

%% Create Edge Map

% Find edges
edges = edge(im(:,:),'sobel',0.05);
edges = reshape(edges,size(im));

% Clean up edge map
i = 1;
while sum(edges,'all') / numel(edges) > .03
    i = i + 1;
    edges = bwareaopen(edges,i * 5,8);
end

% Pad edge map borders
edges(1,:,:) = 1;
edges(end,:,:) = 1;
edges(:,1,:) = 1;
edges(:,end,:) = 1;

%% Create Distance Map

% Preallocate variables
dist = zeros(numel(im) / 3,3);

% Make list of edge points and query points
[P(:,1),P(:,2),P(:,3)] = ind2sub(size(im),find(edges == 1));
[PQ(:,1),PQ(:,2)] = ind2sub(size(im,1,2),(1:numel(im) / 3)');

for j = 1:size(im,3)
    [~,dist(:,j)] = knnsearch(P(P(:,3) == j,1:2),PQ,'BucketSize',22);
end

dist = reshape(dist,size(im));

%% Create RGB Image

% Set up/preallocate variables
RGB = zeros(size(dist));
dist2 = dist;
radius = 100;
[x,y] = meshgrid(1:size(dist,2),1:size(dist,1),1:3);
i = 0;
pcts = [];
radii = [];

while mean2(radius) >= 100
    
    i = i + 1;
    
    [radius,C] = max(dist2,[],[1,2],'linear');
    mask = sqrt((y - y(C)).^2 + (x - x(C)).^2) - radius;
    dist2 = min(mask,dist2);
    
    mask = -min(max(mask,-0.5),0.5) + 0.5;
    mask = mask .* sum(im .* mask,[1,2]) ./ sum(mask,[1,2]);
    RGB = max(mask,RGB);
    
    if mod(i,15) == 0
        imshow(RGB)
        disp(mean2(radius))
    end
    
end

imwrite(RGB,'waveCircles5.png','png')
imshow(RGB)