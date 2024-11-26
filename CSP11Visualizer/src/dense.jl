default_colormap() = :seaborn_icefire_gradient

function parse_dense_timesteps(group, result, case = "b";
        path = default_data_path(),
        steps = 0:5:1000,
        verbose = true
    )
    results = []
    for (i, year) in enumerate(steps)
        if verbose
            println("Reading step $i/$(length(steps)) at $year years")
        end
        push!(results, parse_dense_data(group, result, year, case, path))
    end
    return results
end

function available_dense_data(case = "b")
    pth = default_data_path("dense")
    groups = readdir(pth)
    results = Dict{String, Any}()
    for group in groups
        present_results = Int[]
        casepath = joinpath(pth, group, "spe11$case")
        subdirs = readdir(casepath)
        if "result1" in subdirs
            for dir in subdirs
                if startswith(dir, "result")
                    result_id = parse(Int64, dir[end])
                    push!(present_results, result_id)
                end
            end
        else
            push!(present_results, 1)
        end
        if length(present_results) > 0
            results[group] = present_results
        end
    end
    return results
end

function make_movie(results, k, t = k; filename = "sg.mp4")
    x = results[1]["_x_m"]
    z = results[1]["z_m"]
    fig = Figure(size = (1200, 600))
    ax = Axis(fig[1, 1], title = t)
    ix = Observable(1)
    getresult(i) = vec(results[i][k])
    values = @lift getresult($ix)
    plt = heatmap!(ax, vec(x), vec(z), values, colormap = default_colormap())
    Colorbar(fig[1, 2], plt)
    framerate = 24
    record(fig, filename, eachindex(results);
        framerate = framerate) do t
        ix[] = t
    end
    return filename
end

function plot_snapshot(result, k, t = k)
    x = result["_x_m"]
    z = result["z_m"]
    fig = Figure(size = (1200, 600))
    ax = Axis(fig[1, 1], title = t)
    plt = heatmap!(ax, vec(x), vec(z), vec(result[k]), colormap = default_colormap())
    Colorbar(fig[1, 2], plt)
    return fig
end

function parse_dense_data(group, result, year, case = "b", path = default_data_path())
    subpth = joinpath(path, group, "spe11$case", "result$result", "spe11$(case)_spatial_map_$(year)y.csv")
    if case == "b"
        dims = [840, 120]
    else
        @assert case == "c"
        dims = [168, 100, 120]
    end
    df = CSV.read(subpth, DataFrame, normalizenames=true)
    x = df[:, "_x_m_"]
    if case == "c"
        # TODO: Check this
        y = df[:, "_y_m_"]
    else
        y = zeros(length(x))
    end
    z  = df[:, "z_m_"]
    Lx = maximum(x)
    Ly = maximum(y)
    Lz = maximum(z)
    function sortfunction(i)
        xi = x[i]
        yi = y[i]
        zi = z[i]
        # return i
        return zi*(Lx*Ly) + yi*Lx + xi
    end
    ix = sort(eachindex(z), by = sortfunction)
    out = Dict{String, AbstractArray{Float64}}()
    for name in names(df)
        val = df[:, name]
        val = reshape(val[ix], dims...)
        out[rstrip(name, '_')] = val
    end
    return out
end
