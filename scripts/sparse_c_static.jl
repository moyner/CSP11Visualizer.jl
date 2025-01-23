using CSP11Visualizer, CairoMakie # hide
results = CSP11Visualizer.parse_all_sparse(verbose=false, case = "c"); # hide

import CSP11Visualizer: plot_sparse # hide
# ![image](../assets/caseb.png)
plot_sparse(results, k; kwarg...) = plot_sparse(results, k; kwarg...) # hide
# ## Pressure in observation points
# ## Pressure observation points
# ### Pressure observation point 1
plot_sparse(results, :P1) # hide
# ### Pressure observation point 2
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

# ## CO₂ in bound
# ### CO₂ in bound in total
plot_sparse(results, :boundTot, ymax = 1.6e9) # hide

# ## CO₂ in seal
plot_sparse(results, :sealTot) # hide
##
plot_sparse(results, :sealTot, ymax = 1.8e9) # hide
