# Pau-INRIA

Main contributors: Etienne Ahusborde, Michel Kern

The Pau-Inria group utilized the version 3.8 of the open-source platform [DuMuX](https://dumux.org/) [1] to produce the submitted results. A compositional model, implemented in DuMuX, was employed to simulate a two-phase, two-component flow (water and CO2).  We were able to use nearly all the methods we needed, as they were implemented in DuMuX. The phase transitions (appearance and disappearance) are handled in DuMuX by a variable switching mechanism, using gas pressure and either liquid saturation or CO2 molar/mass fraction, depending on the number and type of phases present.

All three test cases were conducted on structured orthogonal grids. For test Case A, it was essential to employ a highly non-uniform grid. We ran all the computations by using the cell-centered Two-Point Flux Approximation (TPFA) finite volume scheme available in DuMuX for the spatial discretization. The grids were managed through the DUNE-ALUGrid module [2] . A fully implicit method, coupled with a first-order backward Euler scheme, was applied for the time discretization. Dispersion was not included, we considered only molecular diffusion. CO₂ injection was modeled using point source terms in the relevant cells rather than wells. DuMuX uses the Spycher-Pruess EOS, in conjunction with the NIST database, for the thermodynamic data.

To solve the nonlinear system, DuMuX uses a Newton-Raphson algorithm, where the Jacobian matrix is approximated via numerical differentiation. Additionally, an adaptive timestepping strategy is implemented, where the time-step is adjusted depending on the number of iterations required to achieve convergence in the previous time step by the Newton method. The linear systems were solved using a BiConjugate Gradient STABilized (BiCGSTAB) method, preconditioned with an Algebraic Multigrid (AMG) solver. It was necessary to adjust the tolerance for the Newton-Raphson algorithm (10-5 instead of 10-8)  to allow convergence for all time steps.

[1] Koch, T. et al. (2021). DuMux 3 – an open-source simulator for solving flow and transport problems in porous media with a focus on model coupling. Computers & Mathematics with Applications, 81, 423-443.

[2] Alkämper, M., Dedner, A., Klöfkorn, R., & Nolte, M. (2015). The DUNE-ALUGrid Module, arXiv:1407.695.
