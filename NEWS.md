# metabodeconplus 0.22.1

* Improvement: make `calc_prarp()` clamp both scores at zero, so `prarp` and `prarpx` stay in `[0, 1]`. Practically irrelevant, because the residual is never bigger than the spectrum area for any reasonable deconvolution, but makes the implementation match the theoretical formulation.

# metabodeconplus 0.22.0

* CRAN resubmission addressing the review of 0.21.0, which still saw changes
  of `options()` and `par()` without an appropriate reset in `R/plot.R` and
  `R/util.R`. No user-facing API changes.

* Removed the private multi-figure helpers `set_fig()` and `local_fig()`.
  `set_fig()` changed `par(fig=, new=)` and returned a reset function that its
  two callers registered via `on.exit()` / `withr::defer()`, so the reset sat
  in a different function than the `par()` call it reverts. That logic now
  lives in `with_fig()` and in `draw_spectrum()`, which change `par()` and
  register the restoring `on.exit()` handler in the same function, before
  `par()` is touched. Plot output is unchanged.

* Removed the unused private helper `catft()`, which permanently set the
  `metabodeconplus.catft.time` option, and dropped the equally unused
  `options(metabodeconplus.aki_cache=)` assignment from `.onLoad()`. The
  package no longer sets any global option that outlives a function call.

# metabodeconplus 0.21.0

* `fit_mdm()` and `benchmark()` now default to `model = "ranger"` (probability
  random forest) instead of `"lasso"`. Ranger is the intended default published
  model; pass `model = "lasso"` for the L1-penalised logistic-regression
  backend.
* `ranger` moved from Suggests to Imports: it is the default model backend, so
  it is now a hard dependency and its availability is no longer checked
  conditionally. `speaq` moved from Imports to Suggests, since it is only used
  by the non-default `align(use_speaq = TRUE)` path.
* CRAN resubmission addressing the review of 0.20.2. No user-facing API
  changes beyond the removal of `install_mdrb()` / `check_mdrb_deps()`.
    * Removed the exported `install_mdrb()` and `check_mdrb_deps()` functions:
      packages must not install other packages (CRAN policy). The optional
      Rust backend `mdrb` is now purely user-installed. When
      `deconvolute(use_rust >= 1)` is requested but `mdrb` is missing,
      `check_mdrb()` stops with an error that prints the exact
      `install.packages("mdrb", repos = "https://spang-lab.r-universe.dev")`
      command and links to <https://github.com/spang-lab/mdrb>.
    * Documentation examples no longer use `\dontrun{}`: runnable examples on
      the public `sim` / `sim2` datasets are now unwrapped or wrapped in
      `\donttest{}`, and no example uses more than two cores.
    * Removed the `metabodeconplus:::` (triple-colon) references from the
      `harmonize_grid()` and `fit_mdm()` / `benchmark()` documentation.
    * No longer set `options(warn = -1)` anywhere (removed together with
      `check_mdrb_deps()`).
    * Internal development helpers no longer write to `.GlobalEnv` or change
      `par()` without an immediate `on.exit()` / `withr` restore.

# metabodeconplus 0.20.2

* Gave metabodeconplus a distinct `Title` and `Description` in `DESCRIPTION`
  so they no longer duplicate the CRAN *metabodecon* package. The title now
  mentions model fitting, and the description highlights the end-to-end
  model-fitting workflow (`fit_mdm()` / `benchmark()`) and states that
  metabodeconplus is the backwards-incompatible successor to *metabodecon*.
* CI: the slow, network-dependent tests now run on at least one runner per OS.
  `R-CMD-check.yaml` promotes the macOS and Windows `release` jobs from `fast`
  to `all` (`RUN_SLOW_TESTS=TRUE`), so OS-specific slow tests (e.g. the
  persistent `datadir()` test, which is `skip_on_os("linux")`) keep their
  coverage. Download failures skip gracefully via `skip_if_no_example_datasets()`,
  so the slow jobs do not flake on transient network errors.

# metabodeconplus 0.20.1

* Fixed a flaky Windows `R CMD check` failure in the `glmnet`/lasso
  `fit_mdm()` and `benchmark()` smoke tests. `glmnet`'s compiled code
  intermittently triggers a Windows access violation (exit code
  `0xC0000005`) when run inside a `testthat` parallel worker, crashing the
  test subprocess. The fault is upstream and independent of how `fit_lasso()`
  drives `glmnet` — it reproduces identically with random folds, stratified
  folds, a manual cross-validation loop, and even the Gaussian family — and it
  does not occur outside the parallel-worker context. The lasso backend is an
  optional/secondary path (the default published model, `ranger`, is
  unaffected). These lasso smoke tests are therefore skipped on Windows only
  in automated check environments — CI and CRAN / `R CMD check`, including
  win-builder — while still running during local interactive development on
  Windows and on Linux/macOS everywhere. The `ranger` tests run on all
  platforms.

# metabodeconplus 0.20.0

* First release of **metabodeconplus**, the continuation of the *metabodecon*
  package under a new name. It provides an integrated workflow for 1D NMR
  spectra: deconvolution, alignment, feature-matrix construction and
  classification models (`fit_mdm()` / `benchmark()`), with an optional Rust
  backend (`mdrb`).
* The classic *metabodecon* (1.6.3) remains available separately, so existing
  workflows keep working while metabodeconplus evolves. As a fresh `0.x`
  package, metabodeconplus does not yet make backwards-compatibility promises.
