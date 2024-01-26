% Reconstruct a 3d volume from OPT angle projections using 
% spline-based inverse Radon transform.
%
% Can be called as follows:
%   vol3d = reconstructOPT(OPT_data);
%   vol3d = reconstructOPT(OPT_data, theta);
%   vol3d = reconstructOPT(OPT_data, theta, transpose);
%   vol3d = reconstructOPT(OPT_data, theta, transpose, recenter);
%   vol3d = reconstructOPT(OPT_data, theta, transpose, recenter, verbose);
%   vol3d = reconstructOPT(OPT_data, theta, transpose, recenter, verbose, threshold);
%
% OPT_data - a 3D matrix containing the OPT data (x,y,angle)
% theta - a vector specifying angles used for filtered backprojection (default = 0:360/numAngles:360/numAngles*(numAngles-1)
% transpose - true or false (default: false) indicating whether or not to transpose data prior to filtered backprojection
% recenter - true or false (default: false) indicating whether or not to recenter sinograms prior to filtered backprojection
% verbose - true or false (default: false) indicating whether or not to display iteration number during FBP
% threshold - intensity threshold for recentering sinogram
function vol3d = reconstructOPT(OPT_data,varargin)

% Parse input
transpose = false;
recenter = false;
verbose = false;
threshold = [];
if (nargin > 1 && ~isempty(varargin{1}))
    theta = varargin{1};
end
if (nargin > 2 && ~isempty(varargin{2}))
    transpose = varargin{2};
end
if (nargin > 3 && ~isempty(varargin{3}))
    recenter = varargin{3};
end
if (nargin > 4 && ~isempty(varargin{4}))
    verbose = varargin{4};
end
if (nargin > 5 && ~isempty(varargin{5}))
    threshold = varargin{5};
end


% get data dimensions
[rows,cols,angles] = size(OPT_data);
if (nargin < 2)
    totalRotation = 360; % total angle of rotation
    theta = 0:totalRotation/angles:(totalRotation/angles)*(angles-1);
end

% transpose images
if (transpose)
    OPT_data_transposed = zeros(cols,rows,angles);
    for m = 1:angles
        OPT_data_transposed(:,:,m) = squeeze(OPT_data(:,:,m))';
    end
    OPT_data = OPT_data_transposed;
    clear OPT_data_transposed;
end

% inverse radon transform
disp('Performing filtered backprojection...');
N = 2*floor(size(OPT_data,1)/(2*sqrt(2)));
I = zeros([N,N,cols]);
for j = 1:cols
    R = squeeze(OPT_data(:,j,:));
    if (recenter)
        if (~isempty(threshold))
            R = recenterSinogram(R, threshold);
        else
            R = recenterSinogram(R); % align all angles in sinogram
        end
    end
    I(:,:,j) = spliradon(R,theta);
    if (verbose)
        disp([num2str(j) ' / ' num2str(cols)]);
    end
    clear R
end

vol3d = I;
% disp('Done!');