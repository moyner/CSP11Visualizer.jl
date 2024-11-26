using Documenter, DocumenterVitepress
using CSP11Visualizer, Literate


caseb = [
    # "Animation example" => "animation_b_example.md",
]
pagetree = [
        "Home" => "index.md",
        "Case B" => caseb
]

base_dir = realpath(joinpath(@__DIR__, ".."))
example_path(pth) = joinpath(base_dir, "scripts", "$pth.jl")
out_dir = joinpath(@__DIR__, "src", "pages")
do_build = true
build_all_dense = false

pages = [
    "Sparse results, all cases" => "sparse_b",
]

for (ex, pth) in pages
    in_pth = example_path(pth)
    if do_build
        push!(caseb, ex => joinpath("pages", "$pth.md"))
        Literate.markdown(in_pth, out_dir)
    end
end


if build_all_dense
    cases_b = CSP11Visualizer.available_dense_data("b")
else
    cases_b = Dict("SINTEF" => [1])
    # push!(pages, "SINTEF" => ["Result 1" => "dense_b_example"])
end

function replace_template(content, group_name, result_id)
    content = replace(content,
        "groupname = \"sintef\"" => "groupname = \"$group_name\"",
        "resultid = 1" => "resultid = $result_id"
    )
    return content
end

in_pth = example_path("dense_b_template")
if do_build
    for (group, results) in cases_b
        case_paths = []
        for result in results
            fn = "$(group)_$result"
            push!(case_paths, "Result $result" => joinpath("pages", "$fn.md"))
            replacer = (c) -> replace_template(c, group, result)
            Literate.markdown(in_pth, out_dir, name = fn, preprocess = replacer)
        end
        push!(case_paths, "$group" => case_paths)
    end
end

vitepress_fmt = DocumenterVitepress.MarkdownVitepress(
    repo = "https://github.com/moyner/spe11-plot-test",
    devurl = "dev",
    deploy_url = "moyner.github.io/spe11-plot-test"
)

documenter_fmt = Documenter.HTML(
    size_threshold = typemax(Int),
    prettyurls = false,
    example_size_threshold = typemax(Int),
    footer = "[11th SPE Comparative Solution Project](https://www.spe.org/en/csp/)",
)

fmt = documenter_fmt
# fmt = vitepress_fmt

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
