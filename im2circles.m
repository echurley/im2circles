%% Import/Adjust Image

clear; close;

im = imread('PearlEarring.jpg');
im = im2double(im);
im = medfilt3(im,[7,7,1],'symmetric');
im = imresize(im,2.28);

%% Convert Color Space

custom = [1 0 0; 0 1 1]';
out = rgb2custom(im,custom,512);

%% Create Edge Map

% Find edges
edges = edge(out(:,:),'canny',0.0875);
edges = reshape(edges,size(out));

% Pad edge map borders
edges = padarray(edges(2:end - 1,2:end - 1,:),[1,1,0],1);

%% Create Distance Map

dist = bwdist(edges(:,:));
dist = reshape(dist,size(out));
dist = double(dist);

%% Create List of Circles

% Set up/preallocate variables
dist1 = dist;
circles = zeros(size(out));
radius = max(dist1,[],[1,2],'linear');
[x,y] = meshgrid(1:size(out,2),1:size(out,1),1:size(out,3));

while mean2(radius) >= 1
    
    [radius,C] = max(dist1,[],[1 2],'linear');
    mask = (y - y(C)).^2 + (x - x(C)).^2;
    dist1 = min((mask - radius.^2) ./ (dist1 + 2 * radius),dist1);
    
    mask = 1 - (mask - radius.^2) ./ radius;
    mask = min(max(mask,1),2) - 1;
    color = sum(out .* mask,[1,2]) ./ sum(mask,[1,2]);
    circles = circles + color.^2 .* mask;
    
end

RGB = zeros(size(im));
im2 = zeros(size(im));
for i = 1:size(circles,3)
    RGB = RGB + sqrt(circles(:,:,i)) .* reshape(custom(i,:),[1 1 3]);
    im2 = im2 + out(:,:,i) .* reshape(custom(i,:),[1 1 3]);
end

imwrite(RGB,'pearlCircles4.png','png')
imshow(RGB)