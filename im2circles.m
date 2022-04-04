%% Import/Adjust Image

clear; close;

im = imread('PearlEarring.jpg');
im = im2double(im);
im = medfilt3(im,[7,7,1],'symmetric');
%im = imresize(im,2.28);

%% Convert Color Space

%custom(:,1,1:3) = [.5 .5 0;0 .5 .5;.5 0 .5;.3 .3 .3];
%out = rgb2custom(im,custom);

%% Create Edge Map

% Find edges
edges = edge(im(:,:),'canny',0.0875);
edges = reshape(edges,size(im));

% Pad edge map borders
edges = padarray(edges(2:end - 1,2:end - 1,:),[1,1,0],1);

%% Create Distance Map

dist = bwdist(edges(:,:));
dist = reshape(dist,size(im));
dist = double(dist);

%% Create List of Circles

% Set up/preallocate variables
dist1 = dist;
RGB = zeros(size(im));
radius = max(dist1,[],[1,2],'linear');
[x,y] = meshgrid(1:size(im,2),1:size(im,1),1:3);

while mean2(radius) >= 1
    
    [radius,C] = max(dist1,[],[1,2],'linear');
    mask = (y - y(C)).^2 + (x - x(C)).^2;
    dist1 = min((mask - radius.^2) ./ (dist1 + 2 * radius),dist1);
    
    mask = 1 - (mask - radius.^2) ./ radius;
    mask = min(max(mask,1),2) - 1;
    color = sum(im .* mask,[1,2]) ./ sum(mask,[1,2]);
    RGB = RGB + color.^2 .* mask;
    
end

imwrite(sqrt(RGB),'pearlCircles4.png','png')
imshow(sqrt(RGB))