module CSP11Visualizer
    using CSV, DataFrames, GLMakie, WGLMakie, CairoMakie, Gadfly, Jutul
    export plot_sparse

    function default_data_path(type = "dense")
        basepath = realpath(joinpath(@__DIR__, "..", "..", "data"))
        overridepath = joinpath(basepath, "path.txt")
        if isfile(overridepath)
            f = open(overridepath)
            basepth = strip(readline(f))
            close(f)
            @assert ispath(basepth)
        end
        if ispath(joinpath(basepath, type))
            basepth = joinpath(basepath, type)
        end
        return basepth
    end
    include("sparse.jl")
    include("dense.jl")
    include("mesh.jl")
end # module CSP11Visualizer
