# Changelog

## metabodeconplus 0.20.2

- Gave metabodeconplus a distinct `Title` and `Description` in
  `DESCRIPTION` so they no longer duplicate the CRAN *metabodecon*
  package. The title now mentions model fitting, and the description
  highlights the end-to-end model-fitting workflow
  ([`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  /
  [`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md))
  and states that metabodeconplus is the backwards-incompatible
  successor to *metabodecon*.
- CI: the slow, network-dependent tests now run on at least one runner
  per OS. `R-CMD-check.yaml` promotes the macOS and Windows `release`
  jobs from `fast` to `all` (`RUN_SLOW_TESTS=TRUE`), so OS-specific slow
  tests (e.g. the persistent
  [`datadir()`](https://spang-lab.github.io/metabodeconplus/reference/datadir.md)
  test, which is `skip_on_os("linux")`) keep their coverage. Download
  failures skip gracefully via `skip_if_no_example_datasets()`, so the
  slow jobs do not flake on transient network errors.

## metabodeconplus 0.20.1

- Fixed a flaky Windows `R CMD check` failure in the `glmnet`/lasso
  [`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  and
  [`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  smoke tests. `glmnet`’s compiled code intermittently triggers a
  Windows access violation (exit code `0xC0000005`) when run inside a
  `testthat` parallel worker, crashing the test subprocess. The fault is
  upstream and independent of how `fit_lasso()` drives `glmnet` — it
  reproduces identically with random folds, stratified folds, a manual
  cross-validation loop, and even the Gaussian family — and it does not
  occur outside the parallel-worker context. The lasso backend is an
  optional/secondary path (the default published model, `ranger`, is
  unaffected). These lasso smoke tests are therefore skipped on Windows
  only in automated check environments — CI and CRAN / `R CMD check`,
  including win-builder — while still running during local interactive
  development on Windows and on Linux/macOS everywhere. The `ranger`
  tests run on all platforms.

## metabodeconplus 0.20.0

- First release of **metabodeconplus**, the continuation of the
  *metabodecon* package under a new name. It provides an integrated
  workflow for 1D NMR spectra: deconvolution, alignment, feature-matrix
  construction and classification models
  ([`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  /
  [`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)),
  with an optional Rust backend (`mdrb`).
- The classic *metabodecon* (1.6.3) remains available separately, so
  existing workflows keep working while metabodeconplus evolves. As a
  fresh `0.x` package, metabodeconplus does not yet make
  backwards-compatibility promises.
