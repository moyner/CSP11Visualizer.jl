using CSP11Visualizer, CairoMakie # hide
results = CSP11Visualizer.parse_all_sparse(verbose=false, case = "c"); # hide

import CSP11Visualizer: plot_sparse # hide
# ![image](../assets/caseb.png)
myplot(k; kwarg...) = plot_sparse(results, k; kwarg...) # hide
# ## Pressure in observation points
# ## Pressure observation points
# ### Pressure observation point 1
myplot(:P1) # hide
# ### Pressure observation point 2
myplot(:P2) # hide
# ## Mobile CO₂

# ### Mobile CO₂ in region A
myplot(:mobA) # hide
# ### Mobile CO₂ in region B
myplot(:mobB) # hide

# ## Dissolved CO₂
# ### Dissolved CO₂ in region A
myplot(:dissA) # hide

# ### Dissolved CO₂ in region B
myplot(:dissB) # hide

# ## Immobile CO₂

# ### Immobile CO₂ in region A
myplot(:immA) # hide
# ### Immobile CO₂ in region B
myplot(:immB) # hide

# ## CO₂ in seal

# ### CO₂ in seal in region A
myplot(:sealA) # hide

# ### CO₂ in seal in region B
myplot(:sealB) # hide

# ## CO₂ in bound
# ### CO₂ in bound in total
myplot(:boundTot, ymax = 1.6e9) # hide

# ## CO₂ in seal
myplot(:sealTot) # hide
##
myplot(:sealTot, ymax = 1.8e9) # hide
