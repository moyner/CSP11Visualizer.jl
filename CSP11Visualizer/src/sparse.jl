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
    df = CSV.read(pth, DataFrame)

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
    uyear = 365.0*3600*24.0
    return DataFrame(time = time/uyear,
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

function parse_all_sparse(pth = default_data_path("sparse"); case = "b", merge = true)
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
                println("Skipping $dir...")
                continue
            end
            println("$group: Reading $spth")
            try
                gdata[result_id] = read_file(spth, group, result_id, case)
            catch excpt
                @error "$group $result_id failed to parse." excpt
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
