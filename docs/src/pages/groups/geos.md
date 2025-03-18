# GEOS

Main contributors: Jacques Franc (Stanford), Dickson Kachuma (TotalEnergies)

GEOS (v1.1.0) is an open-source framework for simulating thermo-hydro-mechanical processes, with a focus on subsurface applications (Settgast et al. 2024). A particular focus of the effort is platform portability, providing the flexibility to run simulations on a variety of CPU- and GPU-based architectures in an efficient and scalable way.

For the SPE11 benchmarks, a thermal-compositional flow solver, using a global variable formulation, was used. This solver is based on a fully-implicit finite volume discretization, with two-point flux approximations. Nonlinear systems were solved using Newton’s method with line search, with adaptive timestepping based on the observed convergence behavior. Linear systems were solved using an iterative solver with a Multigrid Reduction (MGR) preconditioner from the hypre library (Bui et al. 2021).

The fluid is modelled as a two-phase (liquid and gas) two-component fluid with carbon-dioxide (CO2) and water (H2O) as the components. In all fluid models the CO2 component can dissolve in the liquid phase. For SPE11A the partitioning of the pure CO2-H2O system follows Spycher et al. (2003). For SPE11B and SPE11C the partitioning follows Duan & Sun (2003). Pure water properties obtained from the NIST database (Lemmon et al., 2018) were used for the liquid density and viscosity. The correction by Garcia (2001) was applied to the density to account for dissolved CO2. Liquid enthalpy was determined using the correlation provided by Michaelides (1981). Gas density and enthalpy follow Span & Wagner (1996) whereas gas viscosity follows Fenghour & Wakeham (1998). Simulations were run using only diffusive fluxes and no dispersive fluxes. The injection conditions were modeled using source terms without a wellbore model.

Relative permeabilities and capillary pressures are implemented using tabulated versions of the functions given in the CSP description, except for the SPE11C. For this case, a Brooks-Corey analytic function was used for the capillary pressure giving access to the full derivatives though discarding the renormalization prescribed in the description. Note also that for SPE11A, a maximum capillary pressure of 2500 Pa was used as suggested in the description. The east and west (and north and south) boundary buffers were modeled as a single cell layer with prescribed large volumes. These volume multipliers were adjusted upon refinement.

The sets of results are differentiated by grid size: SPE11A used a regular mesh with facies 7 removed. Result 1 used grid blocks of size 1cmx1cm. Result 2 used grid blocks of size 1.25mmx1.25mm. SPE11B used a regular mesh. Result 1 used grid blocks of size 10mx10m. Result 2 used grid blocks of size 2.5mx2.5m. SPE11C used a regular mesh restricted to the simulation region. Result 1 used grid blocks of size 50mx50mx10m. Result 2 used grid blocks of size 25mx25mx5m.

## Acknowledgements

### Funding

Funding for this work was provided by TotalEnergies and Chevron through the FC-Maelstrom project, a collaborative effort between Lawrence Livermore National Laboratory, Total Energies, Chevron, and Stanford University. Portions of this work were performed under the auspices of the U.S. Department of Energy by Lawrence Livermore National Laboratory under Contract DE-AC52-07NA27344.

### People

Additional contributions to the GEOS SPE11 submissions by: Thomas J. Byer, Nicola Castelletto, Matteo Cusini, Herve Gross, Francois Hamon, Mohammad Karimi-Fard, Victor A. P. Magri, Randolph R. Settgast, Pavel Tomin, and Joshua A. White.
