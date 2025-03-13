using CSP11Visualizer

build_all_dense = false
if build_all_dense
    cases_a = CSP11Visualizer.available_dense_data("a")
    cases_b = CSP11Visualizer.available_dense_data("b")
    cases_c = CSP11Visualizer.available_dense_data("c")
else
    # cases_a = Dict()
    # cases_b = Dict()
    # cases_c = Dict()
    cases_a = Dict("opm" => [1])
    cases_b = Dict("opm" => [1])
    cases_c = Dict("opm" => [1])
end

function build_for_case(cases, caseletter)
    @assert caseletter in ["a", "b", "c"]
    println("Processing case $caseletter")
    num = 0
    for (group, results) in cases
        num += length(results)
    end
    println("Found $num results")
    pos = 1
    for (group, results) in cases
        println("Processing group $group ($pos/$num)")
        for resultid in results
            println("Processing result $resultid")
            t = @elapsed mpth = CSP11Visualizer.make_website_movie(group = group, resultid = resultid, case = caseletter)
            println("Result $resultid written to $mpth in $(round(t,digits=3)) seconds")
            pos += 1
        end
    end
end

## Case A
build_for_case(cases_a, "a")
## Case B
build_for_case(cases_b, "b")
## Case C
build_for_case(cases_c, "c")
