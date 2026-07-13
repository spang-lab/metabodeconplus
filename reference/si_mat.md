# Signal-integral matrix

Builds a per-spectrum peak-area matrix. Each row is a spectrum, each
column is a chemical-shift datapoint. For each peak, the column is
picked from `lcpar$pcisn` (post-snap) when available, else `lcpar$pcial`
(post-CluPA), else `lcpar$pcide` (post-decon). Peaks with `pcisn = NA`
(snapped beyond `maxCombine`) are skipped. Collisions on the same column
have their `A * pi` summed.

`si_mat()` is intentionally a dumb peak-list rasterizer: all alignment
(continuous shift via CluPA) and reference snapping must have happened
upstream — typically inside
[`align()`](https://spang-lab.github.io/metabodeconplus/reference/align.md).
To build a feature matrix where every spectrum shares the same column
grid, run `align(x, maxShift, maxCombine)` first.

## Usage

``` r
si_mat(x, drop_zero = FALSE, igrs = list(), peakPos = NULL, ...)
```

## Arguments

- x:

  A `decons2` or `aligns` object.

- drop_zero:

  Drop columns whose entries are all zero?

- igrs:

  List of two-element ppm intervals to zero out before returning.

- peakPos:

  Optional integer column indices. When supplied (predict mode) the
  matrix is subset to those columns; when `NULL` and used as a
  `feat_fun` the non-zero columns are kept and attached as
  `attr(., "peakPos")`.

- ...:

  Ignored (protocol compatibility with other `feat_fun`s).

## Value

A numeric matrix with one row per spectrum and `length(x[[1]]$cs)`
columns (the full cs grid). Column names are ppm values; row names are
spectrum names.

## Author

2024-2026 Tobias Schmidt: initial version.

## Examples

``` r
if (FALSE) { # \dontrun{
  decons <- deconvolute(sim[1:2], sfr=c(3.55, 3.35))
  aligned <- align(decons, maxShift=50, maxCombine=20)
  X <- si_mat(aligned)
} # }
```
