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

Put the data in data/sparse and data/dense.

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
