# UT-CSEE

Main contributors: Bruno R. B. Fernandes (UT Austin), Prasanna Krishnamurthy (ExxonMobil)

The UT-CSEE-PGE group used two commercial reservoir simulator software: SLB Intersect (IX version 2023.1) and CMG GEM (version 2023.30). The commercial tool SLB PETREL (version 2023) was also used to generate the simulation decks for SLB IX.

Both simulators consider the traditional five-point stencil with upstream weighting for all SPE 11 benchmark cases. We used a Cartesian grid for Cases A and B whereas a corner-point grid geometry was used in Case C. A Fully Implicit method with the traditional Newton’s method was used for all simulations with Intersect and GEM.

The SLB-PETREL was used to generate the Cartesian grids and properties used in Intersect. A code was written to generate a Corner-Point grid for Case C and was read in PETREL. PETREL was also used to define the boundary conditions through boundary wells (Case A), or pore volume multipliers. PETREL was also used to generate different grid refinement levels; however, we submitted only one grid result per benchmark case.

In IX, Cases B and C considered the thermal model with all the physics required by the problem description, but the aqueous phase density was computed with the Ezhorki equation. CO2 enthalpy was provided in a table format and the phase equilibria were calculated with K-value tables for various pressures and temperatures. The CO2 gas phase density was computed with the Peng-Robinson Equation of State (1978). Three different fluid models were considered for Case A using IX. The first result considered the solubility of CO2 in the aqueous phase using solubility tables and water vaporization was neglected. For the second result, the molecular diffusion and physical dispersion were disabled to observe the impact of these mechanisms. Finally, the third result that was submitted considered the Black-Oil model. While the Black-Oil model was quite efficient computationally, molecular diffusion and physical dispersion were not modeled. All runs performed with IX used an FGMRES solver with a Quasi-IMPES CPR (ILU+AMG) preconditioner. Results for CMG GEM were submitted only for Case B. The Peng-Robinson equation of state (1978) was considered for computing gas phase density and enthalpy. The phase equilibrium was fully based on K-values. The fluid properties and component parameters were calibrated using the CMG WINPROP. Physical dispersion was not considered with CMG GEM. A GMRES solver with an ILU preconditioner was considered for this simulator. Standard well models were used to represent the sources in both CMG-GEM and SLB-IX.

## Acknowledgements

### People

Additional contributions to the SLB SPE11 submissions by: Mojdeh Delshad, Marcos V. B. Machado, Kamy Sepehrnoori, Lisa S. Lun
