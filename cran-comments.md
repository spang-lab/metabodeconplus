
RESUBMISSION (version 0.22.0)

This is a resubmission of metabodeconplus. It was previously
submitted as 0.21.0 and is now on version 0.22.0. It
addresses the review by Leonore Hochhauser of 2026-08-04,
which reported that we still change options and par without
an appropriate reset in R/plot.R and R/util.R. Thank you for
catching this. We are sorry that our previous fix was
incomplete.

The full history of all previous review rounds is kept below
this section, so the current state can be seen in context.


WHAT WAS STILL WRONG

We re-audited every options() and par() call in the R
folder and found three genuine defects that our 0.21.0 fix
had missed.

1. R/util.R, catft(). This private helper ended with
options(metabodeconplus.catft.time = now) and never restored
it. It measured the time between two log messages by parking
a timestamp in the user's global options. The option was
therefore left behind in the user's session permanently.

2. R/util.R, .onLoad(). This set
options(metabodeconplus.aki_cache = cache_dir) without any
reset.

3. R/plot.R, set_fig(). This is the one we consider the most
serious. Setting par(fig=) resets R's multi-figure
configuration to one row and one column, so the old layout
has to be saved and restored by hand. set_fig() did save it,
but it then only *returned* a reset function and left the
restoring to whoever called it. There was no on.exit() in
set_fig() itself. If the caller forgot to call the returned
function, or if drawing failed in between, the user's
graphical parameters stayed modified. In addition, the
wrapper that used it, local_fig(), deferred the reset with
withr, which further hid the fact that no on.exit() was
attached to the par() call itself.

We also concluded that our previous answer, that graphics
functions restore par() "with withr::local_par()", made the
package needlessly hard to review. Because withr was
imported wholesale, calls appeared in the sources as bare
local_par(...) with nothing marking them as restoring calls.


WHAT WE CHANGED

1. Every options() and par() change in the package is now
made with plain base R and reverted by an on.exit() handler
that is registered in the very same function, immediately
next to the change, following the idiom from the review
message:

    oldpar <- par(mar = mar)
    on.exit(par(oldpar), add = TRUE, after = FALSE)

There is no longer a single place in the package where a
par() or options() change and its reset live in different
functions. Every such change and its reset can now be seen
side by side at the call site. We use add = TRUE so that our
handlers compose with the other on.exit() handlers in the
same function, and after = FALSE so that state is unwound in
reverse order of being changed.

2. catft() was unused package-internal code and has been
deleted, together with its options() call. The unused
options(metabodeconplus.aki_cache = ) assignment in .onLoad()
has been deleted as well. The package now sets no global
option that outlives a function call. .onLoad() only creates
a cache directory, and only on a development checkout.

3. set_fig() and local_fig() have been removed. Their logic
now lives in with_fig(), which sets par() and restores it via
on.exit() within one function, and in draw_spectrum(), which
does the same inline for the region it draws into. Both
register the restoring handler before changing par(), so the
parameters are restored even if drawing throws an error.

4. withr is no longer used for options() or par() anywhere.
It is now imported selectively, for local_dir() and
local_pdf() only, and every remaining call is written as
withr::local_dir() / withr::local_pdf() so it is visible at
the call site. We kept withr for these two because they
restore the working directory and close graphics devices,
which is not what the review was about; if you would prefer
base-R equivalents there too, we are happy to change that as
well.

5. Test files that relied on withr symbols leaking in through
the wholesale import now call them as withr::... explicitly.


HOW WE VERIFIED IT

Beyond re-reading every hit of "par(" and "options(" in the
R folder, we added a check that snapshots par(no.readonly =
TRUE) before and after each exported plotting function and
compares the two. The exported plotting functions leave every
graphical parameter unchanged, except usr, xaxp and yaxp,
which any plot() call necessarily sets, and fig and mfg
inside a multi-figure layout, which advance by exactly one
frame, identically to a plain plot() call. par() is also
restored when a plotting call exits with an error. Running
deconvolute() introduces no new entry in options() and
changes no existing one.


R CMD CHECK RESULTS

0 errors, 0 warnings, 1 note.

The note is the CRAN incoming feasibility note, unchanged
from the previous submission and described further down.


==================================================

PREVIOUS SUBMISSION (version 0.21.0)

RESUBMISSION

This is a resubmission of metabodeconplus. It was previously
submitted as 0.20.2 and is now on version 0.21.0. It
addresses every point from the review by Konstanze Lauseker
of 2026-07-22. Thank you for the detailed feedback. The
changes are listed below.

1. Triple-colon operator in documentation. We removed the
metabodeconplus:::read_aki_data() call from the
harmonize_grid() example. That example now uses the bundled
sim dataset. We also removed the metabodeconplus:::
references from the fit_mdm() and benchmark() documentation.
No triple-colon operator remains in any Rd file.

2. Use of dontrun. We removed every dontrun block. All
examples now run during R CMD check. The fit_mdm() and
benchmark() examples run in about one to two seconds on a
small subset of the bundled sim2 dataset. No example uses
more than two cores.

3. Setting options(warn = -1). This is no longer done
anywhere. The only two occurrences were in
check_mdrb_deps(), which we removed. See point 6.

4. Changing the user's options, par or working directory. We
audited every file in the R folder. setwd() is not used. All
graphics functions restore par() with withr::local_par() or
an immediate on.exit(). One internal helper that changed
par() without restoring it now uses withr::local_par() as
well.

5. Modifying the global environment. We removed the two
internal development helpers that assigned into .GlobalEnv.
No package code writes to .GlobalEnv.

6. Installing packages. We removed the exported
install_mdrb() function. It was the only function that
called install.packages() (after obtaining permission
interactively). No function, example or vignette installs
packages now.


R CMD CHECK RESULTS

0 errors, 0 warnings, 1 note.

The note is the CRAN incoming feasibility note. It reports
two expected items. First, this is a new submission. Second,
the suggested package mdrb is not in a mainstream
repository. It is available from the Additional_repositories
entry https://spang-lab.r-universe.dev.


RELATIONSHIP TO THE METABODECON PACKAGE

metabodeconplus is the actively developed successor to our
existing CRAN package metabodecon. Both have the same
maintainer. It keeps the deconvolution and alignment core
and adds an end-to-end model-fitting workflow, fit_mdm() and
benchmark(), that turns aligned signal integrals into
classification models. It introduces backwards-incompatible
API changes. We ship it under a new name so that existing
metabodecon workflows keep working unchanged. Both packages
will be maintained side by side. This is why the title and
description overlap with metabodecon.


THE SUGGESTED MDRB DEPENDENCY

The note also flags the suggested dependency mdrb. It is
available from https://spang-lab.r-universe.dev and is
listed under Additional_repositories in DESCRIPTION. It
provides optional Rust code that speeds up some functions.
It is maintained by our group, the Spang Lab at the
University of Regensburg. All functionality works without
it. It is used conditionally and only appears in Suggests.
