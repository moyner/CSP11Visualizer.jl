function make_movie_caseb(steps, results, sparse_results; filename)
    k = "X_co2"
    t = "CO2 in liquid phase"
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
    getresult(i) = vec(results[i][k])
    values = @lift getresult($ix)
    plt = heatmap!(ax, vec(x), vec(z), values,
        colormap = CSP11Visualizer.default_colormap(),
        colorrange = clims,
    )

    # Box A: Bottom left (3300, 0), top right (8300, 600)
    color_A = :red
    color_B = :blue

    mk = Makie.wong_colors()
    color_A = mk[1]
    color_B = mk[3]

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
    plot_sparse_for_movie!(fig)

    ax_plt.xticks[] = 0:100:1000
    framerate = 24
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

function make_movie_casea(steps, results, sparse_results; filename, group, resultid::Int)
    k = "X_co2"
    t = "CO2 in liquid phase"
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
    getresult(i) = vec(results[i][k])
    values = @lift getresult($ix)
    plt = heatmap!(ax, vec(x), vec(z), values,
        colormap = CSP11Visualizer.default_colormap(),
        colorrange = clims,
    )

    # Box A: Bottom left (3300, 0), top right (8300, 600)
    color_A = :red
    color_B = :blue

    mk = Makie.wong_colors()
    color_A = mk[1]
    color_B = mk[3]

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

function plot_sparse_for_movie!(fig, case, group, resultid, sparse_results)
    lw = 3
    # Sparse plots
    mob_a, mob_a_all, t_sparse, t_sparse_all, self_ix = sparse_for_movie(sparse_results, "mobA", group, resultid)
    mob_b, mob_b_all, = sparse_for_movie(sparse_results, "mobB", group, resultid)
    diss_a, diss_a_all, = sparse_for_movie(sparse_results, "dissA", group, resultid)
    diss_b, diss_b_all, = sparse_for_movie(sparse_results, "dissB", group, resultid)

    if case == "a"
        t_scale_sparse = 3600.0
        t_inj_stop = 10.0
        x_max = 120.0
    else
        error("Not implemented")
    end
    color_A, color_B = colors_for_movie()
    t_sparse = t_sparse./t_scale_sparse
    t_sparse_all = map(t -> t./t_scale_sparse, t_sparse_all)

    # mob_a = sparse_results[:, "mobA"]
    # mob_b = sparse_results[:, "mobB"]
    # diss_a = sparse_results[:, "dissA"]
    # diss_b = sparse_results[:, "dissB"]

    # # Sort
    # sortix = sortperm(t_sparse)
    # t_sparse = t_sparse[sortix]
    # mfactor = 1.0
    # mob_a = mob_a[sortix]./mfactor
    # mob_b = mob_b[sortix]./mfactor
    # diss_a = diss_a[sortix]./mfactor
    # diss_b = diss_b[sortix]./mfactor

    # Sparse plot
    sparse_ix = Observable(1)
    t_dot = @lift t_sparse[$sparse_ix]

    function plot_lines!(AX, t_sparse, t_sparse_all, A, B, A_all, B_all)
        ymax = 1.2*max(maximum(A), maximum(B))

        bg_arg_A = (color = color_A, linewidth = lw, alpha = 0.2)
        bg_arg_B = (color = color_B, linewidth = lw, alpha = 0.2)

        bg_arg_A = (color = :black, linewidth = lw, alpha = 0.2)
        bg_arg_B = (color = :black, linewidth = lw, alpha = 0.2)

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
        AX.xticklabelsvisible = false
        xlims!(AX, 0, x_max)
        ylims!(AX, 0, ymax)
    end
    # Group 1
    ax1 = Axis(fig[4, 1], title = "Mobile CO₂", ylabel = "kg")
    plot_lines!(ax1, t_sparse, t_sparse_all, mob_a, mob_b, mob_a_all, mob_b_all)

    # Group 2
    ax2 = Axis(fig[5, 1], title = "Dissolved CO₂", xlabel = "Time (years)", ylabel = "kg")
    plot_lines!(ax2, t_sparse, t_sparse_all, diss_a, diss_b, diss_a_all, diss_b_all)
    return (sparse_ix, t_sparse)
end

function colors_for_movie()
    mk = Makie.wong_colors()
    color_A = mk[1]
    color_B = mk[3]
    return (color_A, color_B)
end
