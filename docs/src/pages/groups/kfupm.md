# KFUPM

Main contributor: AbdAllah A. Youssef

The KFUPM group employed ECLIPSE-300 2024.1 to simulate the SPE-11B case, using a uniform block-centered structured mesh with 840 × 1 × 120 cells in the x, y and z directions, respectively. Thermodynamic parameters were evaluated using the default CO2STORE model. A fully-implicit discretization scheme was implemented alongside the JALS-tuned linear solver, which was crucial in maintaining mass conservation. To mitigate computation cost associated with the non-convergence of the non-linear solver, capillary pressure curves of flowing layers 2–5 were modified near and below swr by imposing semi-log extension (Webb, 2000) to prevent huge pressure drop near swr which causes reduction in time step. Additionally, krg of sealing facies-1 was set to zero, except at sg = 1, to ensure that gas flow was restricted in this layer.

Two distinct approaches were utilized to model the buffer region. In Result 1, the buffer was modeled using numerical aquifers connected to the main domain. However, this method introduced some deviations in estimating CO2 mass within the buffer, as ECLIPSE limits the migration of components, allowing only H2O to move into the numerical aquifers. Result 2 adopted a pore-volume multiplier approach for the buffer region, which enabled the transfer of all species between the buffer and the main aquifer, providing a more comprehensive solution.

Dirichlet temperature condition was applied at the top and bottom faces by connecting the model to cap and base rocks. These rocks, possessing high heat capacities, were initialized at temperatures of 40 oC and 70 oC, respectively. Both dispersion and diffusion were neglected as “THERMAL” option in ECLISPE is not compatible with them. The sources were modeled using standard well model.

## Acknowledgements

### People

The KFUPM team extends its sincere gratitude to Mohamed Abdalla, Software Engineer at the Department of Petroleum Engineering, KFUPM, for his invaluable contributions and constructive suggestions in selecting the appropriate Eclipse-300 keywords.
