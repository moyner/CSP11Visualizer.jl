# Animation example

We can generate animations from any of the data and embed in the static webpage.

Will probably be a big website...

```@example
using CSP11Visualizer
results = CSP11Visualizer.parse_dense_timesteps("sintef", 1)
CSP11Visualizer.make_movie(results, "gas_saturation", "Gas saturation", filename = "sg.mp4")
```

```@raw html
<video autoplay loop muted playsinline controls src="./sg.mp4" />
```
