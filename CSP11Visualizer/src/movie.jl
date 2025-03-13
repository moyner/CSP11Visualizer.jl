function make_website_movie(; case, group, resultid)
    @assert case in ["a", "b", "c"]
    steps = CSP11Visualizer.canonical_reporting_steps(case)
    println("Reading dense data...")
    results = CSP11Visualizer.parse_dense_timesteps(group, resultid, case, steps = steps, verbose = false)
    println("Reading sparse data...")
    sparse_results = CSP11Visualizer.parse_all_sparse(case = case)

    if case == "a"
        return make_movie_casea(results, sparse_results, group = group, resultid = resultid)
    elseif case == "b"
        return make_movie_caseb(results, sparse_results, group = group, resultid = resultid)
    elseif case == "c"
        return make_movie_casec(results, sparse_results, group = group, resultid = resultid)
    else
        error("Not implemented")
    end
end

function make_movie_caseb(results, sparse_results; group, resultid)
    steps = CSP11Visualizer.canonical_reporting_steps("b")

    k = "X_co2"
    clims, t, zero_to_nan = CSP11Visualizer.key_info(k, results[1]["case"])
    lw = 3

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
    ax = Axis(fig[1:2, 1], title = t)
    ix = Observable(1)
    function getresult(i)
        tmp = vec(results[i][k])
        if eltype(tmp) != Float64
            tmp = Float64.(tmp)
        end
        return tmp
    end
    values = @lift getresult($ix)
    plt = heatmap!(ax, vec(x), vec(z), values,
        colormap = CSP11Visualizer.default_colormap(),
        colorrange = clims,
    )

    color_A, color_B = colors_for_movie()

    # Box A: Bottom left (3300, 0), top right (8300, 600)
    lines!(ax, [(3300, 0), (8300, 0)], color = color_A, linewidth = lw)
    lines!(ax, [(8300, 0), (8300, 600)], color = color_A, linewidth = lw)
    lines!(ax, [(8300, 600), (3300, 600)], color = color_A, linewidth = lw)
    lines!(ax, [(3300, 600), (3300, 0)], color = color_A, linewidth = lw)
    text!(ax, 3350, 500, text = "A", color = color_A, fontsize = 35)

    # Box B: Bottom left (100, 600), top right (3300, 1200)
    lines!(ax, [(100, 600), (3300, 600)], color = color_B, linewidth = lw)
    lines!(ax, [(3300, 600), (3300, 1200)], color = color_B, linewidth = lw)
    lines!(ax, [(3300, 1200), (100, 1200)], color = color_B, linewidth = lw)
    lines!(ax, [(100, 1200), (100, 600)], color = color_B, linewidth = lw)
    text!(ax, 3050, 600, text = "B", color = color_B, fontsize = 35)
    crng = map(x -> round(x, digits = 2), range(clims..., length = 8))
    Colorbar(fig[3, 1], plt, vertical = false, ticks = crng)

    # Sparse plots
    sparse_ix, t_sparse = plot_sparse_for_movie!(fig, "b", group, resultid, sparse_results)

    # ax_plt.xticks[] = 0:100:1000
    framerate = 24
    filename = movie_filename("b", group, resultid)

    record(fig, filename, indices;
        framerate = framerate) do t
            tmp = clamp(floor(t), 1, length(steps))
            ix[] = tmp
            t_step = steps[tmp]
            mindist, minix = findmin(i -> abs(t_sparse[i] - t_step), eachindex(t_sparse))
            # println("$t / $(length(indices))")
            sparse_ix[] = minix
    end
    return filename
end

function make_movie_casea(results, sparse_results; group, resultid::Int)
    steps = CSP11Visualizer.canonical_reporting_steps("a")

    k = "X_co2"
    clims, t, zero_to_nan = CSP11Visualizer.key_info(k, results[1]["case"])
    @assert !isnothing(clims)
    lw = 3

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
    ax = Axis(fig[1:2, 1], title = t)
    ix = Observable(1)
    function getresult(i)
        tmp = vec(results[i][k])
        if eltype(tmp) != Float64
            tmp = Float64.(tmp)
        end
        return tmp
    end
    values = @lift getresult($ix)
    plt = heatmap!(ax, vec(x), vec(z), values,
        colormap = CSP11Visualizer.default_colormap(),
        colorrange = clims,
    )

    color_A, color_B = colors_for_movie()

    # Box A: Bottom left (3300, 0), top right (8300, 600)
    A11 = 1.1
    A12 = 2.8
    A21 = 0.0
    A22 = 0.6
    lines!(ax, [(A11, A21), (A12, A21)], color = color_A, linewidth = lw)
    lines!(ax, [(A12, A21), (A12, A22)], color = color_A, linewidth = lw)
    lines!(ax, [(A12, A22), (A11, A22)], color = color_A, linewidth = lw)
    lines!(ax, [(A11, A22), (A11, A21)], color = color_A, linewidth = lw)
    text!(ax, 1.02*A11, 0.8*A22, text = "A", color = color_A, fontsize = 35)

    # Box B: Bottom left (100, 600), top right (3300, 1200)
    B11 = 0.0
    B12 = 1.1
    B21 = 0.6
    B22 = 1.2

    lines!(ax, [(B11, B21), (B12, B21)], color = color_B, linewidth = lw)
    lines!(ax, [(B12, B21), (B12, B22)], color = color_B, linewidth = lw)
    lines!(ax, [(B12, B22), (B11, B22)], color = color_B, linewidth = lw)
    lines!(ax, [(B11, B22), (B11, B21)], color = color_B, linewidth = lw)
    text!(ax, 0.92*B12, B21, text = "B", color = color_B, fontsize = 35)
    crng = map(x -> round(x, digits = 4), range(clims..., length = 8))
    Colorbar(fig[3, 1], plt, vertical = false, ticks = crng)

    # Sparse plots
    sparse_ix, t_sparse = plot_sparse_for_movie!(fig, "a", group, resultid, sparse_results)
    framerate = 24
    filename = movie_filename("a", group, resultid)

    record(fig, filename, indices;
        framerate = framerate) do t
            tmp = clamp(floor(t), 1, length(steps))
            ix[] = tmp
            t_step = steps[tmp]
            mindist, minix = findmin(i -> abs(t_sparse[i] - t_step), eachindex(t_sparse))
            # println("$t / $(length(indices))")
            sparse_ix[] = minix
    end
    return filename
end

function sparse_for_movie(sparse_results, k, group, result)
    # groups = intersect(get_canonical_order(), unique(results[:, "group"]))
    ugroups = unique(sparse_results[:, "groupresult"])
    self_index = 0
    sparse_data = Vector{Float64}[]
    sparse_time = Vector{Float64}[]
    for ugroup in ugroups
        if ugroup == "$group$result"
            self_index += 1
        end
        group_result = filter(row -> row.groupresult == ugroup, sparse_results)
        r = group_result[!, k]
        t = group_result[!, "time"]
        ix = sortperm(t)
        push!(sparse_time, t[ix])
        push!(sparse_data, r[ix])
    end
    @assert self_index > 0
    return (sparse_data[self_index], sparse_data, sparse_time[self_index], sparse_time, self_index)
end

function make_movie_casec(results, sparse_results; group, resultid)
    m = CSP11Visualizer.get_mesh("c")
    indices = Int[]
    steps = CSP11Visualizer.canonical_reporting_steps("c")
    for (i, step) in enumerate(steps)
        if step <= 100.0
            n = 5
        else
            δ = steps[i] - steps[i-1]
            n = δ ÷ 5
        end
        for j in 1:n
            push!(indices, i)
        end
    end
    k = "X_co2"
    t = "CO2 in liquid phase"
    clims, t, zero_to_nan = CSP11Visualizer.key_info(k, results[1]["case"])
    GLMakie.activate!()

    cmap = CSP11Visualizer.default_colormap(:default, alpha = true, arange = (0, 1.0), k = 3)
    # fig = Figure(size = (1200, 800), fontsize = 18)
    fig = Figure(size = (1200, 1300), fontsize = 18)

    ix = Observable(1)
    sparse_ix = Observable(1)

    ax = Axis3(fig[1:2, 1], aspect = (8.4, 5, 3*1.2), title = "CO₂ mass fraction in water phase")
    nc = number_of_cells(m)
    pts, tri, mapper = triangulate_mesh(m, outer = false)

    cells = mapper.indices.Cells

    function getresult(i)
        tmp = vec(results[i][k])
        if eltype(tmp) != Float64
            tmp = Float64.(tmp)
        end
        return tmp
    end
    values = @lift getresult($ix)[cells]

    mesh!(ax, pts, tri,
        # color = mapper.Cells(values[]),
        color = values,
        colormap = cmap,
        shading = NoShading,
        transparency = true,
        colorrange = clims
    )
    ax.azimuth[] = 4.25
    ax.elevation[] = 0.153

    cticks = map(i -> round(i, digits = 2), range(clims..., 10))

    Colorbar(fig[3, 1],
        colorrange = clims,
        colormap = CSP11Visualizer.default_colormap(),
        vertical = false,
        ticks = cticks
    )

    sparse_ix, t_sparse = plot_sparse_for_movie!(fig, "c", group, resultid, sparse_results)

    framerate = 24
    filename = movie_filename("c", group, resultid)

    record(fig, filename, indices;
        framerate = framerate
    ) do t
        tmp = clamp(floor(t), 1, length(steps))
        ix[] = tmp
        t_step = steps[tmp]
        mindist, minix = findmin(i -> abs(t_sparse[i] - t_step), eachindex(t_sparse))
        sparse_ix[] = minix
        # println("$tmp / $(length(steps)) ($t with tstep = $t_step)")
    end
    filename
end

function plot_sparse_for_movie!(fig, case, group, resultid, sparse_results)
    # Sparse plots
    mob_a, mob_a_all, t_sparse, t_sparse_all, self_ix = sparse_for_movie(sparse_results, "mobA", group, resultid)
    mob_b, mob_b_all, = sparse_for_movie(sparse_results, "mobB", group, resultid)
    diss_a, diss_a_all, = sparse_for_movie(sparse_results, "dissA", group, resultid)
    diss_b, diss_b_all, = sparse_for_movie(sparse_results, "dissB", group, resultid)

    if case == "a"
        t_scale_sparse = 3600.0
        t_inj_stop = 10.0
        x_max = 120.0
    elseif case == "b" || case == "c"
        t_scale_sparse = 1.0
        t_inj_stop = 100.0
        x_max = 1000.0
    else
        error("Not implemented")
    end
    t_sparse = t_sparse./t_scale_sparse
    t_sparse_all = map(t -> t./t_scale_sparse, t_sparse_all)

    # Sparse plot
    sparse_ix = Observable(1)
    t_dot = @lift t_sparse[$sparse_ix]

    # Group 1
    ax1 = Axis(fig[4, 1], title = "Mobile CO₂", ylabel = "kg")
    plot_lines_for_movie!(ax1, t_sparse, t_sparse_all, mob_a, mob_b, mob_a_all, mob_b_all, t_inj_stop, sparse_ix, t_dot)
    ax1.xticklabelsvisible = false

    # Group 2
    ax2 = Axis(fig[5, 1], title = "Dissolved CO₂", xlabel = "Time (years)", ylabel = "kg")
    plot_lines_for_movie!(ax2, t_sparse, t_sparse_all, diss_a, diss_b, diss_a_all, diss_b_all, t_inj_stop, sparse_ix, t_dot)

    xt = map(x -> round(x, digits = 2), range(0, maximum(t_sparse), length = 11))
    ax2.xticks[] = xt

    return (sparse_ix, t_sparse)
end

function colors_for_movie()
    mk = Makie.wong_colors()
    color_A = mk[1]
    color_B = mk[3]
    return (color_A, color_B)
end

function plot_lines_for_movie!(AX, t_sparse, t_sparse_all, A, B, A_all, B_all, t_inj_stop, sparse_ix, t_dot)
    lw = 3
    color_A, color_B = colors_for_movie()

    ymax = 1.2*max(maximum(A), maximum(B))
    xmax = maximum(t_sparse)

    bg_arg_A = (color = color_A, linewidth = lw, alpha = 0.15)
    bg_arg_B = (color = color_B, linewidth = lw, alpha = 0.15)

    # Alternative grey colors
    # bg_arg_A = (color = :black, linewidth = lw, alpha = 0.2)
    # bg_arg_B = (color = :black, linewidth = lw, alpha = 0.2)

    for (i, val) in enumerate(A_all)
        lines!(AX, t_sparse_all[i], val; bg_arg_A...)
    end
    for (i, val) in enumerate(B_all)
        lines!(AX, t_sparse_all[i], val; bg_arg_B...)
    end
    lines!(AX, t_sparse, A, color = color_A, linewidth = lw, label = "Box A")
    lines!(AX, t_sparse, B, color = color_B, linewidth = lw, label = "Box B")
    lines!(AX, [t_inj_stop, t_inj_stop], [0, ymax], color = :black)#, label = "End of injection")
    A_dot = @lift A[$sparse_ix]
    B_dot = @lift B[$sparse_ix]
    mz = 12
    mz_big = mz + 2
    scatter!(AX, t_dot, A_dot, markersize = mz_big, color = :black)
    scatter!(AX, t_dot, A_dot, markersize = mz, color = color_A)
    scatter!(AX, t_dot, B_dot, markersize = mz_big, color = :black)
    scatter!(AX, t_dot, B_dot, markersize = mz, color = color_B)
    axislegend(position = :ct, nbanks = 2)
    xlims!(AX, 0, xmax)
    ylims!(AX, 0, ymax)
end

function movie_directory(case)
    vizmod_path = pathof(CSP11Visualizer) |> splitdir |> first
    movie_dir = joinpath(vizmod_path, "..", "..", "docs", "movies", "dense_$case")
    mkpath(movie_dir)
    return movie_dir
end

function movie_filename(case, group, resultid)
    @assert case in ["a", "b", "c"]
    @assert resultid in 1:4
    return joinpath(movie_directory(case), "movie$(case)_$(group)_$resultid.mp4")
end
