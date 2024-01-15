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

The parts list necessary to build an OPTImAL instrument is provided, here, and the CAD files for the custom machined parts are provided [here](https://github.com/ImperialCollegeLondon/OPTImAL/tree/ddca39fbce2276cda13a804aa99c55197d427f0d/OPTImAL%20CAD).

We are licensing the core mechanical components under under the permissive version of the CERN Open Hardware License Version 2 (https://ohwr.org/cern_ohl_p_v2.pdf), including the component designs hosted on this repository. We do not wish to restrict users in their ability to utilise these components and, as well as supporting the assembly of open instrumentation, these components can be used with closed-source and proprietary technologies.

# Image Acquisition

We utilise [Micro-Manager](https://micro-manager.org/Version_2.0) for hardware control, and provide a plugin (OPT for MM2) for performing OPT measurements.

Micro-Manager uses the Lesser GPL license (https://www.gnu.org/licenses/lgpl-3.0.en.html) for its core and the BSD 2-clause license (https://opensource.org/license/bsd-2-clause/) for the GUI and device adapters. Our OPT for MM2 plugin is licensed under the BSD 2-clause license (https://opensource.org/license/bsd-2-clause/).

We also provide a [sinogram checker macro](https://github.com/ImperialCollegeLondon/OPTImAL/tree/ddca39fbce2276cda13a804aa99c55197d427f0d/Sinogram%20Checker) for [ImageJ](imagej.net), licensed under the BSD 2-clause license (https://opensource.org/license/bsd-2-clause/).

For guidance in performing OPT measurements, our OPT imaging protocol can be dowloaded [here](https://github.com/ImperialCollegeLondon/OPTImAL/files/13943130/OPT_Imaging_Protocol.pdf)

# Volumetric Image Reconstruction

We provide [OPTtools](https://github.com/cjd12/OPTtools/tree/9e8556d8f671e3294043d17689f80826fe05ce26), a plugin (based on [ALYTools](https://github.com/yalexand/ALYtools) written in MATLAB for reconstruction of OPT data.

This software is licensed under the BSD 2-clause license (https://opensource.org/license/bsd-2-clause/).

# Fan beam reconstruction for focal scanning OPT

