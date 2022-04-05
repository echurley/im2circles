function out = rgb2custom(im,custom,num)
% im is an NxMx3 rgb image matrix with a range of [0 1]
% custom is a Px3 matrix of custom additive primaries
% out is the converted image as an NxMxP matrix
% **If values in im are outside of the custom gamut, then they will be replaced with the
%    nearest points inside of the gamut**

[idx,cmap] = rgb2ind(im,num);
cmap = linsolve(custom,cmap')';
out = cmap(idx + 1,:);
out = permute(out,[1 3 2]);
out = reshape(out,size(im,1),size(im,2),[]);