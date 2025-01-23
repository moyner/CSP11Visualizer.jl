groupname = "opm"
resultid = 1
using CSP11Visualizer, GLMakie, CairoMakie # hide
CairoMakie.activate!() # hide
steps = 0:5:50
steps = 0:5:1000
steps = [0, 1, 3, 5, 10, 20, 50, 120]
steps = [5, 120]
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, "a", steps = steps); # hide
end_of_injection = findfirst(isequal(5), steps) # hide
@assert !isnothing(end_of_injection) # hide
end_of_migration = findfirst(isequal(120), steps) # hide
@assert !isnothing(end_of_migration) # hide
# ## Pressure

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :pw, "Pressure (Pascal)") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :pw, "Pressure (Pascal)") # hide

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

# ## Total mass of CO₂

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :co2mass, "Total mass of CO₂ (kg)") # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :co2mass, "Total mass of CO₂ (kg)") # hide
