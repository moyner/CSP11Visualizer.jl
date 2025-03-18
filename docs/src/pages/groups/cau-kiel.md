# CAU-Kiel

Main contributors: Firdovsi Gasanzade, Sebastian Bauer

The Kiel group used the OPM Flow open-source simulator, applying adaptive time-stepping und using parallelized computations on the high-performance Linux cluster of Kiel University. The simulator version used was 2024.04 (built time 2024-08-07 at 16:37). Problem SPE11A was solved using only 14 logical cores, while for SPE11B and SPE11C 32 cores were used. Mesh generation and parameterization were based on a structured grid, with facies distributions derived from the GitHub collaborative resource and remapped for each problem using in-house scripts (documented under github.com/fgasa/11thSPE-CSP-Kiel). Alternative to the benchmark description the CoolProp thermodynamic library was used instead of the NIST database. For problem SPE11A, a 30-minute initialization period before injection start was added to the simulation to achieve numerical stability. Problem SPE11B allowed for an extensive sensitivity study on e.g., grid resolution, timestep size and boundary effects. The main issue observed was the impact of grid size on temperature effects, as large grid cells could lead to unphysical temperature oscillations in the vicinity of Well #1. Therefore, the grid size in the K direction is half the size of the reporting grid. The computational grid for problem SPE11C was generated using a Gaussian function to mimic the anticline shape, keeping the crest point and dip angle according to the benchmark description. The resulting mesh is fully symmetric, as shown by Okoroafor et al. (2023) (doi.org/10.1016/j.enconman.2023.117409). Although extensive sensitivity analysis was performed for each case, only a single set of model results seen as most representative was submitted and is thus presented in the manuscript.

## Acknowledgements

### Funding

This research was supported by Kiel University by providing the high-performance computing resources at the Kiel University Computing Centre.
