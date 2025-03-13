# SINTEF

Main contributors: Olav Møyner

The SINTEF group used two of its open-source software packages to produce the submitted results: MRST (mrst.no) and JutulDarcy (github.com/sintefmath/JutulDarcy.jl ). 

MRST was used to mesh the facies model as a partially unstructured cut-cell type grid that accurately represents the given geometry while still retaining a Cartesian background grid in regions where the rock is uniform.

The MRST meshes were used in JutulDarcy for simulations. JutulDarcy is a general high-performance automatic differentiation reservoir simulator that has support for non-isothermal compositional flow and consistent spatial discretization schemes. A two-component table (in p, T) was used to describe pure densities, viscosities, and K-values. Standard fully-implicit schemes with dynamic timestepping were used. Custom functions for CO2-brine mixing density were implemented. In particular, SINTEF used the NIST tables for injection enthalpy of CO2 at well-cell conditions while using the tabulated component heat capacities together with mass fractions pressure and density to calculate mixture enthalpy in the reservoir. This inconsistency resulted in negative temperatures in degrees Celsius close to the well. The property tables were not extrapolated into negative temperatures. Uniform tabular grid spacing and explicit solutions for two-component Rachford–Rice were used to minimize the cost of property evaluations.

The SINTEF team worked in close collaboration with the OPM team, with two members contributing to both teams. Given that the same research group from SINTEF is a key developer of OPM Flow and the main developer of JutulDarcy, there is significant overlap in the development of these simulators. As a result, the SINTEF team chose a different focus than the OPM team, investigating the use of facies-adapted meshes and a consistent discretization scheme (AvgMPFA, instead of the standard and potentially inconsistent TPFA scheme) rather than prioritizing a high number of grid cells. Differences are observed, even for our cut-cell meshes that should in principle minimize grid orientation effects.

## Acknowledgements

### People

Additional contributions to the SINTEF SPE11 submissions by: Kristian Holme, Knut-Andreas Lie, Halvor Nilsen, Odd Andersen from Sintef Digital.