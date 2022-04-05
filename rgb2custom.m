function out = rgb2custom(im,custom)
% im is an NxMx3 rgb image matrix with a range of [0 1]
% custom is a Px3 matrix of custom additive primaries
% out is the converted image as an NxMxP matrix
% **If values in im are outside of the custom gamut, then they will be replaced with the
%    nearest points inside of the gamut**

out = zeros([size(im,1,2),size(custom,1)]);

for i = 1:size(im,1)
    for j = 1:size(im,2)
        out(i,j,:) = linsolve(custom',reshape(im(i,j,:),[3,1]));
    end
end
