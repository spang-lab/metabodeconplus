# Harmonize a corpus of spectra onto a shared chemical-shift grid

Pre-aligns every spectrum in `x` to a single shared chemical-shift grid
by integer-datapoint shifting. After the call, every spectrum's `$cs` is
bit-identical to the chosen target grid, so downstream code
(deconvolution,
[`clupa()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md),
[`snap_to_ref()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md),
feature-matrix builders) can index everyone by datapoint and treat `cs`
as a single shared variable.

All input spectra must share the same point count and the same ppm width
(calibration offsets are allowed, frequency-domain resolution
differences are not). For each spectrum the integer offset from the
target grid is computed in datapoints, `$si` is rolled by that many
positions, the vacated edge is filled with `pad` (default `0`), and
`$cs` is replaced by the target grid.

This kills the per-spectrum absolute-calibration offset between
acquisitions (typically a constant shift in ppm coming from spectrometer
reference setup) so that downstream CluPA only has to correct the
remaining sub-datapoint residual + the random chemical-shift drift from
sample composition.

Sub-datapoint residual: at most ±0.5 datapoint per spectrum, which is
two orders of magnitude smaller than typical Lorentzian peak widths
(lambda ~ 1e-3 to 1e-2 ppm vs. spacing ~ 1e-4 ppm), so the rounding
error is irrelevant for any downstream fit.

Edge handling: a spectrum that needs to shift right by `k` datapoints
loses `k` datapoints from one end and gains `k` `pad` values on the
other. For typical NMR spectra the edges are noise, so zero-padding is
equivalent to dropping the noise — no real signal is harmed. For large
absolute shifts (tens of datapoints) you can verify the discarded region
is noise by inspecting `$cs` against the metabolite range of interest.

## Usage

``` r
harmonize_grid(x, target = "median", pad = 0)
```

## Arguments

- x:

  A `spectra` object (or list of `spectrum` objects).

- target:

  Either `"median"` (default) — anchor the target grid at the median
  first-ppm across `x` — or a numeric vector of length
  `length(x[[1]]$cs)` giving an explicit target grid.

- pad:

  Numeric scalar used to fill the vacated edge after the shift. Default
  `0`. Use `NA` if you want downstream code to detect the borrowed
  region explicitly.

## Value

A `spectra` object with every spectrum's `$cs` replaced by the target
grid and `$si` shifted accordingly. All other fields (`$meta`, `$lcpar`,
`$sit`, ...) are preserved unchanged.

## Author

2026 Tobias Schmidt: initial version.

## Examples

``` r
if (FALSE) { # \dontrun{
  aki <- metabodeconplus:::read_aki_data()
  x   <- harmonize_grid(aki$spectra)
  all(sapply(x, function(s) identical(s$cs, x[[1]]$cs)))  # TRUE
} # }
```
