# OPM

Main contributors: Tor Harald Sandve (NORCE), David Landa-Marbán (NORCE), Kjetil Olsen Lye (SINTEF), Jakob Torben(SINTEF)

The OPM group used the simulator OPM Flow (v. 2024.10, https://opm-project.org/), which is an open-source, fully implicit, black-oil simulator that can handle industry-standard simulation models. OPM Flow contains features such as two-point approximation in space with upstream-mobility weighting, flexible assembly using automatic differentiation, adaptive step-size controls, and grid partition for parallel runs.

For the SPE11, the CO2STORE option was used, which relies on the simulator’s CO2–brine PVT model that was adapted to the SPE11 description. Similarly, sources, boundary conditions, diffusion, and dispersion were adapted to align with the benchmark. For the generation of the input decks (including corner-point grids, saturation-function tables, well/source locations, injection schedules), as well as for the generation of the reporting data with the format requested in the official SPE11 description, a Python tool called pyopmspe11 has been developed. Together with the 12 configuration files (OPM1 to OPM4 submissions for the three SPE11 cases), these have been made openly available (https://github.com/OPM/pyopmspe11).

For all three cases, the OPM1 submissions were generated with the grid size specified for the data reporting and standard simulation choices, while the OPM4 submissions were generated with finer grids. OPM2 and OPM3 aim to show the impact of solver and parameter choices, grid orientation effects, and subgrid modeling for convective mixing.

For SPE11A, using the maximum value of 2500 Pa (OPM2) instead of 95000 Pa (OPM1) did not significantly impact the results, and reduced the simulation time. For SPE11B, the results using a subgrid model (OPM3) for convective mixing compare reasonably well to the fine-scale simulations (OPM4). To show the scalability of OPM Flow, a case with more than 100 million cells (OPM4) was submitted for SPE11C. For additional information about the different submitted cases, we refer to https://opm.github.io/pyopmspe11/benchmark.html.

## Acknowledgements

### Funding

The work of the OPM group has been supported by Gassnova through the Climit Demo program and by Equinor ASA (622059). Tor Harald Sandve and David Landa-Marbán acknowledge additional funding from the Centre of Sustainable Subsurface Resources (CSSR), grant no. 331841, supported by the Research Council of Norway, research partners NORCE (Norwegian Research Centre) and the University of Bergen, and user partners Equinor ASA, Harbour Energy, Sumitomo Corporation, Earth Science Analytics, GCE Ocean Technology, and SLB Scandinavia.

### People

Additional contributions to the OPM SPE11 submissions by: Atgeirr Rasmussen, Bård Skaflestad, Andreas Brostrøm, Kai Bao, Halvor Møll Nilsen, Olav Møyner, Elyes Ahmed, from SINTEF Digital; Lisa J. Nebel and Markus Blatt from OPM-OP; Eduardo Barros and Negar Khoshnevis Gargar from TNO; Alf Birger Rustad from Equinor; and Trine Mykkeltvedt from NORCE.
