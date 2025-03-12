# # Case C: HEADER
groupname = "opm" # hide
resultid = 1 # hide
using CSP11Visualizer, GLMakie, CairoMakie # hide
CairoMakie.activate!() # hide
steps = collect(0:5:1000) # hide
steps = [0, 5, 10, 15, 20, 25,
        30, 35, 40, 45, 50, 75,
        100, 150, 200, 300, 350,
        400, 450, 500, 600, 700,
        800, 900, 1000]
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, "c", steps = steps, verbose = false); # hide
sparse_results = CSP11Visualizer.parse_all_sparse(case = "c", active_result = resultid, active_groups = groupname) # hide
@assert only(unique(sparse_results[:, "group"])) == groupname # hide
@assert only(unique(sparse_results[:, "result"])) == resultid # hide
after_period = findfirst(isequal(30), steps) # hide
@assert !isnothing(after_period) # hide
end_of_injection = findfirst(isequal(50), steps) # hide
@assert !isnothing(end_of_injection) # hide
after_century = findfirst(isequal(100), steps) # hide
@assert !isnothing(after_century) # hide
end_of_migration = findfirst(isequal(1000), steps) # hide
@assert !isnothing(end_of_migration); # hide
##
using CSP11Visualizer.Jutul
mesh = CSP11Visualizer.get_mesh("c")
w1, w2 = CSP11Visualizer.get_wells("c")
fig = Figure()
ax = Axis3(fig[1, 1])
Jutul.plot_mesh_edges!(ax, mesh, alpha = 0.1)
lines!(ax, w1, color = :red, label = "W1")
lines!(ax, w2, color = :blue, label = "W2")
axislegend()
fig
##
I_cut = 84
J_cut = 50
fig = Figure(size = (2000, 800))
ijk = map(i -> cell_ijk(mesh, i), 1:number_of_cells(mesh))
I1 = findall(i -> i[1] == I_cut, ijk)
I2 = findall(i -> i[2] == J_cut, ijk)
fig = Figure()
ax = Axis3(fig[1, 1], title = "Plane 1: I = $I_cut")
Jutul.plot_mesh_edges!(ax, mesh, alpha = 0.1)
plot_mesh!(ax, mesh, cells = I1, color = :red)
ax = Axis3(fig[1, 2], title = "Plane 2: J = $J_cut")
Jutul.plot_mesh_edges!(ax, mesh, alpha = 0.1)
plot_mesh!(ax, mesh, cells = I2, color = :blue)
fig
##
CSP11Visualizer.plot_snapshot_c(results[after_period], :X_co2, I_cut, J_cut)