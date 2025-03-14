module CSP11Visualizer
    using CSV, DataFrames, GLMakie, WGLMakie, CairoMakie, Gadfly, Jutul
    export plot_sparse

    function default_data_path(type = "dense")
        basepath = realpath(joinpath(@__DIR__, "..", "..", "data"))
        overridepath = joinpath(basepath, "path.txt")
        if isfile(overridepath)
            f = open(overridepath)
            basepath = strip(readline(f))
            close(f)
            @assert ispath(basepath)
        end
        if ispath(joinpath(basepath, type))
            basepath = joinpath(basepath, type)
        end
        return basepath
    end

    function canonical_shortname(name)
        if name == "kiel"
            return "CAU-Kiel"
        else
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
            @assert !isnothing(pos) "Unknown participant $name"
            return canonical[pos]
        end
    end
    include("sparse.jl")
    include("dense.jl")
    include("movie.jl")
    include("mesh.jl")
end # module CSP11Visualizer
