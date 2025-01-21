groupname = "sintef"
resultid = 4
using CSP11Visualizer, WGLMakie#, GLMakie
using Observables, Bonito

steps = [0, 10, 30, 50, 100, 200, 500, 1000]
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, "b", steps = steps); # hide

Page(exportable=true, offline=true)
WGLMakie.activate!()
Makie.inline!(true)

X = vec(results[end]["x"])
Z = vec(results[end]["z"])


App() do session::Session
    nres = length(results)
    index_slider = Bonito.Slider(1:nres)
    I = Observable(1)

    on(index_slider) do idx
        I[] = idx
    end
    fig = Figure()
    slice = @lift vec(results[$I]["X_co2"])

    ax, cplot = heatmap(fig[1, 1], X, Z, slice)
    slider = DOM.div("Slice position: ", index_slider, index_slider.value)
    return Bonito.record_states(session, DOM.div(slider, fig))
end

