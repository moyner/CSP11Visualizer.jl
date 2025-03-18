# IFPEN

Main contributors: Didier Ding, Eric Flauraud

Geoxim/CooresFlow is a research software developed by IFPEN. It is a non-isothermal compositional multi-phase flow simulator that uses the variable switching formulation based on natural unknowns (pressure, temperature, phase saturation and species molar fractions). To discretize the set of equations, the cell-centered finite volume method with fully implicit approach is used.

Although unstructured grids can be used in Geoxim/CooresFlow, we only use Cartesian grids for SPE11 simulations. A two-component table (in P, T) was used to describe pure densities, viscosities and K-values. Diffusion and dispersion were considered in our simulator. A standard fully-implicit scheme with dynamic time stepping was used for the time discretization. A custom function for CO2-brine mixing density has been implemented specifically for this CSP. Well and boundary conditions were adapted to align with the benchmark.

We have provided two sets of results for SPE11B. The difference is the grid block size. For result1, 840x120 cells with size of 10x10 m are used on the uniform Cartesian grid, while for result2, 3360x480 cells are used with cell size of 2.5x2.5 m. For SPE11A and SPE11C, the reporting grid was used.

## Acknowledgements

### People

Additional contributions to the IFPEN SPE11 submissions by: Anthony Michel, Isabelle Faille
