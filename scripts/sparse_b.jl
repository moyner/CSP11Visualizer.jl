using CSP11Visualizer, Gadfly # hide
results = CSP11Visualizer.parse_all_sparse(verbose=false); # hide

# ![image](../assets/caseb.png)

# ## Pressure in observation points
set_default_plot_size(30cm, 20cm) # hide
function plot_sparse(results, k; xlabel = "Time (years)", ylabel = "$k", title = "")
    Gadfly.with_theme(:default) do
        Gadfly.plot(results, x=:time, y=k, Geom.line,
            color = :group,
            linestyle = :result,
            Guide.xlabel(xlabel),
            Guide.ylabel(ylabel),
            Guide.title(title)
        )
    end
end; # hide
# ## Pressure observation points
# ### Pressure observation point 1
# We can say something nice about this point.
plot_sparse(results, :P1, ylabel = "Pascal", title = "Pressure at P1") # hide
# ### Pressure observation point 2
# We can say something nice about this point, too. We can also do some unrelated math to appear fancy:
# The Brooks-Corey model is a simple model that can be used to generate relative
# permeabilities. The model is defined in the mobile region as:
#
# ``k_{rw} = k_{max,w} \bar{S}_w``
#
# ``k_{ro} = k_{max,o} \bar{S}_o``
#
# where $k_{max,w}$ is the maximum relative permeability, $\bar{S}_w$
# is the normalized saturation for the water phase,
#
# `` \bar{S}_w = \frac{S_w - S_{wi}}{1 - S_{wi} - S_{ro}}``
#
# and, similarly, for the oil phase:
# 
# ``\bar{S}_o = \frac{S_o - S_{ro}}{1 - S_{wi} - S_{ro}}``

plot_sparse(results, :P2, ylabel = "Pascal", title = "Pressure at P2") # hide
# ## Mobile CO₂

# ### Mobile CO₂ in region A
plot_sparse(results, :mobA, ylabel = "kg", title = "Mobile CO2 in region A") # hide
# ### Mobile CO₂ in region B
plot_sparse(results, :mobB, ylabel = "kg", title = "Mobile CO2 in region A") # hide

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
plot_sparse(results, :boundTot) # hide

# ## CO₂ in seal
plot_sparse(results, :sealTot) # hide
