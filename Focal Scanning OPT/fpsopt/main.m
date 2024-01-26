% Modified BSD-2 License - for Non-Commercial Research and Educational Use Only 
% Copyright (c) 2017, The Regents of the University of California
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification,
% are permitted for non-commercial research and educational use only provided 
% that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice, 
%    this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice, 
%    this list of conditions and the following disclaimer in the documentation 
%    and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
% USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
% For permission to use for commercial purposes, please contact UCSB’s 
% Office of Technology & Industry Alliances at 805-893-5180 or info@tia.ucsb.edu.


% This is a Matlab script for reconstructing FPS-OPT data as described in:
%   K. G. Chan and M. Liebling, "Direct inversion algorithm for focal plane 
%   scanning optical projection tomography," in Biomedical Optics Express, 
%   vol. 8, no. 11, pp. 5349-5358, 2017.


%% Parameters
dataset_version = 'small'; % 'full' or 'small' 

Nangles = 200; % Number of rotation angles: 200 (small) or 1600 (full)
Nr = 256; % Number of rows (image height): 256 (small) or 512 (full)
Nc = 256; % Number of columns (image width): 256 (small) or 512 (full)
Nz = 8; % Number of z-slices
lambda = 0.0005; % Regularization parameter (empirically chosen)
psfFilename = 'psf.mat'; % point spread function data

% Raw 4D data can be organized into separate stacks or combined into one file
if (strcmp(dataset_version, 'full'))
    rawDataFilename = 'rotation_%.mat';
elseif (strcmp(dataset_version, 'small'))
    rawDataFilename = 'fpsopt_small_dataset.tif';
end


%% Load data & integrate along z-dimension
disp(['Loading data (', dataset_version, ')...']);
proj = zeros([Nr,Nc,Nangles]);

if (strcmp(dataset_version, 'full')) % Load full-size dataset file-by-file.
    stack = zeros([Nr, Nc, Nz]);
    for n = 0:Nangles-1
        fname = num2filename(n, rawDataFilename, 4);
        stack = squeeze(readtif(fname));
        proj(:,:,n+1) = sum(stack, 3); % integrate along z dimension
    end
elseif (strcmp(dataset_version, 'small')) % small dataset is already z-projected.
    proj = squeeze(readtif(rawDataFilename));
end


%% Estimate sinogram correction offsets and fix projections
sino = squeeze(sum(proj,2));
thresh = 2e7; % This is a data-dependent, manually-chosen value! Should be the threshold of background intensity in the sinogram.
if (strcmp(dataset_version, 'small'))
    thresh = thresh / 2^12;
end
[newSino, offsets] = recenterSinogram(sino, thresh);
proj = fixProjections(proj, offsets);
% figure; imshow(sino,[]);
% figure; imshow(newSino,[min(sino(:)),max(sino(:))]);


%% Reorganize data and deconvolve with 2D PSF
disp('Deconvolving projections...');
p = load(psfFilename); % Load psf data
h = p.psf;
if (strcmp(dataset_version, 'small'))
    h = imresize(h, 0.5);
end
[hInv, HInv] = getInverseFilter2D(h,lambda,Nr);
deconvproj = zeros(size(proj));
for n = 0:Nangles-1
    deconvproj(:,:,n+1) = ifftn(fftn(proj(:,:,n+1)) .* HInv);
    disp([num2str(n+1), ' / ', num2str(Nangles)])
end
deconvproj = max(0, deconvproj); % Clip negative values
disp('Done with deconvolution.');


%% Filtered backprojection
disp('Performing filtered backprojection...');

M = 2*floor(Nr/(2*sqrt(2)));
totalAngles = 360; % 180 or 360 rotation acquired?
theta = 0:totalAngles/Nangles:totalAngles/Nangles*(Nangles-1);

transpose = false;
recenter = false;
verbose = true;
vol3D = reconstructOPT(deconvproj,theta,transpose,recenter,verbose);
% To run the OPT reconstruction without PSF deconvolution, simply run:
% vol3D = reconstructOPT(proj,theta,transpose,recenter,verbose);

% disp('Saving reconstruction...');
% output_filename_mat = 'fpsopt_reconstruction.mat';
% save(output_filename_mat,'vol3D');

% Show maximum intensity projection
figure('Name','Maximum Intensity Projection'); imshow(squeeze(max(vol3D,[],1)),[])

disp('Done!');