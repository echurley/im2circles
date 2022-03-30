%% Import/Adjust Image

clear; close;

im = imread('PearlEarring.jpg');
im = im2double(im);
im = medfilt3(im,[5,5,1],'symmetric');
%im = imadjust(im,stretchlim(im,[0.01 0.99]),[0 1]);
im = imresize(im,1.5);

%% Create Edge Map

% Find edges
edges = edge(im(:,:),'sobel',0.03);
edges = reshape(edges,size(im));

% Clean up edge map
i = 1;
while sum(edges,'all') / numel(edges) > 0.015
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
dist1 = dist;
radius = max(dist1,[],[1,2],'linear');
%dist2 = (dist + radius).^2;
[x,y] = meshgrid(1:size(dist,2),1:size(dist,1),1:3);  
i = 0;
% data = zeros(10000,3);

profile on

while mean2(radius) >= 1
    
    i = i + 1;
    
    [radius,C] = max(dist1,[],[1,2],'linear');
    mask = (y - y(C)).^2 + (x - x(C)).^2;
    dist1 = min((mask - radius.^2) ./ (dist1 + 2 * radius),dist1);
    
    mask = -min(max(mask - radius.^2,-radius),0) ./ radius;
    mask = mask .* sum(im .* mask,[1,2]) ./ sum(mask,[1,2]);
    RGB = RGB + mask;
    
%     data(i,1) = mean2(radius);
%     data(i,2) = 100 * mean2(abs(im - RGB) ./ im);
%     data(i,3) = 100 * sum(double(RGB > 0),'all') / numel(dist1);
%     disp(data(i,1))
    
end

profile viewer

imwrite(RGB,'pearlCircles.png','png')
imshow(RGB)