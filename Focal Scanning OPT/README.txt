Script for reconstructing OPTImAL focal scanning data


This script relies on the ASTRA toolbox for fan-beam geometry reconstruction, available here: https://astra-toolbox.com

It also relies on functions and protocols presented in 'Direct inversion algorithm for focal plane scanning optical projection tomography' (Chan &
Leibling, 2017), with the algorithms available here: http://sybil.ece.ucsb.edu/pages/fpsopt/
(and re-distributed under the BSD-2 clause license here, in the folder 'fpsopt'). An adapted version of the function getInverseFilter2D.m for the processing
of non-square projection images is included here, labelled getInverseFilter2D_nonsquare.m.

This script also relies on the function 'pad_sinogram_for_iradon', which is included as part of OPTtools, available here:
https://github.com/ImperialCollegeLondon/OPTImAL

To simulate the 3D system PSF, we use the open-source MATLAB plugin 'PSF Generator', available here:
http://bigwww.epfl.ch/algorithms/psfgenerator/