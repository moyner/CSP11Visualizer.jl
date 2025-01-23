const YEAR = 36*3600*24

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
    boundTot = df[:, 14]

    if resample
        time, new_tab = resample_table(time, (p1, p2, mobA, immA, dissA, sealA, mobB, immB, dissB, sealB, M, sealTot, boundTot))
        p1, p2, mobA, immA, dissA, sealA, mobB, immB, dissB, sealB, M, sealTot, boundTot = new_tab
    end
    return DataFrame(time = time/YEAR,
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

function parse_all_sparse(pth = default_data_path("sparse"); case = "b", verbose = false, merge = true)
    function maybe_print(x)
        if verbose
            println(x)
        end
    end

    groups = readdir(pth)
    results = Dict{String, Any}()
    for group in groups
        gdata = Dict{Int, Any}()
        casepath = joinpath(pth, group, "spe11$case")
        for dir in readdir(casepath)
            csv_name = "spe11$(case)_time_series.csv"
            if startswith(dir, "result")
                result_id = parse(Int64, dir[end])
                spth = joinpath(casepath, dir, csv_name)
            elseif dir == csv_name
                result_id = 1
                spth = joinpath(casepath, csv_name)
            else
                maybe_print("Skipping $dir...")
                continue
            end
            maybe_print("$group: Reading $spth")
            try
                gdata[result_id] = read_file(spth, group, result_id, case)
            catch excpt
                @error "$group $result_id failed to parse." excpt
                rethrow(excpt)
            end
        end
        if length(keys(gdata)) > 0
            results[group] = gdata
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

function get_group_color(group::String)
    canonical_group_order = [
        "calgary",
        "csiro",
        "ctc-cne",
        "delft-darts",
        "geos",
        "ifpen",
        "kfupm",
        "kiel",
        "opengosim",
        "opm",
        "pau-inria",
        "pnnl",
        "rice",
        "sintef",
        "slb",
        "stuttgart",
        "tetratech-rps",
        "ut-csee-pge"
    ]
    ix = findfirst(isequal(group), canonical_group_order)
    if isnothing(ix)
        ix = length(canonical_group_order) + 1
    end
    cmap = Makie.to_colormap(:tab20)
    return cmap[ix]
end

function plot_sparse(results, k::Symbol)
    kstr = "$k"
    if k == :P1 || k == :P2
        ylabel = "Pascal"
        title = "Pressure at observation point $k"
    elseif k == :mobA || k == :mobB
        ylabel = "kg"
        title = "Mobile CO2 in region $(kstr[4])"
    elseif k == :dissA || k == :dissB
        ylabel = "kg"
        title = "Dissolved CO2 in region $(kstr[5])"
    elseif k == :immA || k == :immB
        ylabel = "kg"
        title = "Immobile CO2 in region $(kstr[4])"
    elseif k == :sealA || k == :sealB
        ylabel = "kg"
        title = "CO2 in seal in region $(kstr[5])"
    elseif k == :sealTot
        ylabel = "kg"
        title = "CO2 in seal"
    elseif k == :boundTot
        ylabel = "kg"
        title = "CO2 in bound"
    else
        ylabel = ""
        title = "$k"
    end
    fig = Figure(size = (1200, 600))
    ax = Axis(fig[1, 1:3], xlabel = "Time (years)", ylabel = ylabel, title = title)
    linestyles = [:solid, :dot, :dash, :dashdot]
    groups = unique(results[:, "group"])
    ngroups = length(groups)
    plts = []
    @time for (gno, group) in enumerate(groups)
        group_result = filter(row -> row.group == "$group", results)

        for resultid in 1:4
            subresult = filter(row -> row.groupresult == "$(group)$resultid", group_result)
            x = subresult[!, :time]
            if length(x) == 0
                continue
            end
            y = subresult[!, k]
            c = get_group_color(group)

            plt = lines!(ax, x, y, color = c, label = group, linestyle = linestyles[resultid])
            if resultid == 1
                push!(plts, plt)
            end
            @info "Plotting $group $resultid" size(subresult)
        end
    end
    Legend(fig[2, 1:2], plts, groups, orientation = :horizontal, nbanks = 3)
    # data = 
    # :solid (equivalent to nothing), :dot, :dash, :dashdot
    styles = [LineElement(color = :black, linestyle = s) for s in linestyles]

    Legend(fig[2, 3],
    [LineElement(color = :black, linestyle = s) for s in linestyles],
    ["Result $i" for i in 1:4],
    nbanks = 2)
    return fig
end