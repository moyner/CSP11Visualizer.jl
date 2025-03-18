# # Case C: HEADER
groupname = "opm" # hide
resultid = 1 # hide
using CSP11Visualizer, GLMakie, CairoMakie # hide
using CSP11Visualizer.Jutul # hide
steps = [30, 50, 100, 1000] # hide
results = CSP11Visualizer.parse_dense_timesteps(groupname, resultid, "c", steps = steps, verbose = false); # hide
after_period = findfirst(isequal(30), steps) # hide
@assert !isnothing(after_period) # hide
end_of_injection = findfirst(isequal(50), steps) # hide
@assert !isnothing(end_of_injection) # hide
after_century = findfirst(isequal(100), steps) # hide
@assert !isnothing(after_century) # hide
end_of_migration = findfirst(isequal(1000), steps) # hide
@assert !isnothing(end_of_migration); # hide

# ## Overview animation

# INSERT_MOVIE_C

# ## Plot CO₂ liquid mass fractions in 3D
# A 3D plot of the CO2 mass fraction in the liquid phase is shown below. The
# cells in the reporting mesh have their transparency adjusted depending on the
# mass fraction of CO₂ in the liquid phase, with cells that have no CO₂ being
# completely transparent. This gives a good indication of the spatial
# distribution of CO₂.
GLMakie.activate!() # hide
mesh = CSP11Visualizer.get_mesh("c"); # hide
# ### 30 years: 5 years after start of second injector
CSP11Visualizer.plot_transparent_casec(results[after_period], "X_co2", mesh = mesh) # hide
# ### 50 years: End of injection
CSP11Visualizer.plot_transparent_casec(results[end_of_injection], "X_co2", mesh = mesh) # hide
# ### 100 years
CSP11Visualizer.plot_transparent_casec(results[after_century], "X_co2", mesh = mesh) # hide
# ### End of migration
CSP11Visualizer.plot_transparent_casec(results[end_of_migration], "X_co2", mesh = mesh) # hide

# ## Plot the cross sections used for plotting
# In the remainder of the plots, we will show cross sections of the model. The
# cross sections used for plotting are shown below. These cut the middle of the
# model in x and y directions. The red cross section corresponds to the plane
# where x = 4200m, and the blue cross section corresponds to the plane where y =
# 2500m.
I_cut, J_cut = CSP11Visualizer.case_c_ij_planes() # hide
fig = Figure(size = (2000, 800)) # hide
ijk = map(i -> cell_ijk(mesh, i), 1:number_of_cells(mesh)) # hide
I1 = findall(i -> i[1] == I_cut, ijk) # hide
I2 = findall(i -> i[2] == J_cut, ijk) # hide
fig = Figure() # hide
ax = Axis3(fig[1, 1], title = "Plane 1: x = 4200m") # hide
Jutul.plot_mesh_edges!(ax, mesh, alpha = 0.1) # hide
plot_mesh!(ax, mesh, cells = I1, color = :red) # hide
ax = Axis3(fig[1, 2], title = "Plane 2: y=2500m") # hide
Jutul.plot_mesh_edges!(ax, mesh, alpha = 0.1) # hide
plot_mesh!(ax, mesh, cells = I2, color = :blue) # hide
fig # hide
# ## CO₂ mass fraction in liquid
CairoMakie.activate!() # hide
# The mass fraction of CO₂ in the liquid phase is shown below.
# ### 30 years: 5 years after start of second injector
CSP11Visualizer.plot_snapshot_c(results[after_period], :X_co2) # hide
# ### 50 years: End of injection
CSP11Visualizer.plot_snapshot_c(results[end_of_injection], :X_co2) # hide
# ### 100 years
CSP11Visualizer.plot_snapshot_c(results[after_century], :X_co2) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot_c(results[end_of_migration], :X_co2) # hide
# ## Gas saturation
# The free gas volume fraction in the porous medium.
# ### 30 years:
CSP11Visualizer.plot_snapshot_c(results[after_period], :sg) # hide
# ### End of injection
CSP11Visualizer.plot_snapshot_c(results[end_of_injection], :sg) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot_c(results[after_century], :sg) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot_c(results[end_of_migration], :sg) # hide

# ## Water density
# The water density depends on the pressure, temperature and the amount of CO₂
# that has been dissolved in the water phase
# ### 30 years:
CSP11Visualizer.plot_snapshot_c(results[after_period], :denw) # hide
# ### End of injection
CSP11Visualizer.plot_snapshot_c(results[end_of_injection], :denw) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot_c(results[after_century], :denw) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot_c(results[end_of_migration], :denw) # hide

# ## Thermodynamic state variables
# ### Total mass of CO₂
# The total mass of CO₂ in kilograms per cell is shown below. This is the
# absolute mass of CO₂ and indicates where the CO₂ is located in the domain.
# ### 30 years
CSP11Visualizer.plot_snapshot_c(results[after_period], :co2mass) # hide
# #### 50 years: End of injection
CSP11Visualizer.plot_snapshot_c(results[end_of_injection], :co2mass) # hide
# #### 100 years
CSP11Visualizer.plot_snapshot_c(results[after_century], :co2mass) # hide
# #### 1000 years: End of migration
CSP11Visualizer.plot_snapshot_c(results[end_of_migration], :co2mass) # hide

# ### Pressure
# The reported pressure in Pascal is shown below. This is the pressure of the
# water phase.
# #### 30 years
CSP11Visualizer.plot_snapshot_c(results[after_period], :pw) # hide
# #### 50 years: End of injection
CSP11Visualizer.plot_snapshot_c(results[end_of_injection], :pw,) # hide
# #### 100 years
CSP11Visualizer.plot_snapshot_c(results[after_century], :pw) # hide
# #### 1000 years: End of migration
CSP11Visualizer.plot_snapshot_c(results[end_of_migration], :pw) # hide

# ### Temperature
# The reported temperature in degrees Celsius is shown below.
# #### 30 years:
CSP11Visualizer.plot_snapshot_c(results[after_period], :T) # hide
# #### 50 years: End of injection
CSP11Visualizer.plot_snapshot_c(results[end_of_injection], :T) # hide
# #### 100 years:
CSP11Visualizer.plot_snapshot_c(results[after_century], :T) # hide
# #### 1000 years: End of migration
CSP11Visualizer.plot_snapshot_c(results[end_of_migration], :T) # hide

# ## H₂O mass fraction in vapor
# A small amount of H₂O can vaporize into the gas phase. The mass fraction of H₂O
# in the gas phase is shown below.
# ### 30 years:
CSP11Visualizer.plot_snapshot_c(results[after_period], :Y_h2o) # hide
# ### End of injection
CSP11Visualizer.plot_snapshot_c(results[end_of_injection], :Y_h2o) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot_c(results[after_century], :Y_h2o) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot_c(results[end_of_migration], :Y_h2o) # hide

# ## Gas density
# The gas density depends only on pressure and temperature in this model.
# ### 30 years:
CSP11Visualizer.plot_snapshot_c(results[after_period], :deng) # hide
# ### End of injection
CSP11Visualizer.plot_snapshot_c(results[end_of_injection], :deng) # hide
# ### 100 years:
CSP11Visualizer.plot_snapshot_c(results[after_century], :deng) # hide
# ### End of migration
CSP11Visualizer.plot_snapshot_c(results[end_of_migration], :deng) # hide
#
function clear_module!(M::Module)        # hide
    if M == Main                         # hide
        return                           # hide
    end                                  # hide
    for name ∈ names(M, all=true)        # hide
        if !isconst(M, name)             # hide
            @eval M $name = $nothing     # hide
        end                              # hide
    end                                  # hide
end                                      # hide
clear_module!(@__MODULE__)               # hide
GC.gc();                                 # hide
