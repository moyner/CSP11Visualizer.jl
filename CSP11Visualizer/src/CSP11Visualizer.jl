module CSP11Visualizer
    using CSV, DataFrames, GLMakie, WGLMakie, CairoMakie, Gadfly

    function default_data_path(type = "dense")
        basepath = realpath(joinpath(@__DIR__, "..", "..", "data"))
        if type == "dense"
            pth = joinpath(basepath, "dense")
        elseif type == "sparse"
            pth = joinpath(basepath, "sparse")
        else
            @assert pth == "base"
            pth = basepth
        end
        return pth
    end
    include("sparse.jl")
    include("dense.jl")
end # module CSP11Visualizer
