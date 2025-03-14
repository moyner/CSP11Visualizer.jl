using Documenter
using CSP11Visualizer, Literate
import CSP11Visualizer: canonical_shortname
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
cd(@__DIR__)

do_build = true
build_all_dense = true

case_a = Any[
    "pages/casea.md"
]

case_b = Any[
    "pages/caseb.md"
]

case_c = Any[
    "pages/casec.md"
]
participants = []
group_names = [
    "calgary",
    "kiel",
    "csiro",
    "ctc-cne",
    "darts",
    "geos",
    "ifpen",
    "kfupm",
    "opengosim",
    "opm",
    "pau-inria",
    "pflotran",
    "rice",
    "sintef",
    "slb",
    "stuttgart",
    "tetratech",
    "ut-csee"
]
for g in group_names
    push!(participants, canonical_shortname(g) => "pages/groups/$g.md")
end
pagetree = [
        "CSP11" => [
            "index.md",
            "pages/groups.md",
            "Participants" => participants
        ],
        "Case A" => case_a,
        "Case B" => case_b,
        "Case C" => case_c
]

base_dir = realpath(joinpath(@__DIR__, ".."))
example_path(pth) = joinpath(base_dir, "scripts", "$pth.jl")
out_dir = joinpath(@__DIR__, "src", "pages", "generated")
mkpath(out_dir)
for caseletter in ["a", "b", "c"]
    casepth = joinpath(out_dir, "dense_$caseletter")
    moviedir = CSP11Visualizer.movie_directory(caseletter)
    mkpath(casepth)
    for fn in readdir(moviedir)
        if endswith(fn, ".mp4")
            cp(joinpath(moviedir, fn), joinpath(casepth, fn), force = true)
        end
    end
end

# Clean up generated files
foreach(rm, filter(endswith(".md"), readdir(out_dir, join=true)))


function publish_examples(dest, paths)
    for (ex, pth) in paths
        in_pth = example_path(pth)
        if do_build
            push!(dest, ex => joinpath("pages", "generated", "$pth.md"))
            Literate.markdown(in_pth, out_dir, credit = false)
        end
    end
    return dest
end


pages_a = Any[
    "Sparse measurables, all groups" => "sparse_a_static",
]

publish_examples(case_a, pages_a)

pages_b = Any[
    "Sparse measurables, all groups" => "sparse_b_static",
]

publish_examples(case_b, pages_b)

pages_c = Any[
    "Sparse measurables, all groups" => "sparse_c_static",
]

publish_examples(case_c, pages_c)


if build_all_dense
    cases_a = CSP11Visualizer.available_dense_data("a")
    cases_b = CSP11Visualizer.available_dense_data("b")
    cases_c = CSP11Visualizer.available_dense_data("c")

else
    cases_a = Dict()
    cases_b = Dict()
    cases_c = Dict()
    cases_a = Dict("opm" => [1])
    # cases_b = Dict("opm" => [1])
    # cases_c = Dict("opm" => [1])
    # cases_b = Dict("kiel" => [1])
end
##
function replace_template(content, case, group_name, result_id, s)
    can_group_name = canonical_shortname(group_name)
    content = replace(content,
        "groupname = \"$s\"" => "groupname = \"$group_name\"",
        "HEADER" => "$can_group_name result $result_id",
        "INSERT_GROUPLINK" => "These results were submitted by $can_group_name. For more information about $can_group_name and how the simulations were performed, see the [$can_group_name group page](../../groups/$group_name.html).",
        "resultid = 1" => "resultid = $result_id"
    )
    return content
end

function replace_post(content, case, group_name, result_id)
    @assert case in ["a", "b", "c"]
    content = replace(content, "INSERT_MOVIE_$(uppercase(case))" => "````@raw html\n"*"<video autoplay loop muted playsinline controls>\n<source src=\"./movie$(case)_$(group_name)_$result_id.mp4\" type=\"video/mp4\"/>\n</video>\n"*"````\n")
    return content
end

function copy_template(dest, case, cases_to_plot, default)
    in_pth = example_path("dense_$(case)_template")
    outdir_case = joinpath(@__DIR__, "src", "pages", "generated", "dense_$case")
    mkpath(outdir_case)
    # Delete old files
    foreach(rm, filter(endswith(".md"), readdir(outdir_case, join=true)))
    if do_build
        case_dense = []
        push!(dest, "Dense results" => case_dense)
        for (group, results) in cases_to_plot
            case_paths = []
            for result in results
                fn = "$(group)_$result"
                replacer = (c) -> replace_template(c, case, group, result, default)
                post_replacer = c -> replace_post(c, case, group, result)
                Literate.markdown(in_pth, outdir_case, name = fn, preprocess = replacer, postprocess = post_replacer, credit = false)
                push!(case_paths, "$group: Result $result" => joinpath("pages", "generated", "dense_$case", "$fn.md"))
            end
            if length(case_paths) == 1
                case_dir = case_paths[1][2]
            else
                case_dir = case_paths
            end
            push!(case_dense, canonical_shortname("$group") => case_dir)
        end
    end
end

copy_template(case_a, "a", cases_a, "opm")
copy_template(case_b, "b", cases_b, "opm")
copy_template(case_c, "c", cases_c, "opm")

documenter_fmt = Documenter.HTML(
    size_threshold = typemax(Int),
    prettyurls = false,
    example_size_threshold = typemax(Int),
    footer = "[11th SPE Comparative Solution Project](https://www.spe.org/en/csp/)",
)

fmt = documenter_fmt

makedocs(;
    modules=[CSP11Visualizer],
    authors="Olav Møyner",
    repo="https://github.com/moyner/spe11-plot-test",
    sitename="SPE CSP11 results",
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
