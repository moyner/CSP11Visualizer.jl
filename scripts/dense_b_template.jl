# # HEADER for case B
groupname = "sintef" # hide
resultid = 1 # hide
using CSP11Visualizer, GLMakie, CairoMakie # hide
CairoMakie.activate!() # hide
steps = 0:5:50 # hide
steps = 0:5:1000 # hide
steps = [0, 10, 30, 50, 100, 200, 500, 1000] # hide
steps = [50, 1000] # hide
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, steps = steps, verbose = false); # hide
end_of_injection = findfirst(isequal(50), steps) # hide
@assert !isnothing(end_of_injection) # hide
end_of_migration = findfirst(isequal(1000), steps) # hide
@assert !isnothing(end_of_migration); # hide
# ## Thermodynamic state variables
# ### Total mass of CO₂

# #### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :co2mass, "Total mass of CO₂ (kg)") # hide
# #### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :co2mass, "Total mass of CO₂ (kg)") # hide

# ### Pressure

# #### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :pw, "Pressure (Pascal)") # hide
# #### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :pw, "Pressure (Pascal)") # hide


# ### Temperature

# #### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :T, "Temperature (°C)") # hide
# #### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :T, "Temperature (°C)") # hide

# ## Additional reporting variables

# ## Gas saturation

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :deng, "Gas saturation") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :deng, "Gas saturation") # hide

# ## CO₂ mass fraction in liquid

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :X_co2, "CO₂ mass fraction in liquid") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :X_co2, "CO₂ mass fraction in liquid") # hide

# ## H₂O mass fraction in vapor

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :Y_h2o, "H₂O mass fraction in vapor") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :Y_h2o, "H₂O mass fraction in vapor") # hide

# ## Gas density

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :deng, "Gas density (kg/m³)") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :deng, "Gas density (kg/m³)") # hide

# ## Water density

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :denw, "Water density (kg/m³)") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :denw, "Water density (kg/m³)") # hide
