# Animation example

We can generate animations from any of the data and embed in the static webpage.

Will probably be a big website...

```@example movie
using CSP11Visualizer  # hide
results = CSP11Visualizer.parse_dense_timesteps("sintef", 2) # hide
CSP11Visualizer.make_movie(results, "gas_saturation", "Gas saturation", filename = "sg.mp4") # hide
CSP11Visualizer.make_movie(results, "phase_mass_density_water_kg_m3", "Water saturation", filename = "denw.mp4") # hide
```

## Gas saturation for one result

```@raw html
<video autoplay loop muted playsinline controls src="./sg.mp4" />
```

## Water density for one result

```@raw html
<video playsinline controls src="https://spe.widen.net/view/video/ie51w02dyz/speVideo.mp4?u=krg3sb" />
```
