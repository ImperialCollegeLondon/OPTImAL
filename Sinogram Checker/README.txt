ImageJ Macro for checking OPT projection data.

Installation:
ImageJ -> Plugins -> Macros -> Install... -> Select the OPTImAL sinogram checker macro (for either vertical rotation axes or horizontal rotation axes, as appropriate).

Usage instructions:
1. Use the rectangular selection tool in ImageJ to select a single row of pixels (perpendicular to the rotation axis) from your set of projection images.
2. Run the relevant Sinogram Checker Macro (e.g., Plugins -> Macros -> OPTImAL_sinogram_checker_horizontal)
3. A sinogram will be generated for the selected pixel row, duplicated, and the sinogram and its duplicate stacked vertically.
4. Inspect the sinogram for any obvious discontinuities in the central row, where the sinogram repeats.
5. A discontinuity indicates that the sample has moved/drifted during the acquisition (i.e. it has not returned to the same point after rotation through 360 degrees).
6. Indeed, any obvious discontinuities in the sinogram (at any point) may indicate that the sample was knocked/collided with the cuvette wall.