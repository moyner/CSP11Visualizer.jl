using Documenter, DocumenterVitepress

using CSP11Visualizer, Literate


caseb = []
pagetree = [
        "Home" => "index.md",
        "Case B" => caseb
    ]

base_dir = realpath(joinpath(@__DIR__, ".."))
example_path(pth) = joinpath(base_dir, "scripts", "$pth.jl")
out_dir = joinpath(@__DIR__, "src", "pages")
do_build = true


pages = ["Sparse B" => "sparse_b"]

for (ex, pth) in pages
    in_pth = example_path(pth)
    if do_build
        push!(caseb, ex => joinpath("examples", "$pth.md"))
        Literate.markdown(in_pth, out_dir)
    end
end

makedocs(;
    modules=[CSP11Visualizer],
    authors="SPE11 cool visualization team",
    repo="https://github.com/moyner/spe11-plot-test",
    sitename="SPE11",
    format=DocumenterVitepress.MarkdownVitepress(
        repo = "https://github.com/moyner/spe11-plot-test",
        devurl = "dev",
        deploy_url = "moyner.github.io/spe11-plot-test",
    ),
    pages = pagetree,
    warnonly = true,
)

deploydocs(;
    repo="github.com/moyner/spe11-plot-test",
    push_preview=true,
)
