# Stuttgart

Main contributors:  Kai Wendel,  Holger Class 

The USTUTT-LH2 group employed the open-source code DuMuX 3.9 (Koch et al, 2021) to generate the submitted results. The simulator uses cell-centered finite volumes with two-point flux approximation for the spatial discretization and implicit Euler for the time discretization.  

We only submitted results for the B case where a constrained-pressure-residual AMG-based solver was used as preconditioner and computation were done on the reporting grid. Sources, boundary conditions and diffusion were adjusted to match the SPE11 problem description. For internal Dirichlet conditions, we assigned temperatures to impermeable facies (facies 7) with low permeabilities and porosities to approximate the impermeable layer. The pc-sw, krw-sw, krn-sw curves were approximated by piecewise-linear functions with 1000 support points. Support points are denser for small sw computed by a transformation.

Three different models were used, dispersion was not accounted for and diffusion only in the 2p2cni model, as described. The models are sequentially coupled as explained in Darcis et al. (2011):  

- 1pni: One phase non-isothermal model with a pure water phase
- 2pni: Two phase non-isothermal immiscible model with pure water phase (wetting) and pure CO2 phase (nonwetting)
- 2p2cni: Two phase compositional model with symmetric switch based on the DuMuX core CO2 model.

These where combined to generate four results:

- Result1: Using a 2p2cni model for the whole simulation time.
- Result2: The 1pni model was used for initialization, followed by the 2pni model for the injection period. After injection, the 2p2cni model accounted for compositional effects.
- Results3: Same as result2, but with the 2pni until 25 years after end of the injection.
- Results4: 1pni for the initialization and a 2pni model until the end of the simulation.

In all models, aqueous phase pressure [Pa] and temperature [K] are primary variables. In the 2pni model, gas phase saturation (Sg) was added to close the system. The 2p2cni model used a variable-switching approach depending on the local state.

## Acknowledgements

### Funding

Acknowledgements (funding): The work of the group was financially supported by the Collaborative Research Cluster CRC 1313 (DFG – German Research Foundation, Project Number 32754368-SFB 1313, where Kai Wendel has received three months of funding.

### People

Additional contributions to the Stuttgart SPE11 submissions by: Bernd Flemisch, Dennis Gläser from Stuttgart University and Timo Koch from University of Oslo.
