# Deconvolute one or more NMR spectra

Deconvolutes NMR spectra by modeling each detected signal within a
spectrum as Lorentz Curve.

Returns the default grid of `(nfit, smit, smws, delta)` combinations
used by `deconvolute()` when `npmax >= 1`. Useful as the `deg` argument
to
[`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md).

## Usage

``` r
deconvolute(
  x,
  nfit = 3,
  smit = 2,
  smws = 5,
  delta = 6.4,
  npmax = 0,
  sfr = NULL,
  igrs = list(),
  use_rust = FALSE,
  verbose = TRUE,
  nworkers = 1
)

get_deg(conf = "default")
```

## Arguments

- x:

  A `spectrum` or `spectra` object as described in
  [metabodeconplus-classes](https://spang-lab.github.io/metabodeconplus/reference/metabodeconplus-classes.md).

- nfit:

  Integer. Number of iterations for approximating the parameters for the
  Lorentz curves. See 'Details'.

- smit:

  Integer. Number of smoothing iterations. See 'Details'.

- smws:

  Integer. Smoothing window size (number of data points; must be odd).
  See 'Details'.

- delta:

  Threshold for peak filtering. Higher values result in more peaks being
  filtered out. A peak is filtered if its score is below \\\mu + \sigma
  \cdot \delta\\, where \\\mu\\ is the average peak score in the
  signal-free region (SFR), and \\\sigma\\ is the standard deviation of
  peak scores in the SFR. See 'Details'.

- npmax:

  Integer scalar in `{-2, -1, 0, 1, 2, ...}` controlling how
  `(nfit, smit, smws, delta)` are chosen. If `npmax >= 1`, those four
  arguments are ignored and a grid search over predefined parameter
  combinations is performed instead — the combination with the smallest
  residual area ratio and fewer than `npmax` peaks is selected. Grid
  search results are cached to disk automatically. `npmax = 0` (default)
  disables the grid search and uses the literal
  `(nfit, smit, smws, delta)` arguments. `npmax = -1` is "auto":
  resolved up front to a single integer (the median per-spectrum Kneedle
  elbow on `$deg`) and broadcast to every spectrum. `npmax = -2` is
  "intrinsic": resolved per spectrum to that spectrum's own Kneedle
  elbow, so different spectra get different `npmax` values.

- sfr:

  Numeric vector with two entries: the ppm positions for the left and
  right border of the signal-free region of the spectrum. See 'Details'.

- igrs:

  Ignore regions. List of length-2 numeric vectors specifying the start
  and endpoints of the chemical shift regions to ignore during
  deconvolution. Peaks whose centers fall inside any ignore region are
  excluded from fitting.

- use_rust:

  Controls the deconvolution backend. `FALSE` or any numeric value `< 1`
  (default) uses the R implementation. `TRUE` or any numeric value
  `>= 1` uses the Rust backend via
  [mdrb](https://github.com/spang-lab/mdrb). `NULL` auto-detects: uses
  Rust if available, otherwise R. When set to `TRUE` / `>= 1` and mdrb
  is not installed, an error is thrown.

- verbose:

  Logical. Whether to print log messages during the deconvolution
  process.

- nworkers:

  Number of workers to use for parallel processing. If `"auto"`, the
  number of workers will be determined automatically. If a number
  greater than 1, it will be limited to the number of spectra.

- conf:

  Character string selecting a configuration. Currently only `"default"`
  is supported.

## Value

A 'decon2' object as described in
[metabodeconplus-classes](https://spang-lab.github.io/metabodeconplus/reference/metabodeconplus-classes.md).

A data frame with columns `nfit`, `smit`, `smws`, `delta`.

## Details

First, an automated curvature based signal selection is performed. Each
signal is represented by 3 data points to allow the determination of
initial Lorentz curves. These Lorentz curves are then iteratively
adjusted to optimally approximate the measured spectrum.

## Author

2024-2025 Tobias Schmidt: initial version.

## Examples

``` r
## Deconvolute a single spectrum
spectrum <- sim[[1]]
decon <- deconvolute(spectrum)
#> 2026-07-09 09:09:51.40 Starting deconvolution (spectra: 1, workers: 1)
#> 2026-07-09 09:09:51.40 Starting deconvolution of sim_01 using R backend
#> 2026-07-09 09:09:51.40 Starting peak selection
#> 2026-07-09 09:09:51.40 Detected 312 peaks
#> 2026-07-09 09:09:51.40 Removing peaks with low scores
#> 2026-07-09 09:09:51.40 Removed 285 peaks
#> 2026-07-09 09:09:51.40 Fitting Lorentz curves (3 iterations)
#> 2026-07-09 09:09:51.40 Finished deconvolution of sim_01
#> 2026-07-09 09:09:51.40 Finished deconvolution 0.007 secs

## Read multiple spectra from disk and deconvolute at once
spectra_dir <- metabodeconplus_file("sim_subset")
spectra <- read_spectra(spectra_dir)
decons <- deconvolute(spectra, sfr = c(3.55,3.35))
#> 2026-07-09 09:09:51.41 Starting deconvolution (spectra: 2, workers: 1)
#> 2026-07-09 09:09:51.41 Starting deconvolution of sim_01 using R backend
#> 2026-07-09 09:09:51.41 Starting peak selection
#> 2026-07-09 09:09:51.41 Detected 312 peaks
#> 2026-07-09 09:09:51.41 Removing peaks with low scores
#> 2026-07-09 09:09:51.42 Removed 285 peaks
#> 2026-07-09 09:09:51.42 Fitting Lorentz curves (3 iterations)
#> 2026-07-09 09:09:51.42 Finished deconvolution of sim_01
#> 2026-07-09 09:09:51.42 Starting deconvolution of sim_02 using R backend
#> 2026-07-09 09:09:51.42 Starting peak selection
#> 2026-07-09 09:09:51.42 Detected 316 peaks
#> 2026-07-09 09:09:51.42 Removing peaks with low scores
#> 2026-07-09 09:09:51.42 Removed 286 peaks
#> 2026-07-09 09:09:51.42 Fitting Lorentz curves (3 iterations)
#> 2026-07-09 09:09:51.42 Finished deconvolution of sim_02
#> 2026-07-09 09:09:51.42 Finished deconvolution 0.008 secs
get_deg()
#>    nfit smit smws delta
#> 1    10    1    3   1.6
#> 2    10    2    3   1.6
#> 3    10    3    3   1.6
#> 4    10    1    5   1.6
#> 5    10    2    5   1.6
#> 6    10    3    5   1.6
#> 7    10    1    7   1.6
#> 8    10    2    7   1.6
#> 9    10    3    7   1.6
#> 10   10    1    9   1.6
#> 11   10    2    9   1.6
#> 12   10    3    9   1.6
#> 13   10    1    3   3.2
#> 14   10    2    3   3.2
#> 15   10    3    3   3.2
#> 16   10    1    5   3.2
#> 17   10    2    5   3.2
#> 18   10    3    5   3.2
#> 19   10    1    7   3.2
#> 20   10    2    7   3.2
#> 21   10    3    7   3.2
#> 22   10    1    9   3.2
#> 23   10    2    9   3.2
#> 24   10    3    9   3.2
#> 25   10    1    3   4.8
#> 26   10    2    3   4.8
#> 27   10    3    3   4.8
#> 28   10    1    5   4.8
#> 29   10    2    5   4.8
#> 30   10    3    5   4.8
#> 31   10    1    7   4.8
#> 32   10    2    7   4.8
#> 33   10    3    7   4.8
#> 34   10    1    9   4.8
#> 35   10    2    9   4.8
#> 36   10    3    9   4.8
#> 37   10    1    3   6.4
#> 38   10    2    3   6.4
#> 39   10    3    3   6.4
#> 40   10    1    5   6.4
#> 41   10    2    5   6.4
#> 42   10    3    5   6.4
#> 43   10    1    7   6.4
#> 44   10    2    7   6.4
#> 45   10    3    7   6.4
#> 46   10    1    9   6.4
#> 47   10    2    9   6.4
#> 48   10    3    9   6.4
#> 49   10    1    3   8.0
#> 50   10    2    3   8.0
#> 51   10    3    3   8.0
#> 52   10    1    5   8.0
#> 53   10    2    5   8.0
#> 54   10    3    5   8.0
#> 55   10    1    7   8.0
#> 56   10    2    7   8.0
#> 57   10    3    7   8.0
#> 58   10    1    9   8.0
#> 59   10    2    9   8.0
#> 60   10    3    9   8.0
```
