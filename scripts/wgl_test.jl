groupname = "sintef"
resultid = 4
using CSP11Visualizer, WGLMakie, GLMakie
using Observables, Bonito

steps = [0, 10, 30, 50, 100, 200, 500, 1000]
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, steps = steps); # hide
X = vec(results[end]["x"])
Z = vec(results[end]["z"])
# ## Plot a single snapshot
WGLMakie.activate!()
CSP11Visualizer.plot_snapshot(results[end], :X_co2, "CO₂ mass fraction in liquid") # hide
# ##
Page()
heatmap(X, Z, results[end]["X_co2"])
# ## Plot timesteps
Page()
App() do session::Session
    index_slider = Bonito.Slider(1:length(results))
    slice = map(index_slider) do idx
        return vec(results[idx]["X_co2"])
    end
    fig = Figure()
    ax, cplot = heatmap(fig[1, 1], X, Z, slice)
    slider = DOM.div("Slice position: ", index_slider, index_slider.value)
    return Bonito.record_states(session, DOM.div(slider, fig))
end
# # Parse case C
results_c = CSP11Visualizer.parse_dense_timesteps(groupname, 1, "c", steps = [1000]); # hide
# ## Volume plot of CO2
x = results_c[end]["X_co2"]
Page()
volume(x)
# ## Contour plot of CO2
Page()
contour(x)
# ## 3D plot with slicing
Page()
App() do session::Session
    nx, ny, nz = size(x)
    index_slider = Bonito.Slider(1:nx)
    slice = map(index_slider) do idx
        return x[idx, :, :]
    end
    fig = Figure()
    ax, cplot = contour(fig[1, 1], x)
    rectplot = linesegments!(ax, Rect(-1, -1, -1, -1, ny, nz), linewidth=2, color=:red)
    on(index_slider) do idx
        translate!(rectplot, idx, 0,0)
    end
    heatmap(fig[1, 2], slice)
    slider = DOM.div("Slice position: ", index_slider, index_slider.value)
    return Bonito.record_states(session, DOM.div(slider, fig))
end
##
GLMakie.activate!()
