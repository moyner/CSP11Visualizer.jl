module CSP11Visualizer
    using CSV, DataFrames, GLMakie, WGLMakie, CairoMakie, Gadfly, Jutul
    export plot_sparse

    function default_data_path(case = nothing)
        basepath = realpath(joinpath(@__DIR__, "..", "..", "data"))
        overridepath = joinpath(basepath, "path.txt")
        if isfile(overridepath)
            f = open(overridepath)
            basepath = strip(readline(f))
            close(f)
            @assert ispath(basepath)
        end
        if !isnothing(case)
            @assert case in ["a", "b", "c"]
            basepath = joinpath(basepath, "spe11$case")
            @assert ispath(basepath) "Expected $basepath to be a valid directory"
        end
        return basepath
    end

    function canonical_shortname(name)
        canonical = [
            "Calgary",
            "CAU-Kiel",
            "CSIRO",
            "CTC-CNE",
            "DARTS",
            "GEOS",
            "IFPEN",
            "KFUPM",
            "OpenGoSim",
            "OPM",
            "Pau-Inria",
            "PFLOTRAN",
            "Rice",
            "SINTEF",
            "SLB",
            "Stuttgart",
            "TetraTech",
            "UT-CSEE",
        ]
        pos = findfirst(isequal(name), lowercase.(canonical))
        if isnothing(pos)
            println("Unknown/new participant $name... Using name as-is. If you want special formatting for this entry and get rid of this message, add your case to `canonical_shortname`")
            out = name
        else
            out = canonical[pos]
        end
        return out
    end
    include("sparse.jl")
    include("dense.jl")
    include("movie.jl")
    include("mesh.jl")
end # module CSP11Visualizer
