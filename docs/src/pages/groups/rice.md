# Rice

Main contributors: Jakub Solovský and Abbas Firoozabadi

The simulations are performed using the research code Higher-Order Reservoir Simulations Engine (HORSE) advanced for dynamic adaptive gridding1.  The key features of the numerical scheme are:

Fully unstructured grids in 2D and 3D.

Flow equation formulation using the total volume balance and employing capillary potentials [2].

Discretization of the pressure equation by the mixed-hybrid finite element method [2].

Discretization of transport equations by the discontinuous Galerkin (dG) method with a slope limiter [2].

Two-phase behavior description, compressibility, and density computations by the cubic-plus association equation of state (CPA).

The algorithm is fully compositional, and the dynamic adaptive gridding is used for both the mixed-hybrid finite element and discontinuous Galerkin discretizations. The criterion for dynamic refinement is based on gradient of composition of carbon dioxide1. Problem 11B is selected with  the isothermal assumption. The non-isothermal formulation and discretization is advanced recently [3].

Two sets of results are reported: coarse triangular grid (approximately 10,000 elements) and one level of refinement (original elements are divided into four). Simulations using two- and six-level refinement are presented in Ref. 3 The six-level is for high resolution around the injection well.  Based on the extensive past work on compositional modeling, especially in gravity fingering, the dG method has much higher accuracy than the first-order finite difference discretization. The dG method may be several hundred times faster for the same resolution in composition in 2D [2] compared the first-order finite difference.

[1] Solovský,J. and  Firoozabadi, A.: “Dynamic adaptive and fully unstructured tetrahedral gridding: Application to CO2 sequestration with consideration of full fluid compressibility”J.  Computational Physics (2025) 521, 113556

[2] Hoteit, H., and Firoozabadi, A.: “Multicomponent fluid flow by discontinuous Galerkin and mixed methods in unfractured and fractured media,” Water Resources Research (2005) 41, W11412, doi: 10.1029, 1-15.

[3] Solovský,J., and Firoozabadi,A.: ” Efficient Numerical Simulation of CO2 Sequestration in Aquifers With Consideration of Thermal Effects Using The Fully Unstructured Dynamic Adaptive Gridding;, SPE-223911-  SPE Reservoir Simulation Conference , Galveston, Texas,  25–27 March 2025.

## Acknowledgments

### Funding

We thank the member companies of our research consortium for supporting this work.
