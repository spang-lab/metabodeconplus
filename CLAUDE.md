# Instructions for metabodeconplus

## IMPORTANT

- Never change any files outside the project or the global temp
  directory without asking for permission first.
- Never run `git commit` without an explicit instruction from
  the user to do so. After implementing changes, leave them in
  the working tree (or staged at most) so the user can review
  and commit themselves. The same rule applies to `git push`,
  `git tag`, `git reset --hard` and any other history-touching
  operation: explicit user instruction is required.

## Versioning

- **Origin.** This package began as the `tobi` branch of
  `spang-lab/metabodecon` (branched around metabodecon v1.7.0). The
  breaking changes grew large enough that it was split out into its
  own package, **metabodeconplus**, with its own repository:
  `github.com/spang-lab/metabodeconplus`. Development now happens on
  `main` there — the old `tobi` branch and the `2.0.x` version scheme
  it prepared are historical and no longer apply.
- **Current line.** metabodeconplus is an early **`0.x`** package
  (`DESCRIPTION` version is currently `0.22.4`; it is on CRAN since
  `0.22.0`). The classic *metabodecon* (1.x) continues to live separately at
  `github.com/spang-lab/metabodecon`, so existing workflows keep
  working while metabodeconplus evolves.
- Bump the `DESCRIPTION` version whenever a user-visible change ships,
  and add a one-line entry to `NEWS.md`.
- Because this is a fresh `0.x` package with **no backwards-compatibility
  promises yet**, no compat shims, deprecation warnings, or migration
  paths are required. Break signatures, defaults, and behavior as needed
  and just update the call sites.

## Workspace Conventions

- Use `./tmp` for temporary files (it is gitignored and Rbuildignored).
  Never write temp files outside the project directory.
- If code changes must be tested with multiple workers, remind the user to
  reinstall the package before they run those tests.
- **Installing the package**: always use
  `R CMD INSTALL --no-lock --no-staged-install .`. The user runs radian
  sessions that mmap the package's `.so` files, which makes plain
  `R CMD INSTALL` fail with stale `00LOCK-metabodeconplus` directories
  (NFS silly-renames the in-use shared library to a `.nfs*` file that
  can't be removed). `--no-lock` skips the lock-dir step and
  `--no-staged-install` writes directly to the final library path.
  Both flags together avoid the stale-lock failure mode without
  touching the user's running R sessions.
- Never run `scripts/kill-nfs-lock.sh` (or `kill`/`pkill` against R
  processes) just to clear a stale install lock. Doing so terminates
  the user's radian sessions. The `--no-lock --no-staged-install`
  approach above sidesteps the lock entirely.

## Coding Guidelines

- All roxygen comments should start with a tag, in particular title and
  description should be formatted as `#' @title ...` and `#' @description ...`.
- Soft Character limit is 80.
  Hard limit is 100.
  Prefer short variable names like `x` and `y` to achieve that.
	If it's not clear from the function docs what a variable means,
	use a comment to describe it upon first use.
- Fill lines up to ~80 chars to minimize vertical space.
  Prefer single-line calls over multi-line when they fit.
	Going slightly over 80 (up to ~100) is tolerable if it avoids splitting
	a call across multiple lines lines.
- Prefer the use of helper variables instead of function nesting to reduce line
  length and improve readability. E.g. `x <- f(a); y <- g(x)` instead of `y <-
  g(f(a))`. Function nesting is ok if everything still fits in 80 chars and the
  function names are short and readable.
- Avoid defining functions inside other functions, except for temporary
  callbacks passed directly to `lapply()`, `sapply()`, `vapply()`, etc.
  Prefer top-level private helper functions instead to keep function bodies
  short and easy to scan.
- Do not use pipe operators `%>%` or `|>`.
- Always use fully qualified names for functions from other packages, e.g.
  `ggplot2::ggplot()`. Exceptions are functions from R's standard library like
  `sum()`, `mean()`, etc.
- Do NOT use spaces around `=` when passing arguments to functions.
  Good: `foo(bar=2)`. Bad: `foo(bar = 2)`.
- Always use fully qualified function names inside roxygen2 docs,
  even when referring to package internal functions (i.e., write
  `[metabodeconplus::deconvolute()]` instead of just
  `[deconvolute()]`)

### Multi-line formatting (function calls, `if/else`, loops): READ THIS

This rule is **non-negotiable**. The user has flagged violations of it
many times. Re-read this section before writing any R code.

**Rule 1 — Prefer single lines.** If a call, `if`/`else` branch, or
loop body fits within the project's character limit on one line, put
it on one line. Only split if it doesn't fit.

**Rule 2 — When you DO split, ALWAYS use this exact shape:**

```r
funcName(
    arg1, arg2,
    arg3, arg4
)
```

- Opening `(` is the **last character** on the function-name line.
  **Nothing else** follows it — no args, no comments, nothing.
- Args sit on subsequent lines, **indented exactly 4 spaces** beyond
  the start column of the call.
- Closing `)` is **alone on its own line**, dedented to the call's
  start column.

**Rule 3 — Never use "trailing args after the open paren".** This
style is **strictly forbidden**:

```r
# FORBIDDEN — args trailing after open paren, aligned to opening column:
funcName(arg1, arg2,
         arg3, arg4)

# FORBIDDEN — first arg on same line as funcName, closing ) inline:
funcName(arg1,
    arg2, arg3)

# FORBIDDEN — even if only one arg trails:
img_cached("path/to/file.rds",
           expensive_call(a, b, c))
```

If you find yourself aligning arguments under the open paren of the
function name, **stop and reformat using Rule 2**.

**Rule 4 — `if`/`else` follows the same shape.** Don't tail an `else`
branch onto the closing `}` of the `if` body — give it its own block:

```r
# Good:
v <- if (cond) {
    do_a()
    do_b()
} else {
    do_c()
}

# Forbidden — naked else expression after }:
v <- if (cond) {
    do_a()
    do_b()
} else do_c()
```

**Rule 5 — These rules apply recursively to nested calls.** If an
inner call has to wrap, the inner call itself follows Rule 2 — open
paren at end of line, args indented +4, closing paren on its own line.

This rule overrides any aesthetic preference for vertical alignment.
The user does not want column-aligned multi-line calls in this project.
Ever.

## Pseudocode mode for vignettes

- Definition: "pseudocode mode" means code examples are written primarily for
  readability and teaching, while still running under normal/ideal conditions.
- Scope: Use pseudocode mode for all newly added or modified code in
  `vignettes/*.Rmd`.
- Keep code compact and direct: prefer fewer lines, fewer helper variables, and
  simple control flow.
- Prefer clear intent over defensive robustness in vignettes. Avoid extra
  safeguards that distract from the main idea unless they are essential to
  understand the method.
- Keep naming short when context is obvious (e.g. `X`, `y`, `te`, `Xtr`,
  `Xte`).
- Prefer single-line function calls in vignettes. Avoid multiline calls unless
  required for readability of `*apply()` loops or unavoidable long literals.
- Avoid defensive checks and fallback branches in vignette chunks. In pseudocode
  mode, prefer short, direct, didactic code that assumes normal conditions.

## Project Structure

- `_pkgdown.yml`: Configuration file for the pkgdown website.
- `cran-comments.md`: Comments for CRAN submission.
- `CRAN-SUBMISSION`: Details about the CRAN submission process.
- `DESCRIPTION`: Metadata about the R package.
- `Dockerfile`: Instructions to build a Docker image for the project.
- `LICENSE.md`: Licensing information for the project.
- `NAMESPACE`: Defines the exported and imported functions for the package.
- `NEWS.md`: Changelog for the project.
- `README.md`: Overview and instructions for the project.
- `data/`: Bundled example datasets (`sap.rda`, `sim.rda`, `sim2.rda`).
- `data-raw/`: Scripts that create the bundled datasets.
- `inst/`: Additional files to be included in the package (e.g. `CITATION`,
  `WORDLIST`, `example_datasets/`).
- `man/`: Documentation files for R functions (generated by roxygen2).
- `pkgdown/`: Assets for the pkgdown website.
- `R/`: Contains the R scripts for the package.
- `scripts/`: Development and CI helper scripts (e.g. `test-install.R`).
- `src/`: C code compiled into the package.
- `tests/`: Unit tests for the package.
- `vignettes/`: Long-form documentation and tutorials.

## Vignettes

- `Get_Started.Rmd`: A guide to getting started with the package (reading
  spectra incl. the Bruker/JCAMP-DX file layout, deconvolution, alignment).
- `MDM.Rmd`: "Model Fitting" — the deconvolute → clupa → snap_to_ref → ranger
  classification pipeline, plus the one-shot `fit_mdm()` / `benchmark()` calls.
- `Datasets.Rmd`: Information about the datasets included in the package.
- `Contributing.Rmd`: Guidelines for contributing to the project.

## Modules

### align.R

Functions for aligning deconvoluted spectra. The public alignment pipeline
chains two stages — **CluPA** (continuous shifts) and **reference snapping**
(discrete snap to reference) — and [metabodeconplus::align()] runs both in one call.

- (exported) `align(x, maxShift, maxCombine, ref=NULL, ...)`: chains
  `clupa()` then `snap_to_ref()`. Returns an `aligns` object whose
  per-spectrum `lcpar` has been collapsed onto the reference's peak grid.
- (exported) `clupa(x, maxShift, ref=NULL, ...)`: **CluPA** —
  hierarchical-clustering FFT segment shifts (Beirnaert et al. 2018,
  Vu et al. 2011). FFT input is the Lorentz superposition `$sit$sup`
  already attached at deconvolution time (= speaq-equivalent shape,
  matches v1.7.0's `get_sup_mat(decons2)` → `dohCluster` input).
  Requires every spectrum in `x` to share the same `$cs` grid — call
  `harmonize_grid(x)` upstream if your corpus is from different
  acquisitions. Adds `x0al`, `pcial` to `lcpar`; keeps original peak
  count.
- (exported) `snap_to_ref(x, maxCombine, ref=NULL)`: **reference snapping** — for
  every peak, records the nearest reference column on the shared `cs`
  grid (within `maxCombine`) as `pcisn` / `x0sn`. Peaks farther than
  `maxCombine` get `pcisn = NA` / `x0sn = NA`. Original `x0`, `x0al`,
  `A`, `lambda`, `pcide`, `pcial` are all preserved — `snap_to_ref`
  only *adds* fields. No peaks are dropped here and amplitudes are
  not summed; [metabodeconplus::si_mat()] / [metabodeconplus::peak_mat()]
  skip `pcisn = NA` peaks and sum collisions on the same `pcisn`
  column at rasterisation time. Clears `sit$supal` (the post-snap
  peak list is no longer Lorentz-compatible).
- (private) `identity_align(x, ...)`: no-op; returns `x`.
- (private) `build_clupa_consensus`: label-aware CluPA reference used when
  class labels are available.
- (private) `ensure_shared_cs`: assertion-only helper used by every
  alignment / snap entry point. Stops with an actionable message if
  inputs don't share a grid; remedy is to call `harmonize_grid()`.
- (private) `ensure_align_aux`: per-spectrum kernel that backfills
  `lcpar$pcide` and `sit$sup` from `x$cs` if missing.
- (private) `noshift_align`, `noshift_one`: CluPA's `maxShift = 0`
  fast-path (sets `x0al = x0`, `pcial = nearest cs column`).
- (private) `align_decon`: CluPA per-spectrum kernel (FFT shift +
  speaq-equivalent hclust). Reads `x$cs` and `x$sit$sup`; writes
  `x0al = cs[pcial]` and `pcial` as integer indices into `x$cs`.
- (private) `snap_lcpar`: reference-snapping per-spectrum kernel.
- (private) `find_ref`, `find_ref_ind`: pick the reference spectrum by
  minimising the sum, over every target peak in every other spectrum,
  of the ppm distance to the nearest peak in the candidate reference.
  Grid-free (compares `x0` values in ppm directly). **Bias:** the sum
  is over target peaks only, so candidates with dense peak lists
  (incl. noise peaks) are favoured. Mirrors `speaq::findRef` semantics.
- (private) `pci_on_cs`: integer column index for a vector of ppm
  values via `round(convert_pos(...))`, clamped to `[1, length(cs)]`.
- (private) `lcpar_pci`, `dedupe_peaks`: peak-index and de-duplication
  helpers.
- (private) `fft_shift`, `do_shift`, `hclust_align`, `pad_peaks`:
  bundled CluPA implementation that mirrors `speaq::hClustAlign` and is
  byte-equivalent to it; the speaq backend remains available via
  `use_speaq = TRUE`.

VOPA and GloPA (inherited from metabodecon) are not part of this package —
the only built-in CluPA-stage backends are `clupa` and `identity_align`.
Experimental alternatives live in `experimental.R`.

### class.R

Class definitions and methods for the classes used by the package. Also holds
the package-level documentation (`metabodeconplus-classes`, `"_PACKAGE"`).

- (exported) `is_spectrum`, `is_spectra`: Check if an object is a spectrum / spectra.
- (exported) `as_spectra`, `as_decon2`, `as_decons2`: Convert objects.
- (exported) `get_names`: Retrieves the names of a collection of objects.
- (exported, S3) `print`, `format`, `summary` for `spectrum` and `spectra`;
  `c.spectrum`, `c.spectra`, `[.spectra`.
- (private) `get_name`, `get_default_names`, `set_names`: Name helpers.
- (private) `get_peak`: Nearest datapoint index for a ppm value.

Classes: `spectrum`, `decon2`, `align` (singlets) and `spectra`, `decons2`,
`aligns` (collections), connected by cumulative inheritance.

### data.R

Functions for downloading and locating example datasets, plus the docs of the
bundled datasets (`sap`, `sim`, `sim2`).

- (exported) `download_example_datasets`: Downloads example datasets for testing.
- (exported) `metabodeconplus_file`: Returns the path to a file or directory in the package.
- (exported) `datadir`: Returns the path to the data directory.
- (exported) `datadir_persistent`: Returns the path to the persistent data directory.
- (exported) `datadir_temp`: Returns the path to the temporary data directory.
- (exported) `tmpdir`: Returns the path to the temporary session directory.
- (exported) `get_data_dir`: Deprecated function to retrieve the directory path of an example dataset.
- (private) `cache_example_datasets`, `extract_example_datasets`,
  `download_example_datasets_zip`, `zip_temp`, `zip_persistent`: Download
  and cache helpers.
- (private) `tmpfile`, `testdir`, `mockdir`, `cachedir`: Path helpers.
- (private) `read_aki_metadata`, `read_aki_data`, `cache_aki_data`,
  `aki_cache_path`, `creatinine_normalize`: Access to the private AKI
  dataset (not shipped with the package).

### decon.R

Functions for deconvoluting NMR spectra.

- (exported) `deconvolute`: Deconvolutes NMR spectra by modeling signals as Lorentz curves.
- (exported) `get_deg`: Default deconvolution-parameter grid.
- (private) `deconvolute_spectra`, `deconvolute_spectrum`: Internal workers.
- (private) `deconvolute_spectrum_r`, `deconvolute_spectrum_rust`: R and
  Rust (mdrb) backends.
- (private) `grid_deconvolute_spectra`, `grid_deconvolute_spectrum`,
  `pick_best_params`: Grid search over deconvolution parameters (`$deg`).
- (private) `is_npmax`, `npmax_needs_deg`, `decon_needs_deg`,
  `find_npmax_elbow`, `find_npmax_elbow_one`: `npmax` / Kneedle elbow helpers.
- (private) `smooth_signals2`, `find_peaks2`, `filter_peaks2`,
  `fit_lorentz_curves2`: The deconvolution steps.
- (private) `lorentz`, `lorentz_sup`, `lorentz_int`: Lorentz curve values,
  superposition and integrals.
- (private) `calc_prarp`, `calc_prarpx`: PRARP scores.

### experimental.R

Private, experimental functions that are kept for future work but not
exported (e.g. used by the metabodeconplus-paper package).

- (private) `snap_nw`, `snap_nw_blind`, `snap_nw_lcpar`, `build_consensus`,
  `normalize_A`: Needleman-Wunsch snap family.
- (private) `combine_peaks`, `combine_peaks_mat`, `combine_scores`: Greedy
  post-CluPA column-merge snap.

### mdm.R

Model fitting ("mdm" = metabodeconplus model).

- (exported) `fit_mdm`: Runs deconvolute -> align -> snap -> featurize -> fit
  once or over a parameter grid and returns an `mdm` object.
- (exported) `benchmark`: Wraps `fit_mdm()` in outer k-fold cross-validation.
- (exported, S3) `predict`, `print`, `coef`, `plot`, `summary` for `mdm`.
- (private) `fit_mdm_internal`, `benchmark_internal`: Pluggable engines.
- (private) `identity2`, `identity_snap`: No-op pipeline stages.
- (private) `fit_lasso`, `predict_lasso`, `fit_ranger`, `predict_ranger`:
  Classification backends.
- (private) Various helpers: `get_mog`, `find_maxShift_dip`, `get_foldid`,
  `get_test_ids`, `AUC`, `check_mdm_args`, `mdm_eval`, `fmt_pct`, etc.

### mdrb.R

Function for checking the optional mdrb (metabodeconplus rust backend). The
package never installs mdrb itself (CRAN policy); `deconvolute(use_rust>=1)`
errors via `check_mdrb(stop_on_fail=TRUE)` with the install command + repo link
when mdrb is missing.

- (exported) `check_mdrb`: Checks if a suitable Rust backend is installed.
- (private) `get_mdrb_version`: Retrieves the version of the Rust backend.

### plot.R

Functions for plotting single and multiple spectra before and after deconvolution/alignment.

- (exported) `plot_spectra`: Plots a set of deconvoluted spectra.
- (exported) `heat_spectra`: Plots a set of spectra as heatmap.
- (exported) `plot_spectrum`: Plots a single spectrum with zoomed regions.
- (exported) `draw_spectrum`: Draws a single spectrum, used internally by `plot_spectrum`.
- (private) `plot_sfr`: Plots the signal-free region.
- (private) `plot_ws`: Plots the water signal region.
- (private) `plot_align`: Plots aligned and unaligned spectra for comparison.
- (private) `plot_empty`: Creates an empty plot canvas.
- (private) `plot_dummy`: Creates a dummy plot for testing.
- (private) `with_fig`: Multi-figure helper that changes `par()` and resets it
  in the same function.
- Various helpers: Functions like `draw_legend`, `draw_con_lines`, and `draw_lc_line` assist in drawing specific plot elements.

### simat.R

Feature matrices built from (aligned) spectra.

- (exported) `si_mat`: Signal-integral matrix (one row per spectrum, one
  column per chemical-shift datapoint).
- (exported) `peak_mat`: Peak feature matrix (non-empty columns only).
- (exported) `bin`: Bins a spectra-like object into a feature matrix.
- (exported) `bin700`: 700-bin feature matrix as in Zacharias et al. (2013).
- (private) `lcpar_idx`, `bin700_one`, `bin700_range`: Helpers.

### spec.R

Functions for creating, reading and writing spectra from/to disk.

- (exported) `read_spectrum`: Reads a single spectrum from disk.
- (exported) `read_spectra`: Reads multiple spectra from disk.
- (exported) `make_spectrum`: Creates a spectrum object.
- (exported) `simulate_spectrum`: Simulates a 1D NMR spectrum.
- (exported) `harmonize_grid`: Puts a corpus of spectra onto a shared
  chemical-shift grid.
- (private) `read_bruker`
- (private) `read_jcampdx`
- (private) `parse_metadata`
- (private) `read_acqus`
- (private) `read_procs_file`
- (private) `read_simpar`
- (private) `read_one_r`
- (private) `save_spectrum`
- (private) `save_spectra`

### test.R

Utility functions to help with testing.

- (exported) `evalwith`: Evaluates an expression with predefined global state, including options for capturing output, mocking directories, and caching results.
- (unexported) `get_readline_mock`: Creates a mock `readline` function for testing.
- (unexported) `get_datadir_mock`: Returns a mock for the `datadir` functions.
- (unexported) `run_tests`: Runs tests with options to skip slow tests or focus on specific functions.
- (unexported) `skip_if_slow_tests_disabled`, `skip_if_no_example_datasets`,
  `skip_if_not_in_globenv`, `skip_if_speaq_deps_missing`: Skip helpers.
- (unexported) `r_geq`, `not_cran`: Environment checks.
- (unexported) `normalize_svg_ids`, `make_stable_svg_writer`: Stable SVG
  snapshots for vdiffr.
- (unexported) `expect_file_size`: Checks if file sizes in a directory are within a certain range.
- (unexported) `expect_str`: Tests if the structure of an object matches an expected string.

### util.R

Utility functions for unit conversion, file handling, user input, type checking, and other miscellaneous tasks. It also holds the package imports, `get_started()` and `.onLoad`.

- (Exported) Docs:
  - `aaa_Get_Started`, `get_started`: Return (and optionally open) the URL of the "Get Started" page.

- (Exported) Unit Conversion:
  - `convert_pos`: Converts positions from one unit to another.
  - `convert_width`: Converts widths from one unit to another.
  - `width`: Calculates the width of a numeric vector.

- (Exported) File Handling and Printing:
  - `tree`, `tree_preview`: Print the structure of a directory tree.
  - `headtail`: Shows the head and tail rows of a matrix-like object.

- (Exported) Visualization:
  - `transp`: Makes a color transparent by adding an alpha channel.

- (Private) Unit Conversion:
  - `in_hz`: Converts chemical shifts from ppm to Hz.
  - `sfr_in_ppm_bwc`: Converts signal-free region borders from SDP to PPM.
  - `sfr_in_sdp_bwc`: Converts signal-free region borders from PPM to SDP.

- (Private) File Handling:
  - `checksum`: Calculates a checksum for files or directories.
  - `mkdirs`: Recursively creates directories.
  - `clear`: Clears a directory and recreates it.
  - `norm_path`: Normalizes file paths.
  - `pkg_file`: Returns the path to a file within the package.
  - `store`: Stores an object in a file.
  - `null_cache`, `disk_cache`: Cache helpers.

- (Private) User Input:
  - `readline`: Mockable version of `readline`.
  - `get_num_input`: Prompts the user for numeric input.
  - `get_int_input`: Prompts the user for integer input.
  - `get_str_input`: Prompts the user for string input.
  - `get_yn_input`: Prompts the user for yes/no input.

- (Private) Operators:
  - `%||%`, `%&&%`, `%==%`, `%!=%`, `%===%`, `%!==%`: Custom operators for logical and equality checks.

- (Private) Type Checking:
  - Functions like `is_num`, `is_int`, `is_char`, `is_bool`, and their variations check the type and structure of objects.

- (Private) Miscellaneous:
  - `logf`, `logv`, `logvv`, `human_readable_difftime`: Logging and formatting utilities.
  - `du`: Prints the size of an object and its subcomponents.
  - `set`, `pop`: Modifies lists in-place.
  - `timestamp`: Returns the current timestamp.
  - `mcmapply`, `get_worker_pool`, `half_cores`: Multi-core helpers.
  - `load_all`, `document`, `style`: Development shortcuts.
  - `.onLoad`: Package load hook.

## Tests

Tests live inside ./tests/testthat. The following tests exist:

1. `test-aaa_Get_Started.R`
2. `test-align.R`
3. `test-cache_example_datasets.R`
4. `test-class_methods.R`
5. `test-datadir.R`
6. `test-deconvolute.R`
7. `test-deconvolute_spectra.R`
8. `test-deconvolute_spectrum.R`
9. `test-download_example_datasets.R`
10. `test-draw_spectrum.R`
11. `test-evalwith.R`
12. `test-find_peaks2.R`
13. `test-get_names.R`
14. `test-human_readable.R`
15. `test-is_float_str.R`
16. `test-is_int_str.R`
17. `test-lorentz_sup.R`
18. `test-mcmapply.R`
19. `test-mdm.R`
20. `test-metabodeconplus_file.R`
21. `test-pkg_file.R`
22. `test-plot_sfr.R`
23. `test-plot_ws.R`
24. `test-read_acqus_file.R`
25. `test-read_bruker.R`
26. `test-read_one_r_file.R`
27. `test-read_procs_file.R`
28. `test-read_spectrum.R`
29. `test-si_mat.R`
30. `test-smooth_signals.R`
31. `test-snap_to_ref.R`
32. `test-speaq.R`
33. `test-tree.R`
