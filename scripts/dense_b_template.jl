# # Case B: HEADER
groupname = "sintef" # hide
groupname = "opm"
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
# The total mass of CO₂ in kilograms per cell is shown below. This is the
# absolute mass of CO₂ and indicates where the CO₂ is located in the domain.
# #### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :co2mass) # hide
# #### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :co2mass) # hide

# ### Pressure
# The reported pressure in Pascal is shown below. This is the pressure of the
# water phase.
# #### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :pw,) # hide
# #### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :pw) # hide


# ### Temperature

# #### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :T) # hide
# #### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :T) # hide

# ## Additional reporting variables

# ## Gas saturation

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :sg) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :sg) # hide

# ## CO₂ mass fraction in liquid

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :X_co2) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :X_co2) # hide

# ## H₂O mass fraction in vapor

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :Y_h2o) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :Y_h2o) # hide

# ## Gas density

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :deng) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :deng) # hide

# ## Water density

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :denw) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :denw) # hide
