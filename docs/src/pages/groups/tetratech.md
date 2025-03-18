# TetraTech

Main contributors: Adam Turner19, Hai Huang22 and David Element20

The Tetra Tech / RPS group used two software packages, Rock Flow Dynamics’ tNavigator simulator (v24.2) and STOMP-CO221 code developed at Pacific Northwest National Laboratory (PNNL), to generate the submitted results. tNavigator was used to model cases 11B and 11C, and the STOMP-CO2 simulator was used to model cases 11A, 11B and 11C.

Both tNavigator and STOMP-CO2 simulators run the modelled 2-D and 3-D subsurface CO2 storage problems using a Cartesian grid with the same dimensions as for dense data reporting. For problem 11C, STOMP-CO2 simulator used a curvilinear grid that follows the formation horizon topology in the Y-direction and remains rectilinear in the X-Y plane and for tNavigator a similar corner-point grid was generated using the [pyopmspe11 library](https://github.com/OPM/pyopmspe11).

Both tNavigator and STOMP-CO2 simulators adopt a fully-implicit time integration approach with dynamic, adaptive timestepping scheme, and use Newton’s method for solving coupled multiphase flow and thermal/solute transport equations. Simulations were run in compositional mode. The simulator timesteps did not necessarily align with the reference temporal resolution and therefore required linear interpolation to generate the reported data at the frequency required.

Both simulators applied Spycher-Pruess equation of state (EOS) to compute fluid PVT behaviors and the relevant thermodynamic properties were taken from data published by NIST or from the problem description. For problem 11C, STOMP-CO2 simulator ignored the thermal transport process, for the purposes of both computational efficiency and assessing the thermal effect on spatial-temporal distributions of the injected CO2 at reservoir scales.

During post-processing of results, the convective mixing term, M(t), was calculated at the same reporting times as used for the dense data. For this calculation, the maximum solubility term was calculated using bilinear interpolation of a table of solubilities as a function of temperature and pressure constructed using the Spycher-Pruess equations. For all the three modelled problems in this study, STOMP-CO2 simulator ignored the calculations of dispersive fluxes and only considered the diffusive fluxes with diffusion

constants specified in the problem descriptions. No molecular diffusion was modelled in the tNavigator simulations. STOMP-CO2 simulator applied a pore-volume multiplier approach to “augment” the pore volumes of lateral boundary grid cells in SPE 11B and SPE11C in the way as specified by SPE11 problem descriptions. For all three SPE11 problems, STOMP-CO2 simply treated injection wells as constant-rate pure CO2 sources at specified injection temperature.

The tNavigator simulations for SPE11B and SPE11C also employed pore-volume multipliers to the model edge cells to account for the augmented boundary volumes. The constant temperature boundary conditions for the top and bottom were approximated by specifying high thermal conductivity and heat capacity for overburden and underburden.

## Acknowledgements

### People

Additional contributions to the SLB SPE11 submissions by: Ali Bahrami, Mark White, and Rock Flow Dynamics for their support and license provision.
