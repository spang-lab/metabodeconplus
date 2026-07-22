Resubmission

This is a resubmission of metabodeconplus. It was previously submitted as
0.20.2 and is now 0.21.0. It addresses every point from the review by
Konstanze Lauseker of 2026-07-22. Thank you for the detailed feedback. The
changes are listed below.

1. Triple-colon operator in documentation. We removed the
metabodeconplus:::read_aki_data() call from the harmonize_grid() example. That
example now uses the bundled sim dataset. We also removed the
metabodeconplus::: references from the fit_mdm() and benchmark() documentation.
No triple-colon operator remains in any Rd file.

2. Use of dontrun. We removed every dontrun block. All examples now run during
R CMD check. The fit_mdm() and benchmark() examples run in about one to two
seconds on a small subset of the bundled sim2 dataset. They are guarded by
requireNamespace() so they are skipped when the optional ranger package is not
installed. No example uses more than two cores.

3. Setting options(warn = -1). This is no longer done anywhere. The only two
occurrences were in check_mdrb_deps(), which we removed. See point 6.

4. Changing the user's options, par or working directory. We audited every
file in the R folder. setwd() is not used. All graphics functions restore par()
with withr::local_par() or an immediate on.exit(). One internal helper that
changed par() without restoring it now uses withr::local_par() as well.

5. Modifying the global environment. We removed the two internal development
helpers that assigned into .GlobalEnv. No package code writes to .GlobalEnv.

6. Installing packages. We removed the exported install_mdrb() function. It was
the only function that called install.packages(). It installed the optional
Rust backend mdrb after an interactive confirmation. Users now install mdrb
themselves. When mdrb is requested but not installed, deconvolute() stops and
prints the exact install command and the package URL. We also removed
check_mdrb_deps(), a helper that only supported that installation. No function,
example or vignette installs packages.

R CMD check results

0 errors, 0 warnings, 1 note.

The note is the CRAN incoming feasibility note. It reports two expected items.
First, this is a new submission. Second, the suggested package mdrb is not in a
mainstream repository. It is available from the Additional_repositories entry
https://spang-lab.r-universe.dev.

Relationship to the metabodecon package

metabodeconplus is the actively developed successor to our existing CRAN
package metabodecon. Both have the same maintainer. It keeps the deconvolution
and alignment core and adds an end-to-end model-fitting workflow, fit_mdm() and
benchmark(), that turns aligned signal integrals into classification models. It
introduces backwards-incompatible API changes. We ship it under a new name so
that existing metabodecon workflows keep working unchanged. Both packages will
be maintained side by side. This is why the title and description overlap with
metabodecon.

The suggested mdrb dependency

The note also flags the suggested dependency mdrb. It is available from
https://spang-lab.r-universe.dev and is listed under Additional_repositories in
DESCRIPTION. It provides optional Rust code that speeds up some functions. It is
maintained by our group, the Spang Lab at the University of Regensburg. All
functionality works without it. It is used conditionally and only appears in
Suggests.
