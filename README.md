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

We also provide a sinogram checker macro for [ImageJ](imagej.net), licensed under the BSD 2-clause license (https://opensource.org/license/bsd-2-clause/).

Our OPT imaging protocol can be dowloaded here: [OPT_Imaging_Protocol.pdf](https://github.com/ImperialCollegeLondon/OPTImAL/files/13943130/OPT_Imaging_Protocol.pdf)

# Volumetric Image Reconstruction

OPTtools

# Fan beam reconstruction for focal scanning OPT

