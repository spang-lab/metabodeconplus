# Alignment building blocks

Pluggable alignment stages used by
[`align()`](https://spang-lab.github.io/metabodeconplus/reference/align.md)
and the `align_fun` argument of
[`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
/
[`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md).

- `clupa()`: **CluPA** — hierarchical-clustering peak alignment
  (recursive FFT segment shifts, Beirnaert et al. 2018, Vu et al. 2011).
  Operates on the Lorentz reconstruction `sit$sup` already attached to
  each spectrum by deconvolution.

- `snap_to_ref()`: **RefPA** — reference-based peak alignment: snap each
  peak to the nearest reference column within `maxCombine`.

All these functions require every input spectrum to share the same `$cs`
grid; an explicit [`stop()`](https://rdrr.io/r/base/stop.html) is raised
otherwise. Call
[`harmonize_grid()`](https://spang-lab.github.io/metabodeconplus/reference/harmonize_grid.md)
upstream to enforce that invariant.

`snap_to_ref()` applies the RefPA step on its own: for each peak in each
spectrum, finds the nearest reference column on the shared `cs` grid and
records that column as `pcisn` (and its ppm value as `x0sn`). Peaks
farther than `maxCombine` columns from every reference column get
`pcisn = NA` / `x0sn = NA`. Original `x0`, `x0al`, `A`, `lambda`,
`pcide` and `pcial` are preserved — RefPA only *adds* the snapped
fields. Collisions on the same `pcisn` column are not merged here;
[`si_mat()`](https://spang-lab.github.io/metabodeconplus/reference/si_mat.md)
sums their areas when rasterising the feature matrix. `sit$supal` is
cleared because the post-snap superposition would need recomputing.

## Usage

``` r
clupa(
  x,
  y = NULL,
  ref = NULL,
  maxShift = 50,
  verbose = TRUE,
  nworkers = 1,
  full = TRUE,
  use_speaq = FALSE,
  gap_tol = NULL
)

snap_to_ref(x, ref = NULL, maxCombine = 20, ...)
```

## Arguments

- x:

  A `decons2` or `aligns` object.

- y:

  Optional factor of class labels. Unused by the default pipeline;
  accepted for signature compatibility.

- ref:

  Optional reference spectrum (`align` or `decon2`). When `NULL`, chosen
  internally.

- maxShift:

  Maximum CluPA shift in datapoints.

- verbose:

  Print progress messages?

- nworkers:

  Number of parallel workers.

- full:

  If `TRUE` also recompute the aligned superposition.

- use_speaq:

  Use
  [`speaq::hClustAlign`](https://rdrr.io/pkg/speaq/man/hClustAlign.html)
  (CluPA only).

- gap_tol:

  Optional gap tolerance in ppm; only consulted by experimental snap
  backends.

- maxCombine:

  Maximum RefPA snap distance in datapoints.

- ...:

  Ignored.

## Value

An object of class `aligns`.
