# OPM 4
# GEOS2
# OpenGoSim 2
# SINTEF 3
# OPM 1


group = "geos"
result = 2

# group = "opengosim"
# result = 2

# group = "sintef"
# result = 3

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
cname = :default
# cname = :oxy
# cname = :phase
# cname = :thermal
# cname = :berlin
# cname = :brg
# cname = :seaborn_flare_gradient
# cname = :seaborn_mako_gradient
# cname = :seaborn_crest_gradient
d = vec(r["X_co2"])
cmap = CSP11Visualizer.default_colormap(cname, alpha = true, arange = (0, 1.0), k = 3)
fig = Figure(size = (1200, 800), fontsize = 18)
ax = Axis3(fig[1, 1], aspect = (8.4, 5, 3*1.2))
cr = (0, 0.075)
cr = (0, 0.06)
plt = plot_cell_data!(ax, mesh, d,
    colormap = cmap,
    shading = NoShading,
    transparency = true,
    colorrange = cr
)

cticks = map(i -> round(i, digits = 2), range(cr..., 10))
ax.azimuth[] = 4.25
ax.elevation[] = 0.153
# lines!(ax, w1, color = :red)
# lines!(ax, w2, color = :blue)
ax.xlabel[] = ""
ax.ylabel[] = ""
ax.zlabel[] = ""
hidedecorations!(ax)
fig
# save("csp11_co2_$(group)_$(result).png", fig)
# fig
##
fig = Figure(fontsize=30)
Colorbar(fig[1, 1],
    colorrange = cr,
    colormap = CSP11Visualizer.default_colormap(cname, ),
    vertical = true,
    ticks = cticks
)
# save("csp11_co2_colorbar.png", fig)
fig
##
CSP11Visualizer.plot_transparent_casec(r, "X_co2")
##


error()
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

##
for cname in [
        :default,
        :oxy,
        :phase,
        :thermal,
        :berlin,
        :brg,
        :curl,
        :managua,
        :matter,
        :vik,
        :algae,
        :roma,
        :linear_kryw_0_100_c71_n256,
        :oslo,
        :linear_bgy_10_95_c74_n256,
        :deep,
        :inferno,
        :gnuplot,
        :ocean,
        :seismic,
        :rainbow1,
        :turbo,
        :cyclic_mrybm_35_75_c68_n256,
        :linear_bmy_10_95_c71_n256,
        :seaborn_flare_gradient,
        :seaborn_mako_gradient,
        :seaborn_crest_gradient,
        :rainbow_bgyrm_35_85_c71_n256
    ]
    d = vec(r["X_co2"])
    cmap = CSP11Visualizer.default_colormap(cname, alpha = true, arange = (0, 0.5))
    fig = Figure(size = (1200, 800))
    ax = Axis3(fig[1, 1], aspect = (8.4, 5, 3*1.2))
    cr = (0, 0.075)
    plt = plot_cell_data!(ax, mesh, d,
        colormap = cmap,
        shading = NoShading,
        transparency = true,
        colorrange = cr
    )
    Colorbar(fig[1, 2], colorrange = cr, colormap = CSP11Visualizer.default_colormap(cname, ))
    ax.azimuth[] = 4.25
    ax.elevation[] = 0.153
    lines!(ax, w1, color = :red)
    lines!(ax, w2, color = :blue)
    fig
    save("csp11_co2_$(group)_$(result)_$cname.png", fig)
end
##
using GLMakie, CSP11Visualizer, CSP11Visualizer.Jutul
GLMakie.activate!()
group = "opm"
result = 4
data = CSP11Visualizer.parse_dense_timesteps(group, result, "c");
##
sparse_results = CSP11Visualizer.parse_all_sparse(case = "c") # hide
##
GC.gc()



##


CSP11Visualizer.make_movie_casec(data, sparse_results,
    filename = "test_c.mp4",
    group = group,
    resultid = result
)
##
geos_2 = only(CSP11Visualizer.parse_dense_timesteps("geos", 2, "c", steps = [1000]));
opengosim_2 = only(CSP11Visualizer.parse_dense_timesteps("opengosim", 2, "c", steps = [1000]));
sintef_3 = only(CSP11Visualizer.parse_dense_timesteps("sintef", 3, "c", steps = [1000]));
# opm_1 = only(CSP11Visualizer.parse_dense_timesteps("opm", 1, "c", steps = [1000]));
opm_4 = only(CSP11Visualizer.parse_dense_timesteps("opm", 4, "c", steps = [1000]));

# SINTEF3, OPM4
# GEOS2, OpenGoSim2
##
pfig = with_theme(theme_latexfonts()) do
    fig = Figure(size = (2000, 1300), fontsize = 35)
    CSP11Visualizer.plot_transparent_casec!(fig[1, 1], sintef_3, "X_co2", title = "SINTEF 3")
    CSP11Visualizer.plot_transparent_casec!(fig[1, 2], opm_4, "X_co2", title = "OPM 4")
    CSP11Visualizer.plot_transparent_casec!(fig[2, 1], geos_2, "X_co2", title = "GEOS 2")
    CSP11Visualizer.plot_transparent_casec!(fig[2, 2], opengosim_2, "X_co2", title = "OpenGoSim 2")

    cr = (0, 0.06)
    cticks = map(i -> round(i, digits = 2), range(cr..., 10))

    Colorbar(fig[1:2, 3],
        colorrange = cr,
        colormap = CSP11Visualizer.default_colormap(:default, ),
        vertical = true,
        size = 50,
        ticks = cticks
    )
    fig
end
# save("csp11c_co2_mass_fraction_comparison.png", pfig)