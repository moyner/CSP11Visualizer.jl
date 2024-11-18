module CSP11Visualizer
    using CSV, DataFrames, CairoMakie, Gadfly

    default_data_path() = realpath(joinpath(@__DIR__, "..", "..", "data"))
    include("sparse.jl")
    include("dense.jl")
end # module CSP11Visualizer
