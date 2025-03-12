function default_colormap(cmap_name = :default; alpha = false, k = 1, arange = (0.0, 1.0), alpha_cutoff = Inf)
    if cmap_name == :default
        cmap = to_colormap(:seaborn_icefire_gradient)
        pushfirst!(cmap, RGBf(1.0, 1.0, 1.0))
    else
        cmap = to_colormap(cmap_name)
    end
    function to_alpha(t)
        amin, amax = arange
        A = amin + (amax - amin)*((t[1]-1)/length(cmap))^k
        if A > alpha_cutoff
            A = 1.0
        end
        return RGBAf(t[2].r, t[2].g, t[2].b, A)
    end
    if alpha
        cmap = map(
            to_alpha,
            enumerate(cmap)
        )
    end
    return cmap
end

function canonical_reporting_steps(case)
    if case == "b"
        steps = collect(0:5:1000)
    elseif case == "c"
        steps = [
            0, 5, 10, 15, 20, 25,
            30, 35, 40, 45, 50, 75,
            100, 150, 200, 250, 300, 350,
            400, 450, 500, 600, 700,
            800, 900, 1000
        ]
        @assert length(steps) == 26
    else
        @assert case == "a"
        steps = collect(0:1:120)
    end
    return steps
end

function parse_dense_timesteps(group, result, case = "b";
        path = default_data_path(),
        steps = missing,
        verbose = true
    )
    if ismissing(steps)
        steps = canonical_reporting_steps(case)
    end
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
        if !isdir(casepath)
            continue
        end
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
    GLMakie.activate!()
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

function plot_snapshot(result, k; use_clims = true)
    CairoMakie.activate!()
    name = "$k"
    clims, t, zero_to_nan = key_info(name, result["case"])
    # GLMakie.activate!()
    r = result[name]
    x = result["x"]
    z = result["z"]
    fig = Figure(size = (1200, 600), backgroundcolor = :transparent)
    D = copy(vec(r))
    if zero_to_nan
        D[D .== 0] .= NaN
    end
    failure = eltype(D) != Float64 || all(isnan, D)
    ax = Axis(fig[1, 1], title = t, ygridvisible = false, xgridvisible = false)
    if !failure
        if isnothing(clims) || !use_clims
            arg = NamedTuple()
        else
            arg = (colorrange = clims, )
        end
        try
            plt = heatmap!(ax, vec(x), vec(z), D;
                colormap = default_colormap(),
                arg...
            )
            Colorbar(fig[1, 2], plt)
        catch excpt
            @error "Failed to plot $k" excpt
            failure = true
        end
    end
    if failure
        text!(ax, 0.5, 0.5, text = "Data missing / plot failure.", fontsize = 50, align = (:center, :baseline))
    end
    return fig
end

case_c_ij_planes() = (84, 50)

function plot_snapshot_c(result, k, IJ = case_c_ij_planes(); use_clims = true)
    I, J = IJ
    CairoMakie.activate!()
    name = "$k"
    clims, t, zero_to_nan = key_info(name, result["case"])
    # GLMakie.activate!()
    r = copy(result[name])
    if zero_to_nan
        r[r .== 0] .= NaN
    end

    x_I = result["y"][I, :, :]
    z_I = result["z"][I, :, :]
    r_I = r[I, :, :]
    x_J = result["x"][:, J, :]
    z_J = result["z"][:, J, :]
    r_J = r[:, J, :]

    D = vec(r)
    fig = Figure(size = (1200, 1200), backgroundcolor = :transparent)
    failure = eltype(r) != Float64 || all(isnan, r)
    ax1 = Axis(fig[1, 1], title = "$t (I = $I)", ygridvisible = false, xgridvisible = false)
    ax2 = Axis(fig[2, 1], title = "$t (J = $J)", ygridvisible = false, xgridvisible = false)

    if !failure
        if isnothing(clims) || !use_clims
            arg = NamedTuple()
        else
            arg = (colorrange = clims, )
        end
        try
            plt = heatmap!(ax1, vec(x_I), vec(z_I), vec(r_I);
                colormap = default_colormap(),
                arg...
            )
            plt = heatmap!(ax2, vec(x_J), vec(z_J), vec(r_J);
                colormap = default_colormap(),
                arg...
            )
            Colorbar(fig[3, 1], plt, vertical = false)
        catch excpt
            @error "Failed to plot $k" excpt
            failure = true
        end
    end
    if failure
        text!(ax1, 0.5, 0.5, text = "Data missing / plot failure.", fontsize = 50, align = (:center, :baseline))
        text!(ax2, 0.5, 0.5, text = "Data missing / plot failure.", fontsize = 50, align = (:center, :baseline))
    end
    return fig
end

function parse_dense_data(group, result, year_or_h, case = "b", path = default_data_path())
    if case == "b" || case == "c"
        fname = "spe11$(case)_spatial_map_$(year_or_h)y.csv"
    else
        fname = "spe11$(case)_spatial_map_$(year_or_h)h.csv"
    end
    raw_pth = joinpath(path, group, "spe11$case", fname)
    if result == 1 && isfile(raw_pth)
        # Flat structure with a single result
        subpth = raw_pth
    else
        # Nested folders with results
        subpth = joinpath(path, group, "spe11$case", "result$result", fname)
    end
    if case == "b"
        dims = [840, 120]
        # # x [m],z [m],WATER_PRESSURE
        # [Pa],gas saturation [-],mass fraction of CO2 in liquid [-],mass fraction of H20 in vapor [-],
        # phase mass density gas [kg/m3]phase mass density water [kg/m3],
        # total mass CO2 [kg],temperature [Celsius]

        normnames = [
            :x,
            :z,
            :pw,
            :sg,
            :X_co2,
            :Y_h2o,
            :deng,
            :denw,
            :co2mass,
            :T
        ]
    elseif case == "c"
        normnames = [
            :x,
            :y,
            :z,
            :pw,
            :sg,
            :X_co2,
            :Y_h2o,
            :deng,
            :denw,
            :co2mass,
            :T
        ]
        dims = [168, 100, 120]
    else
        @assert case == "a"
        normnames = [
            :x,
            :z,
            :pw,
            :sg,
            :X_co2,
            :Y_h2o,
            :deng,
            :denw,
            :co2mass
        ]
        dims = [280, 120]
    end
    df = missing
    for commentkey in ["#", "\"", "x"]
        subdf = CSV.read(subpth, DataFrame,
            normalizenames=true,
            comment = commentkey,
            missingstring = "n/a",
            header = false
        )
        if size(subdf, 1) == prod(dims)
            df = subdf
            break
        end
    end
    @assert !ismissing(df) "Failed to parse $subpth"

    for (i, name) in enumerate(names(df))
        rename!(df, Symbol(name) => normnames[i])
    end
    x = df[:, :x]
    if case == "c"
        # TODO: Check this
        y = df[:, :y]
    else
        y = zeros(length(x))
    end
    z  = df[:, :z]
    ix = sorted_indices(x, y, z)
    out = Dict{String, Any}()
    for name in names(df)
        val = df[:, name]
        if eltype(val) != Float64 || eltype(val) != Int64
            val = [ifelse(ismissing(i), NaN, i) for i in val]
        end
        val = reshape(val[ix], dims...)
        if eltype(val) == Float64 && !(name in ["x", "y", "z"])
            # Round to 4 significant digits per the specification of the
            # benchmark.
            val = round.(val, sigdigits = 4)
        end
        out[name] = val
    end
    out["case"] = case
    return out
end

function sorted_indices(x, y, z)
    Lx = maximum(x)
    Ly = maximum(y)
    Lz = maximum(z)

    return sort(eachindex(z), by = i -> sortfunction(i, x, y, z, Lx, Ly, Lz))
end

function sortfunction(i, x, y, z, Lx, Ly, Lz)
    xi = x[i]
    yi = y[i]
    zi = z[i]
    # return i
    return zi*(Lx*Ly) + yi*Lx + xi
end

function key_info(var::String, case::String)
    yscale = nothing
    label = ""
    zero_to_nan = false
    if case == "b" || case == "c"
        # At the moment we use same scaling for b and c
        # Commented numbers are taken from OPM 1
        if var == "T"
            yscale = (0.0, 75.0)
            label = "Temperature (°C)"
        elseif var == "pw"
            yscale = (3e7, 4.5e7) # 3.23e7 -> 4.47e7
            label =  "Pressure (Pascal)"
        elseif var == "co2mass"
            yscale = (0.0, 30000.0) #  (0.0, 28550.0)
            label = "Total mass of CO₂ (kg)"
            zero_to_nan = true
        elseif var == "X_co2"
            yscale = (0.0, 0.06)
            label = "CO₂ mass fraction in water phase"
        elseif var == "Y_h2o"
            yscale = (0.0, 0.005)
            label = "H₂O mass fraction in gas/supercritical phase"
        elseif var == "sg"
            yscale = (0.0, 1.0)
            label = "Gas saturation"
        elseif var == "denw"
            yscale = (990, 1050.0)
            label = "Water density (kg/m³)"
            zero_to_nan = true
        elseif var == "deng"
            yscale = (900, 1060.0)
            label = "Gas density (kg/m³)"
            zero_to_nan = true
        end
    elseif case == "a"
        if var == "X_co2"
            yscale = (0.0, 0.002)
            label = "CO₂ mass fraction in water phase"
        elseif var == "pw"
            yscale = (110000.0, 125000.0) 
            label =  "Pressure (Pascal)"
        elseif var == "denw"
            yscale = (997.0, 998.0)
            label = "Water density (kg/m³)"
            zero_to_nan = true
        elseif var == "deng"
            yscale = (1.0, 2.2)
            label = "Gas density (kg/m³)"
            zero_to_nan = true
        elseif var == "Y_h2o"
            yscale = (0.0, 0.01)
            label = "H₂O mass fraction in gas/supercritical phase"
        elseif var == "X_co2"
            yscale = (0.0, 0.002)
            label = "CO₂ mass fraction in liquid"
        elseif var == "sg"
            yscale = (0.0, 1.0)
            label = "Gas saturation"
        elseif var == "co2mass"
            yscale = (0.0, 10e-7) #  (0.0, 28550.0)
            label = "Total mass of CO₂ (kg)"
            zero_to_nan = true
        end
    end
    if isnothing(yscale)
        @warn "No scaling for $var for case $case"
    end
    return (yscale, label, zero_to_nan)
end