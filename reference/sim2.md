# The Sim2 Classification Dataset

A simulated two-group classification dataset for demonstrating
[`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
and
[`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md).
It contains 100 simulated 1D NMR spectra split evenly into groups `A`
and `B`, where 3 out of 25 peaks per spectrum differ between the groups:
in group `A`, two peaks are scaled by `1.25` and one peak by `1/1.25`
(\\\approx 0.80\\). Group `B` is left unmodified. The first spectrum
(`sim2_001`) is constructed without any global or per-peak ppm jitter so
it can serve as a clean unshifted alignment reference.

## Usage

``` r
sim2
```

## Format

A `spectra` object consisting of 100 `spectrum` objects, where each
spectrum contains 2048 datapoints ranging from 3.59 to 3.28 ppm. The
per-spectrum group labels are attached as `attr(sim2, "group")`, a named
factor with levels `A` and `B`. For details about `spectrum` and
`spectra` objects see
[metabodeconplus-classes](https://spang-lab.github.io/metabodeconplus/reference/metabodeconplus-classes.md).

Each spectrum's `meta$simpar` carries the standard fields (`x0`, `A`,
`lambda`, `noise`) plus five sim2-specific fields: `base_x0` (the 25
reference peak positions, identical across spectra), `dx0` (per-peak
jitter in ppm), `gx0` (scalar global ppm shift), `diff_AB` (integer
indices into `base_x0` of the peaks that differ between groups), and
`ab_factors` (the multiplicative factors applied to those peaks in group
A). They satisfy `x0[k] = base_x0[k] + dx0[k] + gx0`.

`attr(sim2, "true_x0")` is a numeric vector with the post-alignment ppm
positions of the discriminating peaks (one per `diff_AB` index), useful
for highlighting them on plots of aligned feature matrices.

## Details

Peak parameters (positions, areas, half-widths and noise) were chosen to
match the values recovered by deconvoluting the
[sim](https://spang-lab.github.io/metabodeconplus/reference/sim.md)
dataset, which itself is derived from the Blood reference dataset (see
[sim](https://spang-lab.github.io/metabodeconplus/reference/sim.md)).
Concretely:

- 25 base peaks per spectrum with positions drawn uniformly in
  `[3.37, 3.52]` ppm. The reference-grid step is `0.00015 ppm/dp`.

- Per-peak jitter with standard deviation 4 datapoints (\\\approx
  0.00060\\ ppm) plus a per-spectrum global ppm shift with standard
  deviation 8 datapoints (\\\approx 0.00120\\ ppm) to mimic chemical
  shift variation between samples.

- Base areas drawn from a log-normal distribution centered around `2500`
  (in ppm-area units) and varied per spectrum by `+/-60%`.

- Base half-widths drawn uniformly in `[0.0009, 0.0013]` ppm and varied
  per spectrum by `+/-10%`.

- Gaussian noise with standard deviation `2200`.

- In group `A`, three base peaks (indices `simpar$diff_AB`) have their
  areas multiplied by `c(1.25, 1.25, 1/1.25)` (stored in
  `simpar$ab_factors`). Group `B` is left unmodified. Spectrum
  `sim2_001` is generated with `dx0 = 0` and `gx0 = 0` to provide a
  clean unshifted alignment reference.
