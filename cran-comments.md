RESUBMISSION (version 0.22.0)

This is the second resubmission of metabodeconplus.
It was first submitted as 0.20.2 on 2026-07-13, then resubmitted as 0.21.0 on 2026-07-24, and is now on version 0.22.0.

The current version addresses the findings by Leonore Hochhauser of 2026-08-04, which reported that we still change options and par without an appropriate reset in R/plot.R and R/util.R.
Thank you for catching this.
We are sorry that our previous fix was incomplete.

The full history of all previous review rounds is kept below this section, so the current state can be seen in context.


SUMMARY OF CHANGES FOR 0.22.0

1. The private helper catft() from file util.R was removed.
It used options(metabodeconplus.catft.time=now) to store the time between two log messages and never reset it.
Nothing in the package called it.

2. Function .onLoad() from file util.R no longer sets options(metabodeconplus.aki_cache=cache_dir).
Nothing in the package read that option.
The package now sets no global option that outlives a function call.

3. Functions set_fig() and local_fig() from file plot.R have been removed.
They changed par(fig=, new=) and only returned a function that the caller had to call in order to restore the multi-figure configuration, so the parameters stayed modified if the caller did not call it, or if drawing failed in between.
Their logic now lives in with_fig(), which sets par() and restores it via on.exit() within one function, and in draw_spectrum(), which does the same inline for the region it draws into.
Both register the restoring handler before changing par(), so the parameters are restored even if drawing throws an error.

We verified the fix by snapshotting par(no.readonly=TRUE) before and after every exported plotting function.
They now leave par() exactly as a plain plot() call does, also when they exit with an error, and running deconvolute() no longer adds or changes any entry in options().

All other par() changes in the package are saved and restored inside the very function that makes them, so they are unchanged in this version.


R CMD CHECK RESULTS

0 errors, 0 warnings, 1 note.

The note is the CRAN incoming feasibility note, unchanged from the previous submission and described further down.


SUMMARY OF CHANGES FOR 0.21.0

This version addressed every point from the review by Konstanze Lauseker of 2026-07-22.

1. Triple-colon operator in documentation.
We removed the metabodeconplus:::read_aki_data() call from the harmonize_grid() example.
That example now uses the bundled sim dataset.
We also removed the metabodeconplus::: references from the fit_mdm() and benchmark() documentation.
No triple-colon operator remains in any Rd file.

2. Use of dontrun.
We removed every dontrun block.
All examples now run during R CMD check.
The fit_mdm() and benchmark() examples run in about one to two seconds on a small subset of the bundled sim2 dataset.
No example uses more than two cores.

3. Setting options(warn = -1).
This is no longer done anywhere.
The only two occurrences were in check_mdrb_deps(), which we removed.
See point 6.

4. Changing the user's options, par or working directory.
We audited every file in the R folder.
setwd() is not used.
This audit was incomplete; see the 0.22.0 section above for what it missed.

5. Modifying the global environment.
We removed the two internal development helpers that assigned into .GlobalEnv.
No package code writes to .GlobalEnv.

6. Installing packages.
We removed the exported install_mdrb() function.
It was the only function that called install.packages(), after obtaining permission interactively.
No function, example or vignette installs packages now.


RELATIONSHIP TO THE METABODECON PACKAGE

metabodeconplus is the actively developed successor to our existing CRAN package metabodecon.
Both have the same maintainer.
It keeps the deconvolution and alignment core and adds an end-to-end model-fitting workflow, fit_mdm() and benchmark(), that turns aligned signal integrals into classification models.
It introduces backwards-incompatible API changes.
We ship it under a new name so that existing metabodecon workflows keep working unchanged.
Both packages will be maintained side by side.
This is why the title and description overlap with metabodecon.


THE SUGGESTED MDRB DEPENDENCY

The incoming feasibility note flags the suggested dependency mdrb.
It is available from https://spang-lab.r-universe.dev and is listed under Additional_repositories in DESCRIPTION.
It provides optional Rust code that speeds up some functions.
It is maintained by our group, the Spang Lab at the University of Regensburg.
All functionality works without it.
It is used conditionally and only appears in Suggests.
