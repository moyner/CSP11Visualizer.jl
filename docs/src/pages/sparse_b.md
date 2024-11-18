```@meta
EditURL = "../../../scripts/sparse_b.jl"
```

````@example sparse_b
using CSP11Visualizer, Gadfly # hide
results = CSP11Visualizer.parse_all_sparse(); # hide
nothing #hide
````

## Pressure in observation points

````@example sparse_b
set_default_plot_size(30cm, 20cm) # hide
````

### Pressure observation point 1
We can say something nice about this point.

````@example sparse_b
plot(results, x=:time, y=:P1, Geom.line, color = :groupresult) # hide
````

### Pressure observation point 2
We can say something nice about this point, too.

````@example sparse_b
plot(results, x=:time, y=:P2, Geom.line, color = :groupresult) # hide
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

