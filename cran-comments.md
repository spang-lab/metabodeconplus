UPDATE SUBMISSION (version 0.22.4)

This is an update of metabodeconplus, which is currently on CRAN as version 0.22.0.
It is a bug fix release without user-facing API changes.


SUMMARY OF CHANGES SINCE 0.22.0

1. snap_to_ref() no longer drops all non-reference peaks when it is given spectra that did not pass through clupa() (0.22.3).

2. fit_mdm() and benchmark() skip an unnecessary parameter grid search for non-default configurations, which makes them faster without changing results (0.22.2).

3. The internal PRARP score used during parameter selection is now clamped to the range from 0 to 1, matching its theoretical definition (0.22.1).

4. The package now ships an inst/CITATION file referencing Schmidt et al. (2026) <doi:10.3390/metabo16090604>, which is also cited in the Description field (0.22.4).

5. Documentation fixes in the README, the vignettes and several help pages (0.22.4).

See NEWS.md for details.


R CMD CHECK RESULTS

TODO: fill in before submission, e.g. "0 errors, 0 warnings, 0 notes".

Checked on:

- TODO: local machine (OS, R version)

- TODO: win-builder (release, devel, oldrelease)

- TODO: mac-builder (release)

- TODO: GitHub Actions (ubuntu, macOS, windows)


REVERSE DEPENDENCIES

TODO: confirm there are no reverse dependencies on CRAN.


THE SUGGESTED MDRB DEPENDENCY

The suggested dependency mdrb is available from https://spang-lab.r-universe.dev and is listed under Additional_repositories in DESCRIPTION.
It provides optional Rust code that speeds up some functions.
It is maintained by our group, the Spang Lab at the University of Regensburg.
All functionality works without it.
It is used conditionally and only appears in Suggests.
