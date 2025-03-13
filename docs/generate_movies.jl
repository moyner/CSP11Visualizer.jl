using CSP11Visualizer

build_all_dense = true
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

function build_for_case(cases, caseletter; throw = false)
    @assert caseletter in ["a", "b", "c"]
    println("Processing case $caseletter")
    failures = []
    num = 0
    gnum = 0
    for (group, results) in cases
        num += length(results)
        gnum += 1
    end
    println("Found $num results")
    pos = 1
    gpos = 1
    for (group, results) in cases
        println("$group (group $gpos/$gnum) starting...")
        for resultid in results
            println("Result $resultid/$(length(results)) ($pos of $num total results for spe11$caseletter) processing")
            try
                t = @elapsed mpth = CSP11Visualizer.make_website_movie(group = group, resultid = resultid, case = caseletter)
                println("Result $resultid written to $mpth in $(round(t,digits=3)) seconds")
            catch excpt
                if throw
                    rethrow(excpt)
                end
                println("Failed to process $group $resultid: $excpt")
                push!(failures, (group, resultid, "$excpt"))
            end
            pos += 1
        end
        gpos += 1
    end
    return failures
end

## Case A
failures_a = build_for_case(cases_a, "a")
## Case B
failures_b = build_for_case(cases_b, "b")
## Case C
failures_c = build_for_case(cases_c, "c")
