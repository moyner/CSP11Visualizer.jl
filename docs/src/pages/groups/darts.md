# DARTS

Main contributors: George Hadjisotiriou, Denis V. Voskov

The Delft Advanced Research Terra Simulator (open-DARTS 1.1.4) is an open-source simulation framework designed for forward and inverse modeling, as well as uncertainty quantification. Open-DARTS employs a unified thermal-compositional formulation and Operator-Based Linearization (OBL) which makes it possible to adjust terms of the PDE and simulate various phsyics (Khait and Voskov 2017). OBL identifies state (i.e. pressure, composition, temperature) dependent operators in the conservation equations and tabulates these over the parameter space of the problem. During simulation operators and derivatives are evaluated for each control volume with an interpolator. This linearization approach is robust and highly fliexible, as it allows for a control on accuracy and performance.

The comparison problem (11b) was executed and numerically converged at a high resolution of 604,800 grid cells (dx and dz equal to 5m and 3.3m), with a structured mesh, two-point flux approximation and variable time step. A hybrid fugacity-activity equation of state was used while phase properties are evaluated with the thermodynamic library DARTS-flash and validated against the NIST library (Wapperom et al., 2024). Velocity is reconstructed using a least-squares solution of fluxes across all cell interfaces (Tripuraneni et al., 2023) and subsequently explicitly incorporated into the numerical approximation of dispersion.

Computationally expensive parts of open-DARTS are written in C++ with OpenMP and GPU parallelization while open-DARTS uses a Python interface and is installed as a Python module. The linear equations were solved using an iterative GMRES solver with a CPR preconditioner. The submitted results were deployed on a NVIDIA A100 GPU with a final runtime of 11 hours. For all DARTS related codes and a SPE11b Jupyter notebook please refer to the open-DARTS repository: [open-darts](https://gitlab.com/open-darts/darts-models).

## Acknowledgements

### People

Additional contributions to the open-DARTS SPE11 submissions by: John Sass (Equinor ASA), Aleks Novikov, Michiel Wapperom, Ilshat Saifullin (Delft University of Technology).
