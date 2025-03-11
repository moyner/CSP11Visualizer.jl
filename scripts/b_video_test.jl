groupname = "opm" # hide
resultid = 4 # hide
using CSP11Visualizer, GLMakie
GLMakie.activate!() # hide
steps = collect(0:5:1000)
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, steps = steps, verbose = true); # hide
##
sparse_results = CSP11Visualizer.parse_all_sparse(case = "b", active_result = resultid, active_groups = groupname)
@assert only(unique(sparse_results[:, "group"])) == groupname
@assert only(unique(sparse_results[:, "result"])) == resultid
##
# using CSP11Visualizer.Jutul

CSP11Visualizer.make_movie_caseb(steps, results, sparse_results, filename = "sg.mp4") # hide
