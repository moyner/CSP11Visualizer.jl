# OPM 4
# GEOS2
# OpenGoSim 2
# SINTEF 3
# OPM 1


group = "geos"
result = 2

group = "opengosim"
result = 2

group = "sintef"
result = 3

group = "opm"
result = 1

group = "opm"
result = 4


data = CSP11Visualizer.parse_dense_timesteps(group, result, "c", steps = [1000]);
r = only(data)

##
using GLMakie
GLMakie.activate!()

mesh = CSP11Visualizer.get_mesh("c")
w1, w2 = CSP11Visualizer.get_wells("c")
using CSP11Visualizer.Jutul

# ##
# d = vec(r["denw"])
# cmap = CSP11Visualizer.default_colormap(alpha = true, k = 3)
# plot_cell_data(mesh, d,
#     colormap = cmap,
#     transparency = true
# )
# ##
# d = vec(r["co2mass"])
# cmap = CSP11Visualizer.default_colormap(alpha = true)
# fig, ax, plt = plot_cell_data(mesh, d,
#     colormap = cmap,
#     transparency = true
# )
##
d = vec(r["X_co2"])
cmap = CSP11Visualizer.default_colormap(alpha = true, arange = (0, 0.5))
fig = Figure(size = (1200, 800))
ax = Axis3(fig[1, 1], aspect = (8.4, 5, 3*1.2))
cr = (0, 0.075)
plt = plot_cell_data!(ax, mesh, d,
    colormap = cmap,
    shading = NoShading,
    transparency = true,
    colorrange = cr
)
Colorbar(fig[1, 2], colorrange = cr, colormap = CSP11Visualizer.default_colormap())
ax.azimuth[] = 4.25
ax.elevation[] = 0.153
lines!(ax, w1, color = :red)
lines!(ax, w2, color = :blue)
fig
save("csp11_co2_$(group)_$result.png", fig)
fig
##
d = copy(vec(r["X_co2"]))
cmap = CSP11Visualizer.default_colormap()
fig = Figure(size = (1200, 800))
ax = Axis3(fig[1, 1], aspect = (8.4, 5, 3*1.2))

plot_cell_data!(ax, mesh, d,
    colormap = cmap,
    shading = NoShading,
    cells = findall(d .> 0.015),
    colorrange = cr
)
ax.azimuth[] = 4.25
ax.elevation[] = 0.153
lines!(ax, w1, color = :red)
lines!(ax, w2, color = :blue)
fig