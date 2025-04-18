const YEAR = 365*3600*24

function resample_table(t, vals)
    t_rep = 3.1536e6 # 0.1 year
    start = 0.0
    stop = t[end]
    t_i = collect(range(start, stop, step = t_rep))

    new_vals = []
    for v in vals
        I = get_1d_interpolator(t, v)
        push!(new_vals, I.(t_i))
    end

    return (t_i, new_vals)
end

function read_file(pth, group, result, case; resample = false)
    df = missing
    time = missing
    for cmt in ["#", "\"", "t"]
        df_attempt = CSV.read(pth, DataFrame, comment = cmt, header = false)
        T_t = eltype(df_attempt[:, 1])
        if T_t == Float64 || T_t == Int64
            df = df_attempt
            break
        end
    end
    @assert !ismissing(df) "Failed to parse $pth"
    time = df[:, 1]
    p1 = df[:, 2]
    p2 = df[:, 3]

    mobA = df[:, 4]
    immA = df[:, 5]
    dissA = df[:, 6]
    sealA = df[:, 7]

    mobB = df[:, 8]
    immB = df[:, 9]
    dissB = df[:, 10]
    sealB = df[:, 11]
    M = df[:, 12]
    sealTot = df[:, 13]

    if case == "a"
        boundTot = fill(NaN, length(time))
        t_scale = 1.0
    elseif case == "b" || case == "c"
        boundTot = df[:, 14]
        t_scale = YEAR
    else
        error("Unknown case $case")
    end
    if resample
        time, new_tab = resample_table(time, (p1, p2, mobA, immA, dissA, sealA, mobB, immB, dissB, sealB, M, sealTot, boundTot))
        p1, p2, mobA, immA, dissA, sealA, mobB, immB, dissB, sealB, M, sealTot, boundTot = new_tab
    end
    return DataFrame(time = time/t_scale,
            P1 = p1, P2 = p2,
            mobA = mobA, immA=immA, dissA=dissA, sealA=sealA,
            mobB = mobB, immB=immB, dissB=dissB, sealB=sealB,
            M = M, sealTot = sealTot, boundTot = boundTot,
            group = group,
            result = result,
            case = case,
            groupresult = "$group$result",
        )
end

function parse_all_sparse(pth = missing;
        case = "b",
        verbose = false,
        merge = true,
        active_groups = nothing,
        active_result = nothing
    )
    if ismissing(pth)
        pth = default_data_path(case)
    end
    if active_groups isa AbstractString
        active_groups = [active_groups]
    end
    function maybe_print(x)
        if verbose
            println(x)
        end
    end

    groups = readdir(pth)
    results = Dict{String, Any}()
    for casepath in readdir(pth)
        group, result_id = group_and_result(casepath)
        if !isnothing(active_groups) && !(group in active_groups)
            continue
        end
        if !isnothing(active_result) && !(result_id == active_result)
            active_result::Int
            continue
        end
        if !haskey(results, group)
            results[group] = Dict{Int, Any}()
        end
        gdata = results[group]
        csv_name = "spe11$(case)_time_series.csv"
        try
            fn = joinpath(pth, casepath, csv_name)
            gdata[result_id] = read_file(fn, group, result_id, case)
        catch excpt
            @error "$group $result_id failed to parse." excpt
            rethrow(excpt)
        end
    end
    if merge
        new_results = DataFrame()
        for (group, data) in results
            for (key, val) in data
                new_results = vcat(new_results, val)
            end
        end
        results = new_results
    end
    return results
end

function get_canonical_order()
    names = [
        "ifpen",
        "calgary",
        "csiro",
        "ctc-cne",
        "delft-darts",
        "geos",
        "opm",
        "kfupm",
        "kiel",
        "opengosim",
        "pau-inria",
        "pnnl",
        "rice",
        "sintef",
        "slb",
        "stuttgart",
        "tetratech-rps",
        "ut-csee-pge"
    ]
    sort!(names)
    return names
end

function get_canonical_colormap()
    # F(x) = clamp(x*d, 0, 1)
    # F(x) = clamp(x*0.8 + 0.1, 0, 1)
    # F(x) = x
    F(x) = clamp(x^1.5, 0, 1)

    canonical_group_order = get_canonical_order()
    cmap = Makie.to_colormap(:tab20)
    keep = [1:16..., 17, 19]
    cmap = cmap[keep]
    for i in 1:2:length(cmap)-1
        # Put light on top
        cmap[i], cmap[i+1] = cmap[i+1], cmap[i]
    end
    # Then make sure that IFPEN and GEOS get the grey/dark set since we want to
    # make IFPEN stand out as the "median" case.
    for i in 1:2
        old = 2*2+i
        new = 2*7+i
        cmap[old], cmap[new] = cmap[new], cmap[old]
    end
    new_cmap = similar(cmap, 0)
    for (i, group) in enumerate(canonical_group_order)
        c = cmap[i]
        d = 0.9
        if group == "ifpen"
            new_color = RGBf(0.0, 0.0, 0.0)
        else
            # F(x) = clamp(x + (1-x)*d, 0, 1)

            new_color = RGBf(F(c.r), F(c.g), F(c.b))
            # new_color = RGBf(max(c.r*d, 0.0), max(c.g*d, 0.0), max(c.b*d, 0.0))
        end
        push!(new_cmap, new_color)
    end
    return new_cmap
end

function get_group_color(group::String)
    canonical_group_order = get_canonical_order()
    ix = findfirst(isequal(group), canonical_group_order)
    if isnothing(ix)
        ix = length(canonical_group_order) + 1
    end
    cmap = get_canonical_colormap()
    return cmap[ix]
end

function print_canonical_colors()
    groups = get_canonical_order()
    for group in groups
        c = get_group_color(group)
        println("$group => #$(Makie.Colors.hex(c))")
    end
end

function plot_sparse(results, k::Symbol; ymax = nothing, yscale = identity, xscale = identity)
    kstr = "$k"
    if k == :P1 || k == :P2
        ylabel = "Pascal"
        title = "Pressure at observation point $k"
    elseif k == :mobA || k == :mobB
        ylabel = "kg"
        title = "Mobile CO₂ within region $(kstr[4])"
    elseif k == :dissA || k == :dissB
        ylabel = "kg"
        title = "Dissolved CO₂ within region $(kstr[5])"
    elseif k == :immA || k == :immB
        ylabel = "kg"
        title = "Immobile CO₂ within region $(kstr[4])"
    elseif k == :sealA || k == :sealB
        ylabel = "kg"
        title = "CO₂ in seal within region $(kstr[5])"
    elseif k == :sealTot
        ylabel = "kg"
        title = "CO₂ in seal"
    elseif k == :boundTot
        ylabel = "kg"
        title = "CO₂ in boundary cells"
    else
        ylabel = ""
        title = "$k"
    end
    linestyles = [:solid, :dot, :dash, :dashdot]
    groups = intersect(get_canonical_order(), unique(results[:, "group"]))
    ngroups = length(groups)
    plts = []
    line_labels = []
    case = results[1, :case]
    if case == "a"
        xlabel = "Seconds since injection start"
        tscale = 1.0
        xmax = 4.34e5
    else
        @assert case == "b" || case == "c"
        xlabel = "Years since injection start"
        tscale = 1.0
        xmax = 1010.0
    end
    fig = Figure(size = (1200, 900), backgroundcolor = :transparent)
    ax = Axis(fig[1, 1:3],
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
        yscale = yscale,
        xscale = xscale
    )

    for (gno, group) in enumerate(groups)
        group_result = filter(row -> row.group == "$group", results)

        for resultid in 1:4
            subresult = filter(row -> row.groupresult == "$(group)$resultid", group_result)
            x = subresult[!, :time]
            # x = copy(x)
            if length(x) == 0
                continue
            end
            # x[1] += 1e-12
            # @info "Plotting $group $resultid" size(subresult)
            y = subresult[!, k].*tscale
            if eltype(y) == Missing
                y = fill(NaN, length(x))
            else
                replace!(y, missing => NaN)
            end
            c = get_group_color(group)

            plt = lines!(ax, x, y, color = c, label = group, linestyle = linestyles[resultid], linewidth = 1.8)
            if resultid == 1
                push!(plts, plt)
                push!(line_labels, LineElement(color = c, linestyle = :solid, linewidth = 8))
            end
        end
    end
    xlims!(ax, (0.0, xmax))
    if !isnothing(ymax)
        ylims!(ax, (0.0, ymax))
    end
    Legend(fig[2, 1:2], line_labels, groups, "Group", orientation = :horizontal, nbanks = 2)
    # :solid (equivalent to nothing), :dot, :dash, :dashdot
    styles = [LineElement(color = :black, linestyle = s) for s in linestyles]

    Legend(fig[2, 3],
    [LineElement(color = :black, linestyle = s) for s in linestyles],
    ["$i" for i in 1:4],
    "Result ID",
    nbanks = 2)
    return fig
end