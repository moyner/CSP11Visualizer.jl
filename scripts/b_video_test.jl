groupname = "opm" # hide
resultid = 4 # hide
using CSP11Visualizer, GLMakie
GLMakie.activate!() # hide
steps = collect(0:5:1000)
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, steps = steps, verbose = true); # hide
##
sparse_results = CSP11Visualizer.parse_all_sparse(case = "b", active_result = resultid, active_groups = groupname)
@assert only(unique(sparse_results[:, "group"])) == groupname
@assert only(unique(sparse_results[:, "result"])) == resultid
##
# using CSP11Visualizer.Jutul
function make_movie_caseb(steps, results, sparse_results, k, t = k; filename = "sg.mp4")
    GLMakie.activate!()
    x = results[1]["x"]
    z = results[1]["z"]
    indices = Int[]
    for (i, step) in enumerate(steps)
        if step <= 100.0
            n = 5
        else
            n = 1
        end
        for j in 1:n
            push!(indices, i)
        end
    end
    fig = Figure(size = (1200, 1200))
    ax = Axis(fig[1, 1], title = t)
    ix = Observable(1)
    getresult(i) = vec(results[i][k])
    values = @lift getresult($ix)
    plt = heatmap!(ax, vec(x), vec(z), values,
        colormap = CSP11Visualizer.default_colormap()
    )
    Colorbar(fig[2, 1], plt, vertical = false)

    # Sparse plots
    ax_plt = Axis(fig[3, 1])
    t_sparse = sparse_results[:, "time"]
    mob_a = sparse_results[:, "mobA"]
    mob_b = sparse_results[:, "mobB"]

    # Sort
    sortix = sortperm(t_sparse)
    t_sparse = t_sparse[sortix]
    mob_a = mob_a[sortix]
    mob_b = mob_b[sortix]

    lines!(ax_plt, t_sparse, mob_a, color = :black)
    lines!(ax_plt, t_sparse, mob_b, color = :black)

    # I = get_1d_interpolator(t_sparse, mob_b)
    sparse_ix = Observable(1)
    t_dot = @lift t_sparse[$sparse_ix]
    mob_a_dot = @lift mob_a[$sparse_ix]
    mob_b_dot = @lift mob_b[$sparse_ix]

    scatter!(t_dot, mob_a_dot)
    scatter!(t_dot, mob_b_dot)

    framerate = 24
    record(fig, filename, indices;
        framerate = framerate) do t
        ix[] = t
        t_step = steps[t]
        mindist, minix = findmin(i -> abs(t_sparse[i] - t_step), eachindex(t_sparse))
        @info "??" t_step minix

        sparse_ix[] = minix
    end
    return filename
end

make_movie_caseb(steps, results, sparse_results, "sg", "Gas saturation") # hide
