function get_mesh(case::String)
    if case == "c"
        mesh = UnstructuredMesh(CartesianMesh((168, 100, 120), (8400.0, 5000.0, 1200.0)))
        T = eltype(mesh.node_points)
        for (i, pt) in enumerate(mesh.node_points)
            mesh.node_points[i] = transform_c(pt)
        end
        return mesh
    else
        error("Case $c is not yet implemented")
    end
end

function transform_c(pt::T) where T
    u, v, w = pt
    return T(u, v, w + 150*(1 - ((v - 2500.0)/2500.0)^2) + v/500.0)
end

function get_wells(case::String, n = 100)
    if case == "c"
        #  (2700, 1000, 300), far end (2700, 4000, 300)
        # (5100, 1000, 700), far end (5100, 4000, 700)
        T = Jutul.StaticArrays.SVector{3, Float64}
        w1 = collect(range(T(2700, 1000, 300), T(2700, 4000, 300), length = n))
        w2 = collect(range(T(5100, 1000, 700), T(5100, 4000, 700), length = n))
        w2 = map(transform_c, w2)
        return (w1, w2)
    else
        error("Case $c is not yet implemented")
    end
end