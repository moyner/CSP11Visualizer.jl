# # Case B: HEADER
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
CSP11Visualizer.plot_snapshot(results[end_of_injection], :pw) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :pw) # hide

# ## Gas saturation

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :deng) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :deng) # hide

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

# ## Total mass of CO₂

# ### End of injection
CSP11Visualizer.plot_snapshot(results[end_of_injection], :co2mass) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot(results[end_of_migration], :co2mass) # hide
##
function clear_module!(M::Module)        # hide
    for name ∈ names(M, all=true)        # hide
        if !isconst(M, name)             # hide
            @eval M $name = $nothing     # hide
        end                              # hide
    end                                  # hide
end                                      # hide
clear_module!(@__MODULE__)               # hide
GC.gc();                                 # hide
