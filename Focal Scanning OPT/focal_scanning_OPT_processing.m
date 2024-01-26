%% Script for reconstructing OPTImAL focal scanning data %%
% This script relies on the ASTRA toolbox for fan-beam geometry reconstruction,
% available here: https://astra-toolbox.com

% It also relies on functions and protocols presented in 'Direct inversion
% algorithm for focal plane scanning optical projection tomography' (Chan &
% Leibling, 2017), with the algorithms available here: http://sybil.ece.ucsb.edu/pages/fpsopt/
% (and re-distributed under the BSD-2 clause license here).

% It also relies on the function 'pad_sinogram_for_iradon', which is included
% as part of OPTtools, available here: https://github.com/ImperialCollegeLondon/OPTImAL

% To simulate the 3D system PSF, we recommend the open-source MATLAB plugin
% 'PSF Generator', available here:
% http://bigwww.epfl.ch/algorithms/psfgenerator/.


%% First, load projetion images
% skip if projection images are already loaded in MATLAB workspace

% If projection data requires post-acquisition alignment, projection images can be first
% aligned using the OPTtools MATLAB plugin, available at https://github.com/ImperialCollegeLondon/OPTImAL

path = pwd;
cd('aligned projection image directory') % replace with relevant projection image directory
A=dir ('*.tif');
for i=1:length(A)
    rawprojection(:,:,i)=im2double(imread(A(i).name)); % imports projection images as double arrays into workspace
end

cd(path); % return to working directory

%% Next, generate 3D PSF and filter for deconvolution of projection images

javaaddpath '/Program Files/MATLAB/R2023b/java/PSFGenerator.jar' % Please alter path to PSFGenerator.jar as appropriate.
PSFGenerator.gui % Runs the PSFGenerator GUI. Please use the GUI to input suitable system parameters.
% Note - the PSFGenerator GUI does not accept NA values below 0.1 NA. It
% may be helpful to multiply the system NA by a factor of 10, and
% accordling divide your pixel size by a factor of 10, to yeild a correctly
% sized model PSF.
% PSF z range should be matched to scan range of liquid lens.
psf_3dmodel = PSFGenerator.get; % Imports modelled 3D PSF into MATLAB workspace.

psf_projection = sum(psf_3dmodel ,3); % Generate 2D a projection through the 3D PSF. 
psf_padded_projection= padarray(psf_projection,[floor((size(rawprojection,1)-size(psf_projection,1))/2+50) floor((size(rawprojection,2)-size(psf_projection,2))/2+50)],'both');
% padding projection to be same size as projection image (plus extra padding), in order to
% perform deconvolution step.
[hInvf, HInvf] = getInverseFilter2D_nonsquare(psf_padded_projection,0.0002,[size(rawprojection,1)+100 size(rawprojection,2)+100]); % Generate inverse filter from PSF projection - using adapted script from http://sybil.ece.ucsb.edu/pages/fpsopt/


%% Use the generated filter to deconvolve the projection images

for i=1:length(A)
    padded_projection(:,:,i) = padarray(rawprojection(:,:,i),[50 50],'both','replicate'); % padding to match the PSF projection, to eliminate edge artefacts
    decon_projection(:,:,i) = ifftn(fftn(padded_projection(:,:,i)) .* HInvf); % Deconvolution step. Based on script found here: http://sybil.ece.ucsb.edu/pages/fpsopt/
end

decon_projection(decon_projection<0)=0; % clip negative values

decon_projection = decon_projection(51:end-50,51:end-50,:); % remove edge padding.


%% Generate sinograms ready for reconstruction

for i = 1:size(decon_projection,1)
    % for vertical rotation axis:
    sinograms(:,:,i) = pad_sinogram_for_iradon(squeeze(decon_projection(i,:,:))); % pad sinograms ready for reconstruction, to avoid edge artefacts
end

% alternatively for horizontal rotation axis:
%for i = 1:size(decon_projection,2)
%    sinograms(:,:,i) = pad_sinogram_for_iradon(squeeze(decon_projection(:,i,:)));
%end

%% Run fan beam reconstruction

for i = 1:size(sinograms,3)
    vol_geom = astra_create_vol_geom(size(sinograms,1),size(sinograms,1)); % create reconstruction volume geometry
    proj_geom = astra_create_proj_geom('fanflat',1.0,size(sinograms,1),linspace((1/1280)*2*pi,((641)/1280)*2*pi,640),-181000,0); % define projection geometry
    % This example is for 640 projections, recorded over 180 degrees, with an
    % empirically derived fanbeam origin of -181000 for the 0.75x MercuryTL
    % liquid tunable lens, with projections recorded with a CellCam Kikker in
    % high resolution mode.
    sinogram_id = astra_mex_data2d('create','-sino',proj_geom,(sinograms(:,:,i)'));
    rec_id = astra_mex_data2d('create','-vol',vol_geom);
    cfg = astra_struct('FBP_CUDA'); % using GPU accelerated FBP algorithm.
    cfg.ReconstructionDataId = rec_id;
    cfg.ProjectionDataId = sinogram_id;
    cfg.option.FilterType = 'Ram-Lak';
    alg_id = astra_mex_algorithm('create', cfg);
    astra_mex_algorithm('run', alg_id);
    recon(:,:,i) = astra_mex_data2d('get', rec_id); % run reconstruction
    astra_mex_data2d('delete', sinogram_id, rec_id);
    astra_mex_algorithm('delete', alg_id);
end

recon(recon<0)=0; % clipping non-physical negative values.
