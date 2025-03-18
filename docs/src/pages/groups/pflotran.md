# PFLOTRAN

Main contributors:  Michael Nole, Glenn Hammond

The PFLOTRAN group used version 6.0 of the open-source massively parallel reactive multiphase flow simulator [PFLOTRAN](https://pflotran.org/) to produce the submitted results. PFLOTRAN’s SCO2 Mode is specifically designed to solve conservation equations for CO2 mass, water mass, salt mass, and energy including miscibility and capillary effects. PFLOTRAN’s SCO2 mode uses a finite volume spatial discretization, is backward Euler in time, and solves a fully implicit system of equations using a Newton-Raphson nonlinear solution search method with adaptive time stepping. It can optionally include a fully coupled well model in this system of equations; the well model was used to solve SPE 11B.

The SPE11 problems were all solved on structured grids at resolutions roughly equal to the reporting grids for Variants A and B. Variant C was modeled at higher resolution and interpolated to the reporting grid. Facies were generated using a custom set of scripts to convert to a PFLOTRAN-readable HDF5 format from gmesh output as provided by the SPE problem description. Dispersion was set to zero for all problems. A fully coupled well model was used for Variant B; Variants A and C modeled CO2 injections using source terms. CO2 thermodynamic properties were interpolated from a database compiled using the Span-Wagner equation of state.

Acknowledgements (funding): This research was supported by Pacific Northwest National Laboratory’s Laboratory-Directed Research and Development (LDRD) program, Award No. 211622. PNNL is operated for the DOE by Battelle Memorial Institute under contract DE-AC05-76RL01830. This paper describes objective technical results and analysis. Any subjective views or opinions that might be expressed in the paper do not necessarily represent the views of the U.S. Department of Energy or the United States Government.

## Acknowledgements

### People

Additional contributions to the PFLOTRAN SPE11 submissions by Katherine Muller and Xiaoliang He (Earth Systems Science Division, Pacific Northwest National Laboratory).
