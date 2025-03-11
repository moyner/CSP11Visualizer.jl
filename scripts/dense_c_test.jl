using CSP11Visualizer, GLMakie
groupname = "opm"
resultid = 4

steps = [1000]
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, "c", steps = steps, verbose = false); # hide
##
result = results[end]

x = result["x"]
y = result["y"]
z = result["z"]

val = result["denw"]

volume(vec(x), vec(y), vec(z), vec(val))
##
GLMakie.activate!()
volume(val)

# volume(x, y, z, val)
## 
a = rand(10, 10, 10)
x = 1:10
y = 1:10
z = 1:10
volume((0, 1.0), (0, 1.0), (0, 1.0), a)

