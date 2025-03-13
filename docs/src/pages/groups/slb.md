# SLB

Main contributors: Marie Ann Giddins

The SLB team used two general-purpose commercial reservoir simulators for the submissions: Eclipse Compositional (version 2024.2) for SPE11A submission SLB1 and Intersect (version 2024.2) for SPE11A submission SLB2, SPE11B and SPE11C. SLB used inbuilt simulator options for CO2 storage in aquifers, representing models that could be used in typical reservoir engineering practice, as a starting point for more detailed CO2 studies.

The submissions used cell-centered TPFA discretization, on Cartesian grids corresponding to the reporting grid formats, with facies mapped from the provided mesh file. Fluid properties were calculated using methods from Spycher and Preuss (2005, 2009), with Ezrokhi’s method for brine density calculations (Zaytsev and Aseyev, 1996). The diffusion model was adjusted to approximate combined diffusion and dispersion effects.

The commercial simulators’ standard well models were used for CO2 injection. Thermal submissions assumed constant enthalpy for the fluid injection streams, defined at temperature 10°C and the initial pressure at Well 1. External boundaries were treated as no-flow, with heat boundary conditions represented by a semi-analytical heat loss model (Vinsome and Westerveld, 1980).

All runs were fully implicit, with CPR preconditioning and adaptive timestepping. Intersect models were run in parallel using ParMETIS-based unstructured parallel partitioning. Time steps were constrained to match the reporting times specified in the SPE description.

## Acknowledgements

### People

Acknowledgements (people): Additional contributions to the SLB SPE11 submissions by: Jarle Haukås from SLB Norge and Marat Shaykhattarov from SLB UK.
