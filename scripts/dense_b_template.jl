# # Case B: HEADER
groupname = "sintef" # hide
resultid = 1 # hide
using CSP11Visualizer, GLMakie, CairoMakie # hide
CairoMakie.activate!() # hide
steps = 0:5:50 # hide
steps = 0:5:1000 # hide
steps = [0, 10, 30, 50, 100, 200, 500, 1000] # hide
steps = [50, 30, 100, 1000] # hide
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, steps = steps, verbose = false); # hide

after_period = findfirst(isequal(30), steps) # hide
@assert !isnothing(after_period) # hide
end_of_injection = findfirst(isequal(50), steps) # hide
@assert !isnothing(end_of_injection) # hide
after_century = findfirst(isequal(100), steps) # hide
@assert !isnothing(after_century) # hide
end_of_migration = findfirst(isequal(1000), steps) # hide
@assert !isnothing(end_of_migration); # hide
# ## Thermodynamic state variables
# ### Total mass of CO₂
# The total mass of CO₂ in kilograms per cell is shown below. This is the
# absolute mass of CO₂ and indicates where the CO₂ is located in the domain.
# #### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :co2mass) # hide
# ### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :co2mass) # hide
# #### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :co2mass) # hide
# #### 1000 years: End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :co2mass) # hide

# ### Pressure
# The reported pressure in Pascal is shown below. This is the pressure of the
# water phase.
# #### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :pw,) # hide
# #### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :pw) # hide
# #### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :pw) # hide
# #### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :pw) # hide

# ### Temperature

# #### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :T) # hide
# #### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :T) # hide
# #### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :T) # hide
# #### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :T) # hide

# ## Additional reporting variables

# ## Gas saturation

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :sg) # hide
# ### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :sg) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :sg) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :sg) # hide

# ## CO₂ mass fraction in liquid

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :X_co2) # hide
# ### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :X_co2) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :X_co2) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :X_co2) # hide

# ## H₂O mass fraction in vapor

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :Y_h2o) # hide
# ### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :Y_h2o) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :Y_h2o) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :Y_h2o) # hide

# ## Gas density

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :deng) # hide
# ### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :deng) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :deng) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :deng) # hide

# ## Water density

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :denw) # hide
# ### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :denw) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :denw) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :denw) # hide
