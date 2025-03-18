# CSIRO

Main contributors: Christopher Green, Mohammad Sayyafzadeh

CSIRO used MOOSE (mooseframework.inl.gov), an open-source simulation framework with which we have developed compositional multiphase flow capability (Wilkins, Green and Ennis-King, 2021). A finite volume discretization and fully implicit backward Euler timestepping was used to solve the governing equations (formulated as component mass balances).

The grids were generated using the GMSH and python scripts supplied by the organizers. Water and CO2 properties, as well as mutual solubility of the two fluid components, were computed using the models specified in the description. All physical processes, boundary conditions and wells were implemented as specified in the project description.

We submitted one case for both SPE11B and SPE11C, respectively, using a Cartesian grid with the same resolution as the reporting grid. We submitted two results for SPE11A: one using the base reporting grid resolution (uniform 10 mm) and another with a single level of uniform refinement (uniform 5 mm). The results demonstrate a grid dependency, where an additional CO2 plume is formed in Box B in the coarse simulation which is absent in the finer case. This discrepancy likely results from volume averaging in the cell-centered TPFA formulation. In coarse grids, the averaging artificially increases the pressure difference at the interface/vertices of cells. This can lead to a higher probability of exceeding the capillary entry pressure in adjacent facies, allowing the non-wetting phase to penetrate.

## Acknowledgements

### People

Additional contributions to the CSIRO SPE11 submissions by: James Gunning
