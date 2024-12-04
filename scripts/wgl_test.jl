groupname = "sintef"
resultid = 4
using CSP11Visualizer, WGLMakie
steps = [0, 10, 30, 50, 100, 200, 500, 1000]
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, steps = steps); # hide
##


##
WGLMakie.activate!()
CSP11Visualizer.plot_snapshot(results[end], :X_co2, "CO₂ mass fraction in liquid") # hide
##
results_c = CSP11Visualizer.parse_dense_timesteps(groupname, 1, "c", steps = [1000]); # hide

##
error()
using WGLMakie.Observables

App() do session::Session
    n = 10
    index_slider = Slider(1:n)
    volume = rand(n, n, n)
    slice = map(index_slider) do idx
        return volume[:, :, idx]
    end
    fig = Figure()
    ax, cplot = contour(fig[1, 1], volume)
    rectplot = linesegments!(ax, Rect(-1, -1, 12, 12), linewidth=2, color=:red)
    on(index_slider) do idx
        translate!(rectplot, 0,0,idx)
    end
    heatmap(fig[1, 2], slice)
    slider = DOM.div("z-index: ", index_slider, index_slider.value)
    return Bonito.record_states(session, DOM.div(slider, fig))
end
