# OpenGoSim

Main contributors: Pablo Salinas, Paolo Orsini.

The simulator used for this study is the open-source code [PFLOTRAN-OGS 1.8](https://opengosim.com/), which will be renamed Cirrus in future releases. PFLOTRAN-OGS is a finite volume, fully-implicit and parallel reservoir simulator focused on CO2 sequestration. The linear system of equations is solved using a constrained pressure residual method with an algebraic multigrid pressure solution step.

For this study we have used a two-phase (aqueous and vapor), two-component (CO2 and water) approach, both components can be present in both phases. The model was discretized using a structured grid; the time-step size is dynamically selected based on the performance of the non-linear solver.  

Well models where used for the CO2 injection. Moreover, for thermal cases we consider the Joule-Thomson effect not only in the reservoir but also within the well. Boundary conditions were considered to exchange heat but not flow.

The only difference between the different results presented is the grid resolution used.
