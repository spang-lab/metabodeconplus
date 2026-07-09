# Bin a spectra-like object into a feature matrix

Bins the per-spectrum signal vector left-to-right into chunks of
`maxCombine` chemical-shift columns and returns the per-bin sums as a
feature matrix. Columns whose chemical-shift falls inside any `igrs`
interval are removed before binning.

Accepts three input types:

- `spectra`: uses `x[[i]]$si` directly.

- `decons2`: uses `x[[i]]$sit$sup` (smoothed reconstruction).

- `aligns`: builds a sparse vector from `lcpar$pcial` / `lcpar$A * pi`,
  then bins.

Suitable as the `feat_fun` argument of
[`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
for binning baselines.

## Usage

``` r
bin(x, maxCombine = 128, igrs = list(), peakPos = NULL, ...)
```

## Arguments

- x:

  A `spectra`, `decons2` or `aligns` object.

- maxCombine:

  Bin width in chemical-shift columns.

- igrs:

  List of two-element ppm intervals to ignore.

- peakPos:

  Optional integer column indices for predict mode; when `NULL` the
  non-zero bins are kept and attached as `attr(., "peakPos")`.

- ...:

  Ignored (protocol compatibility with peak_mat).

## Value

A numeric matrix with one row per spectrum and one column per bin.
