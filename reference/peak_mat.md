# Peak feature matrix

Thin wrapper around
[`si_mat()`](https://spang-lab.github.io/metabodeconplus/reference/si_mat.md)
suitable as the `feat_fun` argument of
[`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md).
Equivalent to `si_mat(x, igrs=igrs)`; the snapping that used to live
here has moved into
[`align()`](https://spang-lab.github.io/metabodeconplus/reference/align.md)
(reference-snapping stage).

## Usage

``` r
peak_mat(x, igrs = list(), peakPos = NULL, ...)
```

## Arguments

- x:

  An `aligns` object (or `decons2`).

- igrs:

  List of two-element ppm intervals to ignore.

- peakPos:

  Optional integer column indices, forwarded to
  [`si_mat()`](https://spang-lab.github.io/metabodeconplus/reference/si_mat.md)
  for predict mode.

- ...:

  Ignored. Accepted so `peak_mat` and
  [`bin()`](https://spang-lab.github.io/metabodeconplus/reference/bin.md)
  share a single `feat_fun(x, maxCombine, igrs)` protocol; `peak_mat`
  ignores `maxCombine` because snapping happens upstream inside
  [`align()`](https://spang-lab.github.io/metabodeconplus/reference/align.md).

## Value

A numeric matrix with spectra in rows and chemical shifts as colnames.

## Author

2024-2026 Tobias Schmidt: initial version.
