# Changelog

## metabodeconplus 0.22.4

- Added a citation entry: `citation("metabodeconplus")` now returns
  Schmidt et al. (2026), Metabolites 16(9):604,
  <doi:10.3390/metabo16090604>, and Haeckl et al. (2021) for the
  original algorithm.

- The package description, README and Model Fitting article now
  reference Schmidt et al. (2026).

- README now presents CRAN as the stable source and GitHub as the
  development version, and links the Model Fitting and Datasets
  articles.

- Documentation fixes: titles and vignettes now say metabodeconplus
  instead of Metabodecon, and the Contributing article describes how to
  run the tests, install the package and prepare a release.

- CI: bumped GitHub Actions versions and allowed manual runs of
  R-CMD-check.

## metabodeconplus 0.22.3

- [`snap_to_ref()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md)
  no longer returns a zero-column feature matrix when it is handed
  spectra that did not pass through
  [`clupa()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md).
  It already derived a missing `pcial` for the reference spectrum but
  not for the others, so every non-reference peak snapped to `NA` and
  [`si_mat()`](https://spang-lab.github.io/metabodeconplus/reference/si_mat.md)
  dropped it – silently, with no error. The same fallback now applies to
  every spectrum. Results on the normal path are unchanged, since
  [`clupa()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md)
  always sets `pcial`.

## metabodeconplus 0.22.2

- Runtime improvement:
  [`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  and
  [`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  now skip the up-front `$deg` grid search when no pipeline stage reads
  it, i.e. for `npmax = 0` (literal deconvolution parameters) and for
  `decon_fun = identity2`, where
  [`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  previously re-ran the whole grid search once per outer fold and
  discarded the result. No result changes anywhere; only non-default
  configurations are affected. `decon_fun` is not reachable through the
  exported API (`identity2` is internal), so of the two only `npmax = 0`
  can be triggered by a public
  [`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  /
  [`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  call; the default `npmax = -1` still needs the grid.

## metabodeconplus 0.22.1

- Improvement: make `calc_prarp()` clamp both scores at zero, so `prarp`
  and `prarpx` stay in `[0, 1]`. Practically irrelevant, because the
  residual is never bigger than the spectrum area for any reasonable
  deconvolution, but makes the implementation match the theoretical
  formulation.

## metabodeconplus 0.22.0

CRAN release: 2026-08-09

- CRAN resubmission addressing the review of 0.21.0, which still saw
  changes of [`options()`](https://rdrr.io/r/base/options.html) and
  [`par()`](https://rdrr.io/r/graphics/par.html) without an appropriate
  reset in `R/plot.R` and `R/util.R`. No user-facing API changes.

- Removed the private multi-figure helpers `set_fig()` and
  `local_fig()`. `set_fig()` changed `par(fig=, new=)` and returned a
  reset function that its two callers registered via
  [`on.exit()`](https://rdrr.io/r/base/on.exit.html) /
  [`withr::defer()`](https://withr.r-lib.org/reference/defer.html), so
  the reset sat in a different function than the
  [`par()`](https://rdrr.io/r/graphics/par.html) call it reverts. That
  logic now lives in `with_fig()` and in
  [`draw_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/draw_spectrum.md),
  which change [`par()`](https://rdrr.io/r/graphics/par.html) and
  register the restoring
  [`on.exit()`](https://rdrr.io/r/base/on.exit.html) handler in the same
  function, before [`par()`](https://rdrr.io/r/graphics/par.html) is
  touched. Plot output is unchanged.

- Removed the unused private helper `catft()`, which permanently set the
  `metabodeconplus.catft.time` option, and dropped the equally unused
  `options(metabodeconplus.aki_cache=)` assignment from `.onLoad()`. The
  package no longer sets any global option that outlives a function
  call.

## metabodeconplus 0.21.0

- [`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  and
  [`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  now default to `model = "ranger"` (probability random forest) instead
  of `"lasso"`. Ranger is the intended default published model; pass
  `model = "lasso"` for the L1-penalised logistic-regression backend.
- `ranger` moved from Suggests to Imports: it is the default model
  backend, so it is now a hard dependency and its availability is no
  longer checked conditionally. `speaq` moved from Imports to Suggests,
  since it is only used by the non-default `align(use_speaq = TRUE)`
  path.
- CRAN resubmission addressing the review of 0.20.2. No user-facing API
  changes beyond the removal of `install_mdrb()` / `check_mdrb_deps()`.
  - Removed the exported `install_mdrb()` and `check_mdrb_deps()`
    functions: packages must not install other packages (CRAN policy).
    The optional Rust backend `mdrb` is now purely user-installed. When
    `deconvolute(use_rust >= 1)` is requested but `mdrb` is missing,
    [`check_mdrb()`](https://spang-lab.github.io/metabodeconplus/reference/check_mdrb.md)
    stops with an error that prints the exact
    `install.packages("mdrb", repos = "https://spang-lab.r-universe.dev")`
    command and links to <https://github.com/spang-lab/mdrb>.
  - Documentation examples no longer use `\dontrun{}`: runnable examples
    on the public `sim` / `sim2` datasets are now unwrapped or wrapped
    in `\donttest{}`, and no example uses more than two cores.
  - Removed the `metabodeconplus:::` (triple-colon) references from the
    [`harmonize_grid()`](https://spang-lab.github.io/metabodeconplus/reference/harmonize_grid.md)
    and
    [`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
    /
    [`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
    documentation.
  - No longer set `options(warn = -1)` anywhere (removed together with
    `check_mdrb_deps()`).
  - Internal development helpers no longer write to `.GlobalEnv` or
    change [`par()`](https://rdrr.io/r/graphics/par.html) without an
    immediate [`on.exit()`](https://rdrr.io/r/base/on.exit.html) /
    `withr` restore.

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
