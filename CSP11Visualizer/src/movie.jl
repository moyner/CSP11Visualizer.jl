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
    t_sparse = sparse_results[:, "time"]
    mob_a = sparse_results[:, "mobA"]
    mob_b = sparse_results[:, "mobB"]
    diss_a = sparse_results[:, "dissA"]
    diss_b = sparse_results[:, "dissB"]

    # Sort
    sortix = sortperm(t_sparse)
    t_sparse = t_sparse[sortix]
    mfactor = 1.0
    mob_a = mob_a[sortix]./mfactor
    mob_b = mob_b[sortix]./mfactor
    diss_a = diss_a[sortix]./mfactor
    diss_b = diss_b[sortix]./mfactor

    # Sparse plot
    # Group 1
    ax_plt = Axis(fig[4, 1], title = "Mobile CO₂", ylabel = "kg")
    ymax = 1.2*max(maximum(mob_a), maximum(mob_b))
    lines!(ax_plt, t_sparse, mob_a, color = color_A, linewidth = lw, label = "Box A")
    lines!(ax_plt, t_sparse, mob_b, color = color_B, linewidth = lw, label = "Box B")
    lines!(ax_plt, [100, 100], [0, ymax], color = :black)#, label = "End of injection")

    sparse_ix = Observable(1)
    t_dot = @lift t_sparse[$sparse_ix]
    mob_a_dot = @lift mob_a[$sparse_ix]
    mob_b_dot = @lift mob_b[$sparse_ix]

    mz = 12
    mz_big = mz + 2
    scatter!(ax_plt, t_dot, mob_a_dot, markersize = mz_big, color = :black)
    scatter!(ax_plt, t_dot, mob_a_dot, markersize = mz, color = color_A)
    scatter!(ax_plt, t_dot, mob_b_dot, markersize = mz_big, color = :black)
    scatter!(ax_plt, t_dot, mob_b_dot, markersize = mz, color = color_B)
    axislegend(position = :ct, nbanks = 2)

    ax_plt.xticklabelsvisible = false
    xlims!(ax_plt, 0, 1000.0)
    ylims!(ax_plt, 0, ymax)

    # Group 2
    ax_plt = Axis(fig[5, 1], title = "Dissolved CO₂", xlabel = "Time (years)", ylabel = "kg")
    ymax = 1.2*max(maximum(diss_b), maximum(diss_a))
    lines!(ax_plt, t_sparse, diss_a, color = color_A, linewidth = lw, label = "Box A")
    lines!(ax_plt, t_sparse, diss_b, color = color_B, linewidth = lw, label = "Box B")
    lines!(ax_plt, [100, 100], [0, ymax], color = :black)#, label = "End of injection")

    diss_a_dot = @lift diss_a[$sparse_ix]
    diss_b_dot = @lift diss_b[$sparse_ix]

    scatter!(ax_plt, t_dot, diss_a_dot, markersize = mz_big, color = :black)
    scatter!(ax_plt, t_dot, diss_a_dot, markersize = mz, color = color_A)
    scatter!(ax_plt, t_dot, diss_b_dot, markersize = mz_big, color = :black)
    scatter!(ax_plt, t_dot, diss_b_dot, markersize = mz, color = color_B)

    axislegend(position = :ct, nbanks = 2)
    xlims!(ax_plt, 0, 1000.0)
    ylims!(ax_plt, 0, ymax)

    ax_plt.xticks[] = 0:100:1000
    framerate = 24
    record(fig, filename, indices;
        framerate = framerate) do t
        ix[] = t
        t_step = steps[t]
        mindist, minix = findmin(i -> abs(t_sparse[i] - t_step), eachindex(t_sparse))
        # println("$t / $(length(indices))")

        sparse_ix[] = minix
    end
    return filename
end

function make_movie_casea(steps, results, sparse_results; filename)
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
    t_sparse = sparse_results[:, "time"]./3600.0
    mob_a = sparse_results[:, "mobA"]
    mob_b = sparse_results[:, "mobB"]
    diss_a = sparse_results[:, "dissA"]
    diss_b = sparse_results[:, "dissB"]

    # Sort
    sortix = sortperm(t_sparse)
    t_sparse = t_sparse[sortix]
    mfactor = 1.0
    mob_a = mob_a[sortix]./mfactor
    mob_b = mob_b[sortix]./mfactor
    diss_a = diss_a[sortix]./mfactor
    diss_b = diss_b[sortix]./mfactor

    # Sparse plot
    t_inj_stop = 10.0
    # Group 1
    ax_plt = Axis(fig[4, 1], title = "Mobile CO₂", ylabel = "kg")
    ymax = 1.2*max(maximum(mob_a), maximum(mob_b))
    lines!(ax_plt, t_sparse, mob_a, color = color_A, linewidth = lw, label = "Box A")
    lines!(ax_plt, t_sparse, mob_b, color = color_B, linewidth = lw, label = "Box B")
    lines!(ax_plt, [t_inj_stop, t_inj_stop], [0, ymax], color = :black)#, label = "End of injection")

    sparse_ix = Observable(1)
    t_dot = @lift t_sparse[$sparse_ix]
    mob_a_dot = @lift mob_a[$sparse_ix]
    mob_b_dot = @lift mob_b[$sparse_ix]

    mz = 12
    mz_big = mz + 2
    scatter!(ax_plt, t_dot, mob_a_dot, markersize = mz_big, color = :black)
    scatter!(ax_plt, t_dot, mob_a_dot, markersize = mz, color = color_A)
    scatter!(ax_plt, t_dot, mob_b_dot, markersize = mz_big, color = :black)
    scatter!(ax_plt, t_dot, mob_b_dot, markersize = mz, color = color_B)
    axislegend(position = :ct, nbanks = 2)

    ax_plt.xticklabelsvisible = false
    xlims!(ax_plt, 0, 120.0)
    ylims!(ax_plt, 0, ymax)

    # Group 2
    ax_plt = Axis(fig[5, 1], title = "Dissolved CO₂", xlabel = "Time (years)", ylabel = "kg")
    ymax = 1.2*max(maximum(diss_b), maximum(diss_a))
    lines!(ax_plt, t_sparse, diss_a, color = color_A, linewidth = lw, label = "Box A")
    lines!(ax_plt, t_sparse, diss_b, color = color_B, linewidth = lw, label = "Box B")
    lines!(ax_plt, [t_inj_stop, t_inj_stop], [0, ymax], color = :black)#, label = "End of injection")

    diss_a_dot = @lift diss_a[$sparse_ix]
    diss_b_dot = @lift diss_b[$sparse_ix]

    scatter!(ax_plt, t_dot, diss_a_dot, markersize = mz_big, color = :black)
    scatter!(ax_plt, t_dot, diss_a_dot, markersize = mz, color = color_A)
    scatter!(ax_plt, t_dot, diss_b_dot, markersize = mz_big, color = :black)
    scatter!(ax_plt, t_dot, diss_b_dot, markersize = mz, color = color_B)

    axislegend(position = :ct, nbanks = 2)
    xlims!(ax_plt, 0, 120.0)
    ylims!(ax_plt, 0, ymax)

    ax_plt.xticks[] = 0:15:120
    framerate = 24
    record(fig, filename, indices;
        framerate = framerate) do t
        ix[] = t
        t_step = steps[t]
        mindist, minix = findmin(i -> abs(t_sparse[i] - t_step), eachindex(t_sparse))
        # println("$t / $(length(indices))")

        sparse_ix[] = minix
    end
    return filename
end
