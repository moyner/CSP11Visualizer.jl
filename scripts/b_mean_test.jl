using CSP11Visualizer


function is_dense_data(k, x)
    is_ok = !(k in ["x", "y", "z"])
    is_num = x isa AbstractArray && eltype(x) == Float64
    return is_ok && is_num
end

function get_averaged_results(step)
    # Start off with some data that doesn't include NaN
    firstname = "sintef"
    avg_result = CSP11Visualizer.parse_dense_timesteps(firstname, 1, "b", steps = [step])[1]; # hide
    n = 1
    for (groupname, results) in CSP11Visualizer.available_dense_data("b")
        for resultid in results
            if groupname == firstname && resultid == 1
                continue
            end
            next = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, "b", steps = [step])[1];
            for (key, val) in next
                if is_dense_data(key, val)
                    val[isnan.(val)] .= 0
                    avg_result[key] .+= val
                end
            end
            n += 1
        end
    end
    for (key, val) in avg_result
        if is_dense_data(key, val)
            val ./= n
        end
    end
    @info "$n results added."
    return avg_result
end


stepno = 1000
result = get_averaged_results(stepno);
##

function get_std_results(avg, step)
    # Start off with some data that doesn't include NaN
    firstname = "sintef"
    avg_result = CSP11Visualizer.parse_dense_timesteps(firstname, 1, "b", steps = [step])[1]; # hide
    std_result = Dict()
    for (key, val) in avg_result
        if is_dense_data(key, val)
            std_result[key] = zeros(size(val))
        end
    end
    n = 0
    for (groupname, results) in CSP11Visualizer.available_dense_data("b")
        for resultid in results
            next = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, "b", steps = [step])[1];
            for (key, val) in next
                if is_dense_data(key, val)
                    @info "Adding $key" norm(avg_result[key])
                    val[isnan.(val)] .= 0
                    std_result[key] .+= (val - avg_result[key]).^2
                end
            end
            n += 1
        end
    end
    for (key, val) in avg_result
        if is_dense_data(key, val)
            @. val = sqrt(val./n)
        end
    end
    return avg_result
end

result_std = get_std_results(result, stepno)
##
CSP11Visualizer.plot_snapshot(result, :co2mass) # hide
##
CSP11Visualizer.plot_snapshot(result_std, :co2mass, use_clims = false) # hide
##
CSP11Visualizer.plot_snapshot(result, :denw) # hide
##
CSP11Visualizer.plot_snapshot(result_std, :denw, use_clims = false) # hide
##
CSP11Visualizer.plot_snapshot(result, :sg) # hide
##
CSP11Visualizer.plot_snapshot(result_std, :sg, use_clims = false) # hide
##
