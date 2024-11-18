using CSP11Visualizer, Gadfly # hide
results = CSP11Visualizer.parse_all_sparse(); # hide
# ## Pressure in observation points
set_default_plot_size(30cm, 20cm) # hide
function myplot(k; xlabel = "Time (years)", ylabel = "$k", title = "")
    Gadfly.plot(results, x=:time, y=k, Geom.line, color = :groupresult,
    Guide.xlabel(xlabel), Guide.ylabel(ylabel), Guide.title(title)
    )
end; # hide
# ## Pressure observation points
# ### Pressure observation point 1
# We can say something nice about this point.
myplot(:P1, ylabel = "Pascal", title = "Pressure at P1") # hide
# ### Pressure observation point 2
# We can say something nice about this point, too.
myplot(:P2, ylabel = "Pascal", title = "Pressure at P2") # hide
# ## Mobile CO₂

# ### Mobile CO₂ in region A
myplot(:mobA, ylabel = "kg", title = "Mobile CO2 in region A") # hide
# ### Mobile CO₂ in region B
myplot(:mobB, ylabel = "kg", title = "Mobile CO2 in region A") # hide

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
myplot(:boundTot) # hide

# ## CO₂ in seal
myplot(:sealTot) # hide
