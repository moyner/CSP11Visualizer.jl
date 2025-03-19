# First time setup

Run julia from the docs folder:

```julia
cd docs/
julia --project=.
```

Develop the helper package:

```julia
]dev ../
```

Put the data in a folder under the root folder of the repository named `data`, or place the absolute path to the data folder in a textfile `data/path.txt`.

## Building

```julia
include("build.jl")
```

## Building again

```julia
cd docs/
julia --project=.
```

and then

```julia
include("build.jl")
```
The resulting files will be in the `docs/build` folder and can be opened in a browser.
