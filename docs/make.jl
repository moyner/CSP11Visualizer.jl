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


pages = [
    "Sparse B" => "sparse_b",
    "Dense B snapshot example" => "dense_b_example"
]

for (ex, pth) in pages
    in_pth = example_path(pth)
    if do_build
        push!(caseb, ex => joinpath("pages", "$pth.md"))
        Literate.markdown(in_pth, out_dir)
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
