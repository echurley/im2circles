function out = rgb2custom(im,custom,num)
% im is an NxMx3 rgb image matrix with a range of [0 1]
% custom is a Px3 matrix of custom additive primaries
% out is the converted image as an NxMxP matrix
% **If values in im are outside of the custom gamut, then they will be replaced with the
%    nearest points inside of the gamut**

% Create the RGB colormap
[idx,cmap] = rgb2ind(im,num);

cvar = optimvar('cvar',size(custom,2),size(cmap,1),'LowerBound',0,'UpperBound',1);
obj = sum((custom * cvar - cmap').^2,'all');
prob = optimproblem('Objective',obj);
sol = solve(prob);

out = sol.cvar(:,idx + 1);
out = permute(out,[3 2 1]);
out = reshape(out,size(im,1),size(im,2),[]);


