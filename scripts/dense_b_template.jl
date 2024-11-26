groupname = "sintef"
resultid = 1
using CSP11Visualizer, GLMakie # hide
steps = 0:5:50
steps = 0:5:1000
steps = [0, 10, 30, 50, 100, 200, 500, 1000]
steps = [50, 1000]
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, steps = steps); # hide
end_of_injection = findfirst(isequal(50), steps)
@assert !isnothing(end_of_injection)
end_of_migration = findfirst(isequal(1000), steps)
@assert !isnothing(end_of_migration)
# ## Pressure

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], "pressure_Pa", "Pressure (Pascal)") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], "pressure_Pa", "Pressure (Pascal)") # hide

# ## Gas saturation

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], "gas_saturation", "Gas saturation") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], "gas_saturation", "Gas saturation") # hide

# ## CO₂ mass fraction in liquid

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], "mass_fraction_of_CO2_in_liquid", "CO₂ mass fraction in liquid") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], "mass_fraction_of_CO2_in_liquid", "CO₂ mass fraction in liquid") # hide

# ## H₂O mass fraction in vapor

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], "mass_fraction_of_H20_in_vapor", "H₂O mass fraction in vapor") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], "mass_fraction_of_H20_in_vapor", "H₂O mass fraction in vapor") # hide

# ## Gas density

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], "phase_mass_density_gas_kg_m3", "Gas density (kg/m³)") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], "phase_mass_density_gas_kg_m3", "Gas density (kg/m³)") # hide

# ## Water density

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], "phase_mass_density_water_kg_m3", "Water density (kg/m³)") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], "phase_mass_density_water_kg_m3", "Water density (kg/m³)") # hide

# ## Total mass of CO₂

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], "total_mass_CO2_kg", "Total mass of CO₂ (kg)") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], "total_mass_CO2_kg", "Total mass of CO₂ (kg)") # hide
# ## Temperature

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], "temperature_C", "Temperature (°C)") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], "temperature_C", "Temperature (°C)") # hide
