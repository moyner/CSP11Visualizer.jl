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

function read_file(pth; resample = false)
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
    return (t = time/uyear,
            p1 = p1, p2 = p2,
                A = (mob = mobA, imm=immA, diss=dissA, seal=sealA),
                B = (mob = mobB, imm=immB, diss=dissB, seal=sealB),
            M = M, sealTot = sealTot, boundTot = boundTot)
end

function parse_all_sparse(pth = realpath(joinpath(@__DIR__, "..", "..", "data")); case = "b")
    groups = readdir(pth)
    results = Dict{String, Any}()
    for group in groups
        gdata = Dict{Int, Any}()
        casepath = joinpath(pth, group, "spe11$case")
        for dir in readdir(casepath)
            @info "Reading $group: $dir"
            gdata[parse(Int64, dir[end])] = read_file(joinpath(casepath, dir, "spe11$(case)_time_series.csv"))
        end
        if length(keys(gdata)) > 0
            results[group] = gdata
        end
    end
    return results
end
