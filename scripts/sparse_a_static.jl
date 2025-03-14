# # Case A - sparse measurables
# Two-dimensional model at lab conditions
# ![image](../../assets/casea.png)
# ## Pressure in observation points
using CSP11Visualizer, CairoMakie # hide
CairoMakie.activate!() # hide
results = CSP11Visualizer.parse_all_sparse(verbose=false, case = "a"); # hide
plot_sparse(results, :P1) # hide
plot_sparse(results, :P2) # hide
# ## Mobile CO₂

# ### Mobile CO₂ in region A
plot_sparse(results, :mobA) # hide
# ### Mobile CO₂ in region B
plot_sparse(results, :mobB) # hide

# ## Dissolved CO₂
# ### Dissolved CO₂ in region A
plot_sparse(results, :dissA) # hide

# ### Dissolved CO₂ in region B
plot_sparse(results, :dissB) # hide

# ## Immobile CO₂

# ### Immobile CO₂ in region A
plot_sparse(results, :immA) # hide
# ### Immobile CO₂ in region B
plot_sparse(results, :immB) # hide

# ## CO₂ in seal

# ### CO₂ in seal in region A
plot_sparse(results, :sealA) # hide

# ### CO₂ in seal in region B
plot_sparse(results, :sealB) # hide

# ### Total CO₂ in seal
plot_sparse(results, :sealTot) # hide
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
