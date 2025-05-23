# # Case B: HEADER
# INSERT_GROUPLINK
groupname = "opm" # hide
resultid = 1 # hide
using CSP11Visualizer, GLMakie, CairoMakie # hide
CairoMakie.activate!() # hide
steps = [30, 50, 100, 1000] # hide
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, steps = steps, verbose = false); # hide
after_period = findfirst(isequal(30), steps) # hide
@assert !isnothing(after_period) # hide
end_of_injection = findfirst(isequal(50), steps) # hide
@assert !isnothing(end_of_injection) # hide
after_century = findfirst(isequal(100), steps) # hide
@assert !isnothing(after_century) # hide
end_of_migration = findfirst(isequal(1000), steps) # hide
@assert !isnothing(end_of_migration); # hide
# ## Overview animation
# The animation below shows the migration of CO₂ in the domain over time,
# plotted as the mass fraction of CO₂ in the liquid phase. The animation starts
# at the initial state and ends at the end of the migration period. We also plot
# the amount of dissolved CO₂ in the liquid phase in the two reporting boxes A
# and B, as well as the mobile CO₂ in the gas phase. Note that the playback
# speed is slower during injection than during migration.

# INSERT_MOVIE_B

# ## CO₂ mass fraction in liquid
# The mass fraction of CO₂ in the liquid phase is shown below.
# ### 30 years: 5 years after start of second injector
CSP11Visualizer.plot_snapshot(results[after_period], :X_co2) # hide
# ### 50 years: End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :X_co2) # hide
# ### 100 years
CSP11Visualizer.plot_snapshot(results[after_century], :X_co2) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :X_co2) # hide

# ## Gas saturation
# The free gas volume fraction in the porous medium.
# ### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :sg) # hide
# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :sg) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :sg) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :sg) # hide

# ## Water density
# The water density depends on the pressure, temperature and the amount of CO₂
# that has been dissolved in the water phase
# ### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :denw) # hide
# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :denw) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :denw) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :denw) # hide

# ## Thermodynamic state variables
# ### Total mass of CO₂
# The total mass of CO₂ in kilograms per cell is shown below. This is the
# absolute mass of CO₂ and indicates where the CO₂ is located in the domain.
# ### 30 years
CSP11Visualizer.plot_snapshot(results[after_period], :co2mass) # hide
# #### 50 years: End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :co2mass) # hide
# #### 100 years
CSP11Visualizer.plot_snapshot(results[after_century], :co2mass) # hide
# #### 1000 years: End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :co2mass) # hide

# ### Pressure
# The reported pressure in Pascal is shown below. This is the pressure of the
# water phase.
# #### 30 years
CSP11Visualizer.plot_snapshot(results[after_period], :pw) # hide
# #### 50 years: End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :pw,) # hide
# #### 100 years
CSP11Visualizer.plot_snapshot(results[after_century], :pw) # hide
# #### 1000 years: End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :pw) # hide

# ### Temperature
# The reported temperature in degrees Celsius is shown below.
# #### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :T) # hide
# #### 50 years: End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :T) # hide
# #### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :T) # hide
# #### 1000 years: End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :T) # hide

# ## H₂O mass fraction in vapor
# A small amount of H₂O can vaporize into the gas phase. The mass fraction of H₂O
# in the gas phase is shown below.
# ### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :Y_h2o) # hide
# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :Y_h2o) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :Y_h2o) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :Y_h2o) # hide

# ## Gas density
# The gas density depends only on pressure and temperature in this model.
# ### 30 years:
CSP11Visualizer.plot_snapshot(results[after_period], :deng) # hide
# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :deng) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot(results[after_century], :deng) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :deng) # hide
#
function clear_module!(M::Module)        # hide
    for name ∈ names(M, all=true)        # hide
        if !isconst(M, name)             # hide
            @eval M $name = $nothing     # hide
        end                              # hide
    end                                  # hide
end                                      # hide
clear_module!(@__MODULE__)               # hide
GC.gc();                                 # hide
