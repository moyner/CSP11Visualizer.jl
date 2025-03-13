# Calgary

Main contributors: Chaojie Di (Calgary), Zhangxing Chen (Calgary)

RSG-UCalgary used their PRSI-CGCS Version 1.0 (Parallel Reservoir Simulator Infrastructure-Compositional Geological CO2 Storage) simulator to generate the submitted results. This simulator is a non-isothermal parallel compositional reservoir simulator for large-scale geological CO2 storage (Di et al. 2024).  The finite difference (volume) method is applied to discretize the multiphase flow equations, and efficient nonlinear and linear solvers are used to solve the discretized equations.

In the SPE11 cases, the gas solubility and the properties of the water and CO2-rich phases are obtained through linear interpolation of precalculated tables. The temperature and pressure intervals of these tables are set to 1°C and 1 bar for SPE11B&C and 0.01 bar for SPE11A to ensure the accuracy of linear interpolation. Pressure, saturation and composition were solved implicitly, while temperature in the SPE11B and SPE11C cases was solved explicitly. Only thermal conduction and convection are considered in this model, since they are primary heat transfer mechanisms within an underground formation. The effects of thermal radiation and mechanical work are minimal and thus neglected. SPE11A and SPE11B used a uniform Cartesian grid model and SPE11C used a corner-point grid model which was derived from the SPE11A grid model (provided by the organizer). Apart from SPE11A, all other cases consider the effects of diffusion and dispersion. In SPE11C, the injection well stays within the same grid layer, indicating that the well trajectory is not a straight line but rather a curve, like the Y-directional extension of the model top.

## Acknowledgements

### Funding

Partly supported by NSERC (Natural Science and Engineering Research Council)/Energi Simulation and Alberta Innovates Chairs; Funding number: 365863-17.

### People

Additional contributions to the RSC-UCalgary SPE11 submissions by: Yizheng Wei, Kun Wang, Hui Liu and Lihua Shen from the University of Calgary.
