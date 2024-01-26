function [newSinogram, delta] = recenterSinogram(sinogram, varargin)

threshold=[];
if (nargin > 1)
    threshold = varargin{1};
end

[Nrows,Nangles] = size(sinogram);
c0 = round(Nrows/2);

% newSinogram = [zeros(size(sinogram)); sinogram; zeros(size(sinogram))];
newSinogram = zeros(size(sinogram));

CoG = zeros(1,Nangles);
for a = 1:Nangles
    if (isempty(threshold))
        CoG(a) = centerofmass1D(sinogram(:,a));
    else
        CoG(a) = centerofmass1D(sinogram(:,a), threshold);
    end
end

% offset = c0-mean(CoG);
% CoG = CoG-mean(CoG);
delta = c0 - CoG;

%pause
for a=1:Nangles
    if (delta(a) < Nrows)
%         newSinogram(:,a) = circshift(newSinogram(:,a),delta);
        newSinogram(:,a) = interp1(1:Nrows,sinogram(:,a),(1:Nrows)-delta(a),'pchip',0);
    else
        error('Center of mass error is too large!');
    end
end

% newSinogram = newSinogram(Nrows+1:2*Nrows,:);
% figure(33); imshow(newSinogram,[]); title('Recentered Sinogram');