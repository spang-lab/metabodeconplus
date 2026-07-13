# Metabodecon Classes and Helpers

Metabodecon represents NMR data using a small set of S3 classes
connected by **cumulative inheritance**. A raw spectrum has class
`"spectrum"`. After
[`deconvolute()`](https://spang-lab.github.io/metabodeconplus/reference/deconvolute.md)
it gains class `"decon2"`, so its class vector becomes
`c("decon2", "spectrum")`. After
[`align()`](https://spang-lab.github.io/metabodeconplus/reference/align.md)
it gains class `"align"`, with class vector
`c("align", "decon2", "spectrum")`. The corresponding collection classes
follow the same pattern.

Every deconvoluted or aligned object is still a `spectrum` in the
[`base::inherits()`](https://rdrr.io/r/base/class.html) sense, so S3
generic behavior for `spectrum` or `spectra` also works at every stage.
Element order may vary between versions; always access fields by name,
e.g. `x$si` or `x[["cs"]]`. Elements marked optional may be absent or
`NULL`.

## Usage

``` r
is_spectrum(x)
is_spectra(x)
as_spectra(x, ...)
as_decon2(x)
as_decons2(x)
get_names(x, default = "spectrum_\045d")
```

## Arguments

- x:

  A metabodeconplus object, collection, list of objects, or path.

- default:

  Used by `get_names()` when no object names are present.

- ...:

  Parameters passed to
  [`read_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/read_spectrum.md)
  when `x` is a path.

## Value

`is_spectrum()` and `is_spectra()` return `TRUE` or `FALSE`. The
`as_*()` functions return an object of the requested class.
`get_names()` returns a character vector.

## Singlet classes

- `spectrum`: A single NMR spectrum. Class vector: `"spectrum"`.
  Constructed by
  [`read_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/read_spectrum.md),
  [`make_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/make_spectrum.md),
  or
  [`simulate_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/simulate_spectrum.md).
  Carries the fields under *Always present (spectrum)* below.

- `decon2`: A single deconvoluted NMR spectrum. Class vector:
  `c("decon2", "spectrum")`. Produced by
  [`deconvolute()`](https://spang-lab.github.io/metabodeconplus/reference/deconvolute.md).
  In addition to the `spectrum` fields, a `decon2` carries the *Added by
  deconvolute()* fields below.

- `align`: A single deconvoluted NMR spectrum whose peak positions have
  been aligned across a collection. Class vector:
  `c("align", "decon2", "spectrum")`. Produced by
  [`align()`](https://spang-lab.github.io/metabodeconplus/reference/align.md).
  Carries everything a `decon2` does, plus the *Added by align()* fields
  below.

## Collection classes

For each singlet class there is a collection class that wraps a list of
those singlets:

- `spectra`: List of `spectrum`. Class vector `"spectra"`.

- `decons2`: List of `decon2`. Class vector `c("decons2", "spectra")`.

- `aligns`: List of `align`. Class vector
  `c("aligns", "decons2", "spectra")`.

Collections inherit from `"spectra"`, so generic methods written for
`spectra` also work on `decons2` and `aligns`. Constructed by
[`read_spectra()`](https://spang-lab.github.io/metabodeconplus/reference/read_spectra.md)
(returns `spectra`),
[`deconvolute()`](https://spang-lab.github.io/metabodeconplus/reference/deconvolute.md)
when given a `spectra` (returns `decons2`), and
[`align()`](https://spang-lab.github.io/metabodeconplus/reference/align.md)
(returns `aligns`). Concatenation follows the cumulative rule: the
result class is the most-general, least-specific class among the inputs.
Mixing an `align` with a plain `decon2` yields `decons2`; mixing any
plain `spectrum` in yields `spectra`.

## Always present (spectrum)

1.  `cs`: Vector of chemical shifts in ppm. Same length as `si`.

2.  `si`: Vector of signal intensities (au). `si[i]` is the intensity at
    `cs[i]`.

3.  `meta`: Optional list of metadata, e.g. `name` (spectrum name),
    `path` (source path), `type` (experiment type), `fq` (signal
    frequencies in Hz), `mfs` (magnetic field strength), or `simpar`
    (true Lorentz-curve parameters for simulated spectra).

## Added by deconvolute()

A `decon2` object additionally has:

1.  `args`: List of deconvolution parameters used (`nfit`, `smit`,
    `smws`, `delta`, `sfr`, `igrs`, `npmax`, `use_rust`, `verbose`).

2.  `sit`: Data frame of signal intensities after transformations: `sm`
    (smoothed), `sup` (superposition of fitted Lorentz curves), and
    `supal` (superposition of aligned Lorentz curves, added by
    [`align()`](https://spang-lab.github.io/metabodeconplus/reference/align.md)).

3.  `peak`: Data frame of peak triplets with columns `center`, `left`,
    `right`: integer indices into `cs`.

4.  `lcpar`: Data frame of Lorentz-curve parameters. Always carries `x0`
    (center in ppm), `A` (amplitude), `lambda` (half-width) and `pcide`
    (integer column index into `cs` for `x0`). After
    [`clupa()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md)
    also `x0al` / `pcial` (post-CluPA center and cs index). After
    [`snap_to_ref()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md)
    also `x0sn` / `pcisn` (post-snap center and cs index, with `NA` for
    peaks snapped beyond `maxCombine`). `A` and `lambda` are preserved
    through every stage.

## Added by align()

An `align` object has the same fields as `decon2`, but with the
alignment slots populated:

- `lcpar$x0al`: Peak Centers after CluPA alignment in ppm

- `lcpar$pcial`: Peak Centers after CluPA alignment as `cs` indices

- `lcpar$x0sn`: Peak Centers after reference snapping in ppm (NA when
  snapped out)

- `lcpar$pcisn`: Peak Centers after reference snapping as `cs` indices
  (NA when snapped out)

- `sit$supal`: Signal Intensities of the superposition of aligned
  Lorentz curves

## Predicates

`is_spectrum()` and `is_spectra()` test inheritance from the base
metabodeconplus classes. Since `decon2` and `align` inherit from
`spectrum`, and `decons2` and `aligns` inherit from `spectra`, they
satisfy these checks. To test for a specific lifecycle stage, use
[`base::inherits()`](https://rdrr.io/r/base/class.html) directly, e.g.
`inherits(x, "decon2")` or `inherits(x, "aligns")`.

## Converters

`as_spectra()` turns a path, `spectrum`, or list of `spectrum` objects
into a `spectra` collection. `as_decon2()` and `as_decons2()` are
identity converters that validate their input.

## Naming helpers

`get_names()` returns collection names by checking each element's
metadata, each element's direct `name`, the list names, and finally
generated default names.

## Author

2024-2025 Tobias Schmidt: initial version.

## Examples

``` r
s <- sim[[1]]
inherits(s, "spectrum")
#> [1] TRUE
is_spectrum(s)
#> [1] TRUE

d <- deconvolute(s, sfr = c(3.55, 3.35))
#> 2026-07-13 07:00:17.38 Starting deconvolution (spectra: 1, workers: 1)
#> 2026-07-13 07:00:17.38 Starting deconvolution of sim_01 using R backend
#> 2026-07-13 07:00:17.38 Starting peak selection
#> 2026-07-13 07:00:17.38 Detected 312 peaks
#> 2026-07-13 07:00:17.38 Removing peaks with low scores
#> 2026-07-13 07:00:17.38 Removed 285 peaks
#> 2026-07-13 07:00:17.38 Fitting Lorentz curves (3 iterations)
#> 2026-07-13 07:00:17.38 Finished deconvolution of sim_01
#> 2026-07-13 07:00:17.38 Finished deconvolution 0.004 secs
class(d) # c("decon2", "spectrum")
#> [1] "decon2"   "spectrum"
inherits(d, "spectrum") # TRUE
#> [1] TRUE

ds <- deconvolute(sim[1:3], sfr = c(3.55, 3.35))
#> 2026-07-13 07:00:17.39 Starting deconvolution (spectra: 3, workers: 1)
#> 2026-07-13 07:00:17.39 Starting deconvolution of sim_01 using R backend
#> 2026-07-13 07:00:17.39 Starting peak selection
#> 2026-07-13 07:00:17.39 Detected 312 peaks
#> 2026-07-13 07:00:17.39 Removing peaks with low scores
#> 2026-07-13 07:00:17.39 Removed 285 peaks
#> 2026-07-13 07:00:17.39 Fitting Lorentz curves (3 iterations)
#> 2026-07-13 07:00:17.39 Finished deconvolution of sim_01
#> 2026-07-13 07:00:17.39 Starting deconvolution of sim_02 using R backend
#> 2026-07-13 07:00:17.39 Starting peak selection
#> 2026-07-13 07:00:17.39 Detected 316 peaks
#> 2026-07-13 07:00:17.39 Removing peaks with low scores
#> 2026-07-13 07:00:17.39 Removed 286 peaks
#> 2026-07-13 07:00:17.39 Fitting Lorentz curves (3 iterations)
#> 2026-07-13 07:00:17.39 Finished deconvolution of sim_02
#> 2026-07-13 07:00:17.39 Starting deconvolution of sim_03 using R backend
#> 2026-07-13 07:00:17.39 Starting peak selection
#> 2026-07-13 07:00:17.39 Detected 333 peaks
#> 2026-07-13 07:00:17.39 Removing peaks with low scores
#> 2026-07-13 07:00:17.40 Removed 308 peaks
#> 2026-07-13 07:00:17.40 Fitting Lorentz curves (3 iterations)
#> 2026-07-13 07:00:17.40 Finished deconvolution of sim_03
#> 2026-07-13 07:00:17.40 Finished deconvolution 0.011 secs
class(ds)              # c("decons2", "spectra")
#> [1] "decons2" "spectra"
as_spectra(s)
#> spectra object with 1 spectrum elements:
#> sim_01: spectrum object (2048 dp, 3.6 to 3.3 ppm)
get_names(list(s, myspec = s))
#> [1] "sim_01" "sim_01"
```
