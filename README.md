# OPTImAL
_'OPT system Implemented for Accessibility and Low-cost'_

- [Overview](#overview)
- [Open Hardware](#open-hardware)
- [Image Acquisition](#image-acquisition)
- [Volumetric Image Reconstruction](#volumetric-image-reconstruction)
- [Fan beam reconstruction for focal scanning OPT](#fan-beam-reconstruction-for-focal-scanning-opt)


# Overview

This repository hosts supporting information, open source software and hardware support for our open OPT platform, OPTImAL.

# Open Hardware

The parts list necessary to build an OPTImAL instrument is provided, [here](https://github.com/ImperialCollegeLondon/OPTImAL/blob/main/OPTImAL_parts_list.xlsx), and the CAD files for the custom machined parts are provided [here](https://github.com/ImperialCollegeLondon/OPTImAL/tree/ddca39fbce2276cda13a804aa99c55197d427f0d/OPTImAL%20CAD).

We are licensing the core mechanical components under under the permissive version of the CERN Open Hardware License Version 2 (https://ohwr.org/cern_ohl_p_v2.pdf), including the component designs hosted on this repository. We do not wish to restrict users in their ability to utilise these components and, as well as supporting the assembly of open instrumentation, these components can be used with closed-source and proprietary technologies.

# Image Acquisition

We utilise [Micro-Manager](https://micro-manager.org/Version_2.0) for hardware control, and provide a plugin (OPT for MM2) for performing OPT measurements.

Micro-Manager uses the Lesser GPL license (https://www.gnu.org/licenses/lgpl-3.0.en.html) for its core and the BSD 2-clause license (https://opensource.org/license/bsd-2-clause/) for the GUI and device adapters. Our OPT for MM2 plugin is licensed under the BSD 2-clause license (https://opensource.org/license/bsd-2-clause/).

We also provide a [sinogram checker macro](https://github.com/ImperialCollegeLondon/OPTImAL/tree/main/Sinogram%20Checker) for [ImageJ](imagej.net), licensed under the BSD 2-clause license (https://opensource.org/license/bsd-2-clause/).

For guidance in performing OPT measurements, our OPT imaging protocol can be dowloaded [here](https://github.com/ImperialCollegeLondon/OPTImAL/files/13943130/OPT_Imaging_Protocol.pdf)

# Volumetric Image Reconstruction

We provide [OPTtools](https://github.com/cjd12/OPTtools/tree/9e8556d8f671e3294043d17689f80826fe05ce26), a plugin (based on [ALYTools](https://github.com/yalexand/ALYtools) written in MATLAB for reconstruction of OPT data.

This software is licensed under the BSD 2-clause license (https://opensource.org/license/bsd-2-clause/).

# Fan beam reconstruction for focal scanning OPT

We provide a MATLAB script for the reconstruction of focal scanning OPT data, including deconvolution of projection images to remove out-of-focus blurred contributions, and a fan-beam projection geometry reconstruction to correct for the non-telecentric imaging realised when using the MercuryTL 0.75x telecentric lens with liquid tunable lens.

This script relies on the ASTRA toolbox for fan-beam geometry reconstruction, available here: [https://astra-toolbox.com](https://astra-toolbox.com)

It also relies on functions and protocols presented in 'Direct inversion algorithm for focal plane scanning optical projection tomography' ([Chan &
Leibling, 2017](https://doi.org/10.1364/BOE.8.005349)), with the algorithms available here: [http://sybil.ece.ucsb.edu/pages/fpsopt/](http://sybil.ece.ucsb.edu/pages/fpsopt/)
(and re-distributed under the BSD-2 clause license here, in the folder 'fpsopt'). An adapted version of the function getInverseFilter2D.m for the processing
of non-square projection images is included here, labelled 'getInverseFilter2D_nonsquare.m'.

This script also relies on the function 'pad_sinogram_for_iradon', which is included as part of [OPTtools](https://github.com/cjd12/OPTtools/tree/9e8556d8f671e3294043d17689f80826fe05ce26).

To simulate the 3D system PSF, we use the open-source MATLAB plugin 'PSF Generator', available here:
[http://bigwww.epfl.ch/algorithms/psfgenerator/](http://bigwww.epfl.ch/algorithms/psfgenerator/).
