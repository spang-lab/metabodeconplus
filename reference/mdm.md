# Metabodecon Models

**\[experimental\]**

Fit (`fit_mdm()`) or cross-validate (`benchmark()`) a binary
classification model built on a set of NMR spectra. Both run the full
deconvolute -\> align -\> snap -\> featurize -\> fit pipeline with
sensible defaults and expose only the parameters a typical user tunes;
the classification backend is chosen via `model`. Power users who need
to swap individual pipeline stages can call the internal engines
`metabodeconplus:::fit_mdm_internal()` /
`metabodeconplus:::benchmark_internal()`, which take pluggable
`decon_fun` / `align_fun` / `snap_fun` / `feat_fun` / `fit_fun` /
`predict_fun` arguments.

`fit_mdm()` runs the pipeline once, or iterates over the cartesian
product of `npmax` / `maxShift` / `maxCombine` when any is a vector and
returns the row with the highest `acc` (ties broken by `auc`).
`benchmark()` wraps `fit_mdm()` in outer k-fold cross-validation to
estimate end-to-end performance on held-out spectra.

## Usage

``` r
fit_mdm(
  x,
  y,
  model = c("lasso", "ranger"),
  npmax = -1L,
  maxShift = -1L,
  maxCombine = 10L,
  nworkers = 1L,
  seed = 1L,
  verbosity = 1L,
  ...
)

benchmark(
  x,
  y,
  model = c("lasso", "ranger"),
  npmax = -1L,
  maxShift = -1L,
  maxCombine = 10L,
  nworkers = 1L,
  seed = 1L,
  verbosity = 2L,
  k = 3L,
  ...
)
```

## Arguments

- x:

  Spectra object.

- y:

  Factor vector with class labels for each spectrum.

- model:

  Classification backend. One of `"lasso"` (default, L1-penalised
  logistic regression via `glmnet`) or `"ranger"` (probability random
  forest).

- npmax:

  Max peaks per spectrum. Integer in `{-2, -1, 0, 1, ...}`, scalar or
  vector. `-1` (default) selects the median per-spectrum Kneedle elbow;
  `-2` selects each spectrum's own elbow.

- maxShift:

  Max CluPA shift in datapoints. Integer \>= -1, scalar or vector. `-1`
  (default) means auto (sweep to the alignment-correlation dip).

- maxCombine:

  RefPA snap window in datapoints. Integer, scalar or vector. Default
  10.

- nworkers:

  Number of workers for deconvolution, alignment and the inner fitter.

- seed:

  Random seed. Forwarded to the fitter; also used for stratified fold
  assignment inside `benchmark()`. May be a vector for repeated CV.

- verbosity:

  Verbosity level.

- ...:

  Further arguments passed on to the internal engine
  (`metabodeconplus:::fit_mdm_internal()` /
  `metabodeconplus:::benchmark_internal()`), e.g. `sfr`, `igrs`, `deg`,
  `use_rust`. Rarely needed.

- k:

  Number of outer folds for `benchmark()`.

## Value

`fit_mdm()` returns an object of class `mdm` with elements `model`
(trained backend model of the best grid row), `ref` (a list
`list(align, snap)` for prediction-time replay), `params` (resolved
pipeline parameters of the best row), the scalar performance of the best
row (`acc`, `auc`, `acc_se`, `auc_se`), and `mog` (the augmented grid
with per-row performance).

`benchmark()` returns a list with elements `models` (one fitted model
per outer fold), `predictions` (per-spectrum out-of-fold predictions),
`performance` (per-fold `acc` / `auc`) and `overall` (pooled `acc` /
`auc`).

## Examples

``` r
if (FALSE) { # \dontrun{
  x <- sim2
  y <- attr(sim2, "group")
  m  <- fit_mdm(x, y)                     # lasso, full pipeline
  mr <- fit_mdm(x, y, model="ranger")     # random forest
  bm <- benchmark(x, y, k=5)              # 5-fold CV
  fm <- fit_mdm(
      x, y, model="ranger",
      npmax=25L, maxShift=c(0L, 1L, 2L, 4L, 8L),
      maxCombine=c(0L, 1L, 2L, 4L), nworkers=4L
  )
} # }
```
