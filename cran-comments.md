## Resubmission

This is a resubmission of 'metabodeconplus' (previously submitted as 0.20.2,
now 0.21.0). It addresses every point raised in the review by Konstanze
Lauseker (2026-07-22). Thank you for the detailed feedback. The changes:

* **`:::` in documentation.** Removed the `metabodeconplus:::read_aki_data()`
  call from the `harmonize_grid()` example (it is now a runnable example on
  the public `sim` dataset) and removed the `metabodeconplus:::` references
  from the `fit_mdm()` / `benchmark()` documentation prose. No `:::` remains
  in any `.Rd` file.

* **`\dontrun{}`.** Removed all `\dontrun{}` from the documentation. The
  `align()`, `si_mat()` and `harmonize_grid()` examples are now unwrapped
  (they run in well under 5 seconds on the bundled `sim` dataset). The
  `fit_mdm()` / `benchmark()` example is wrapped in `\donttest{}` because a
  full deconvolute -> align -> snap -> fit run on the bundled `sim2` dataset
  takes longer than 5 seconds; it uses at most one core.

* **`options(warn = -1)`.** No longer set anywhere. The only two occurrences
  lived in `check_mdrb_deps()`, which has been removed (see below).

* **Changing the user's options / par / working directory.** Audited all of
  `R/`. `setwd()` is not used. All graphics functions restore `par()` via
  `withr::local_par()` / an immediate `on.exit()`; one internal helper that
  set `par()` without restoring it now uses `withr::local_par()`.

* **Modifying `.GlobalEnv`.** Removed the two internal development helpers
  that assigned into `.GlobalEnv`. No package code writes to `.GlobalEnv`.

* **Installing packages in functions / examples / vignettes.** Removed the
  exported `install_mdrb()` function (the only `install.packages()` call) and
  the `check_mdrb_deps()` build-toolchain checker. The optional Rust backend
  'mdrb' is now purely user-installed. When it is requested
  (`deconvolute(use_rust >= 1)`) but not installed, the package stops with an
  error message that prints the exact `install.packages(...)` command and a
  link to the 'mdrb' repository. No function, example or vignette installs
  packages.

## R CMD check results

0 errors | 0 warnings | 1 note

The single note is the "CRAN incoming feasibility" note, which reports two
expected items:

* This is a new submission.
* The suggested package 'mdrb' is not in a mainstream repository; it is
  available from the 'Additional_repositories' entry
  https://spang-lab.r-universe.dev (see below).

## Relationship to the 'metabodecon' package

'metabodeconplus' is the actively developed successor to our existing
CRAN package 'metabodecon' (same maintainer). It keeps the deconvolution
and alignment core but adds an end-to-end model-fitting workflow
(`fit_mdm()` / `benchmark()`) that turns aligned signal integrals into
classification models, and it introduces backwards-incompatible API
changes. We are shipping it under a new name so that existing
'metabodecon' workflows keep working unchanged; both packages will be
maintained side by side. This is why the Title and Description overlap
with 'metabodecon'.

## The suggested 'mdrb' dependency

The note also flags the suggested dependency 'mdrb', which is available
from https://spang-lab.r-universe.dev and listed under
'Additional_repositories' in DESCRIPTION. It provides optional Rust code
that speeds up some functions and is maintained by our group (Spang Lab,
University of Regensburg). All functionality works without it; it is used
conditionally and only in 'Suggests'.
