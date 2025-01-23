using Documenter
using CSP11Visualizer, Literate

# TODO list
# - Match colors between dynamic and static sparse plots
# - Make sure that we have high quality static sparse plots
# - Some kind of video template at the top of the page that plots two quantities together
# - Check if interactivity works for WGL - would be really cool
# - SPE11C plots - cross sections
# - Make colormaps consistent across all plots

# Olav's notes
# - Some results appear to have low resolution (in for example water density).
#   This is because some results use fixed precision like in the description
#   and others use additional digits. Not much we can do about this unless we
#   want to truncate and make all plots equally bad.
# - ctc-cne doesn't plot correctly - check.
#
# May need to spin up webserver to fix XSS protection in chrome for local previews:
# SPE11-plot-test\docs\build> python3 -m http.server 9000

do_build = true
build_all_dense = false

case_a = [

]

case_b = [

]

case_c = [
    # "Animation example" => "animation_b_example.md",
]
pagetree = [
        "CSP11" => "index.md",
        "Case A" => case_a,
        "Case B" => case_b,
        "Case C" => case_c
]

base_dir = realpath(joinpath(@__DIR__, ".."))
example_path(pth) = joinpath(base_dir, "scripts", "$pth.jl")
out_dir = joinpath(@__DIR__, "src", "pages", "generated")
mkpath(out_dir)
# Clean up generated files
foreach(rm, filter(endswith(".md"), readdir(out_dir, join=true)))


function publish_examples(dest, paths)
    for (ex, pth) in paths
        in_pth = example_path(pth)
        if do_build
            push!(dest, ex => joinpath("pages", "generated", "$pth.md"))
            Literate.markdown(in_pth, out_dir)
        end
    end
    return dest
end


pages_a = [
    "Sparse measurables, all groups" => "sparse_a_static",
]

publish_examples(case_a, pages_a)

pages_b = [
    "Sparse measurables, all groups" => "sparse_b_static",
]

publish_examples(case_b, pages_b)

pages_c = [
    "Sparse measurables, all groups" => "sparse_c_static",
]

publish_examples(case_c, pages_c)


if build_all_dense
    cases_b = CSP11Visualizer.available_dense_data("b")
else
    # cases_b = Dict()
    cases_b = Dict("sintef" => [1])
    # cases_b = Dict("kiel" => [1])
end

function replace_template(content, group_name, result_id)
    content = replace(content,
        "groupname = \"sintef\"" => "groupname = \"$group_name\"",
        "resultid = 1" => "resultid = $result_id"
    )
    return content
end

in_pth = example_path("dense_b_template")
out_dir_b = joinpath(@__DIR__, "src", "pages", "generated", "dense_b")
mkpath(out_dir_b)
# Delete old files
foreach(rm, filter(endswith(".md"), readdir(out_dir_b, join=true)))
if do_build
    caseb_dense = []
    push!(case_b, "Dense results" => caseb_dense)
    for (group, results) in cases_b
        case_paths = []
        for result in results
            fn = "$(group)_$result"
            replacer = (c) -> replace_template(c, group, result)
            Literate.markdown(in_pth, out_dir_b, name = fn, preprocess = replacer)
            push!(case_paths, "Result $result" => joinpath("pages", "generated", "dense_b", "$fn.md"))
        end
        push!(caseb_dense, "$group" => case_paths)
    end
end

documenter_fmt = Documenter.HTML(
    size_threshold = typemax(Int),
    prettyurls = false,
    example_size_threshold = typemax(Int),
    footer = "[11th SPE Comparative Solution Project](https://www.spe.org/en/csp/)",
)

fmt = documenter_fmt

makedocs(;
    modules=[CSP11Visualizer],
    authors="SPE11 cool visualization team",
    repo="https://github.com/moyner/spe11-plot-test",
    sitename="SPE11",
    format=fmt,
    pages = pagetree,
    warnonly = true,
)
##
deploydocs(;
    repo="github.com/moyner/spe11-plot-test",
    push_preview=true,
)
##
tmp = read(joinpath(@__DIR__, "build", "index.html"), String)
tmp = replace(tmp, "Search docs (Ctrl + /)" => "Search site")
write(joinpath(@__DIR__, "build", "index.html"), tmp)
