# # Case A: HEADER
# INSERT_GROUPLINK
groupname = "opm" # hide
resultid = 1 # hide
using CSP11Visualizer, GLMakie, CairoMakie # hide
CairoMakie.activate!() # hide
steps = [5, 60, 120] # hide
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, "a", steps = steps, verbose = false); # hide
end_of_injection = findfirst(isequal(5), steps) # hide
@assert !isnothing(end_of_injection) # hide
midway = findfirst(isequal(60), steps) # hide
@assert !isnothing(midway) # hide
end_of_migration = findfirst(isequal(120), steps) # hide
@assert !isnothing(end_of_migration) # hide
# ## Overview animation
# The animation below shows the migration of CO₂ in the domain over time,
# plotted as the mass fraction of CO₂ in the liquid phase. The animation starts
# at the initial state and ends at the end of the migration period. We also plot
# the amount of dissolved CO₂ in the liquid phase in the two reporting boxes A
# and B, as well as the mobile CO₂ in the gas phase. Note that the playback
# speed is slower during injection than during migration.

# INSERT_MOVIE_A

# ## Pressure

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :pw) # hide
# ### Midway
CSP11Visualizer.plot_snapshot(results[midway], :pw) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :pw) # hide

# ## Gas saturation

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :deng) # hide
# ### Midway
CSP11Visualizer.plot_snapshot(results[midway], :deng) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :deng) # hide

# ## CO₂ mass fraction in liquid

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :X_co2) # hide
# ### Midway
CSP11Visualizer.plot_snapshot(results[midway], :X_co2) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :X_co2) # hide

# ## H₂O mass fraction in vapor

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :Y_h2o) # hide
# ### Midway
CSP11Visualizer.plot_snapshot(results[midway], :Y_h2o) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :Y_h2o) # hide

# ## Gas density

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :deng) # hide
# ### Midway
CSP11Visualizer.plot_snapshot(results[midway], :deng) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :deng) # hide

# ## Water density

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :denw) # hide
# ### Midway
CSP11Visualizer.plot_snapshot(results[midway], :denw) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :denw) # hide

# ## Total mass of CO₂

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :co2mass) # hide
# ### Midway
CSP11Visualizer.plot_snapshot(results[midway], :co2mass) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :co2mass) # hide
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
