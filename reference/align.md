# Align deconvoluted spectra

Aligns peaks across a set of deconvoluted spectra by chaining two
stages:

1.  **CluPA**
    ([`clupa()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md))
    shifts peak centers continuously toward a reference using
    hierarchical-clustering FFT segment shifts (Beirnaert et al. 2018,
    Vu et al. 2011). Adds `x0al` and `pcial` (post-CluPA center and
    column index) to each peak; original `x0`, `A`, `lambda`, `pcide`
    are preserved.

2.  **RefPA**
    ([`snap_to_ref()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md))
    records, for each peak, the nearest reference column within
    `maxCombine` as `pcisn` / `x0sn`. Peaks farther than `maxCombine`
    from every reference column get `pcisn = NA` / `x0sn = NA`. No peaks
    are dropped and amplitudes are not summed here — collisions on the
    same `pcisn` are aggregated downstream by
    [`si_mat()`](https://spang-lab.github.io/metabodeconplus/reference/si_mat.md).

All spectra in `x` must already live on the same chemical-shift grid
(identical `$cs` vector across spectra). Call
[`harmonize_grid()`](https://spang-lab.github.io/metabodeconplus/reference/harmonize_grid.md)
upstream if your inputs come from different acquisitions with slight
calibration offsets.

## Usage

``` r
align(
  x,
  y = NULL,
  ref = NULL,
  maxShift = 50,
  maxCombine = 0,
  verbose = TRUE,
  nworkers = 1,
  full = TRUE,
  use_speaq = FALSE,
  gap_tol = NULL
)
```

## Arguments

- x:

  A `decons2` (or `aligns`) object.

- y:

  Optional factor of class labels (length `length(x)`). Unused by the
  default pipeline; accepted for signature compatibility.

- ref:

  Optional reference spectrum (`align` or `decon2`). When `NULL`
  (default) the reference is chosen internally.

- maxShift:

  Maximum number of datapoints a peak center may be shifted by CluPA.
  `maxShift = 0L` skips CluPA (sets `x0al = x0`).

- maxCombine:

  Maximum snap distance for RefPA in chemical-shift columns.
  `maxCombine = 0L` skips RefPA (no snapping). A negative value is
  treated as `maxShift`.

- verbose:

  Print progress messages?

- nworkers:

  Number of parallel workers.

- full:

  If `TRUE` also recompute the aligned superposition during CluPA. RefPA
  always drops `sit$supal` (the post-snap peak list is no longer
  Lorentz-compatible).

- use_speaq:

  Use
  [`speaq::hClustAlign`](https://rdrr.io/pkg/speaq/man/hClustAlign.html)
  instead of the bundled CluPA implementation. Defaults to `FALSE`; the
  bundled implementation is byte-equivalent to the speaq one (see
  `tests/testthat/test-speaq.R`).

- gap_tol:

  Optional gap tolerance in ppm. `NULL` (default) uses the standard
  CluPA + RefPA pipeline; only consulted by experimental snap backends.

## Value

An object of class `aligns`.

## Author

2024-2026 Tobias Schmidt: initial version.

## Examples

``` r
if (FALSE) { # \dontrun{
  decons <- deconvolute(sim[1:5], sfr=c(3.55, 3.35))
  aligned <- align(decons, maxShift=50, maxCombine=20)
} # }
```
