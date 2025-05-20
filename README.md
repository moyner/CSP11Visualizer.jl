# CSP11Visualizer.jl

This is the source code to the [static site visualizer for the 11th SPE Comparative Solutions Project](https://moyner.github.io/SPE11-plot-test-deploy/index.html). For more details [see the website of the study.](https://www.spe.org/en/csp/spe11).

The source code is useful if you want to see how the [the visualizations in the page](https://moyner.github.io/SPE11-plot-test-deploy/index.html) were made, or if you want to make a version with your own simulation results included.

## Example visualization

Example from [spe11b/OPM4](https://moyner.github.io/SPE11-plot-test-deploy/pages/generated/dense_b/opm_4.html)
<video src="https://github.com/user-attachments/assets/f11b2ba1-7859-4584-ade0-329820ae4827"></video>

## Usage

Building this yourself requires installation of [Julia](https://julialang.org/downloads/). Note that if you are building on a remote/server machine you may have to use `xvfb-run julia` to avoid OpenGL errors as some of the underlying packages assume that a display is available.

### First time setup

Run julia from the docs folder:

```julia
cd docs/
julia --project=.
```

Develop the helper package, which should also install all other dependencies needed to build the project.

```julia
]dev ../CSP11Visualizer
```

Put the data in a folder under the root folder of the repository named `data`, or place the absolute path to the data folder in a textfile `data/path.txt`. The complete dataset of all submissions can be [downloaded from DOI 10.18419/DARUS-4750](https://doi.org/10.18419/DARUS-4750).

The resulting folder structure should look like this, taking IFPEN result 2 for case b as an example: `data/spe11b/ifpen2/`

### Building

There are two parts to getting the website built. First, you should generate the animations, and then you can build the entire website. Please note that the movies take a **long** time to build for all results and all participants.

```julia
include("generate_movies.jl")
include("build.jl")
```

### Building again

```julia
cd docs/
julia --project=.
```

and then

```julia
include("build.jl")
```

The resulting files will be in the `docs/build` folder and can be opened in a browser.

### Notes

Building the website for all the results in the benchmark takes a long time. The biggest culprit is the generation of movies, which is for this reason a separate build step. Here are some hints if you want to speed up build times.

- You can optionally skip the `generate_movies` - the website will still be be functional, but missing the movies.
- Both `generate_movies` and `build` can be edited to only publish specific cases. In either case this is done by setting `build_all_dense=false` at the top of the script and editing the `cases_*` variables to include the cases you want. If you just want to quickly test the build, the default configuration for `build_all_dense=false` is to build one participant result for each case (A/B/C).
- All pages that make plots are actually just templated scripts that can be run manually. They are found in `scripts`, together with some other experimental scripts that may or may not be useful. The built pages use `sparse_*_static.jl` and `dense_*_template.jl`. Building the actual webpages pages are reliant on finding and replacing `groupname = "opm"` and `resultid = 1` from these scripts, so manually editing these before building the page is not recommended.
