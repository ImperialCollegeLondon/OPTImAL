function proj_corrected = fixProjections(proj, offsets)

Nrows = size(proj,1);
Ncols = size(proj,2);
Nangles = size(proj,3);

proj_corrected = zeros([Nrows,Ncols,Nangles]);
minVal = min(proj(:));
maxVal = max(proj(:));
meanVal = mean(proj(:));

% Correct for row offsets
[X,Y] = meshgrid(1:Ncols,1:Nrows);
for n = 1:Nangles
    P1 = squeeze(proj(:,:,n));
    if (offsets(n) >= 0)
        extrapVal = mean(P1(1,:));
    else
        extrapVal = mean(P1(end,:));
    end
    [Xi,Yi] = meshgrid(1:Ncols,(1:Nrows)-offsets(n));
    P2 = interp2(X,Y,P1,Xi,Yi,'linear',extrapVal);
    proj_corrected(:,:,n) = P2;
end

% Correct for intensity changes
proj_corrected = proj_corrected - minVal;
for n = 1:Nangles
    pmean = mean(mean(proj_corrected(:,:,n)));
    alpha = (meanVal-minVal) / pmean;
    proj_corrected(:,:,n) = proj_corrected(:,:,n) .* alpha;
end
proj_corrected = proj_corrected + minVal;