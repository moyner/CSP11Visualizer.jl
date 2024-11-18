using CSP11Visualizer, Gadfly # hide
results = CSP11Visualizer.parse_all_sparse(); # hide
# ## Pressure in observation points
set_default_plot_size(30cm, 20cm) # hide

# ### Pressure observation point 1
# We can say something nice about this point.
plot(results, x=:time, y=:P1, Geom.line, color = :groupresult) # hide
# ### Pressure observation point 2
# We can say something nice about this point, too.
plot(results, x=:time, y=:P2, Geom.line, color = :groupresult) # hide
