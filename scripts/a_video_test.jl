groupname = "opm" # hide
resultid = 4 # hide
using CSP11Visualizer, GLMakie
GLMakie.activate!() # hide
steps = collect(0:1:120) # hide
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, "a", steps = steps, verbose = true); # hide
##
sparse_results = CSP11Visualizer.parse_all_sparse(case = "a", active_result = resultid, active_groups = groupname)
@assert only(unique(sparse_results[:, "group"])) == groupname
@assert only(unique(sparse_results[:, "result"])) == resultid
##
# using CSP11Visualizer.Jutul

CSP11Visualizer.make_movie_casea(steps, results, sparse_results, filename = "sg.mp4") # hide
