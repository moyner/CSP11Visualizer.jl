using CSP11Visualizer
cases_b = CSP11Visualizer.available_dense_data("b")
for (group, v) in pairs(cases_b)
    for result in v
        println("$group result $result")
        CSP11Visualizer.parse_dense_timesteps(group, result, steps = [50]);
    end
end
##
CSP11Visualizer.parse_all_sparse(verbose=true, case = "a"); # hide
##
CSP11Visualizer.parse_all_sparse(verbose=true, case = "b"); # hide
##
CSP11Visualizer.parse_all_sparse(verbose=true, case = "c" );
