# Package index

## Deconvolution

Functions to read and deconvolute spectra into their individual peaks.

- [`read_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/read_spectrum.md)
  : Read one or more spectra from Disk
- [`read_spectra()`](https://spang-lab.github.io/metabodeconplus/reference/read_spectra.md)
  : Read one or more spectra from Disk
- [`make_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/make_spectrum.md)
  : Create a Spectrum Object
- [`simulate_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/simulate_spectrum.md)
  **\[experimental\]** : Simulate a 1D NMR Spectrum
- [`deconvolute()`](https://spang-lab.github.io/metabodeconplus/reference/deconvolute.md)
  [`get_deg()`](https://spang-lab.github.io/metabodeconplus/reference/deconvolute.md)
  : Deconvolute one or more NMR spectra

## Alignment

Functions to align multiple deconvoluted spectra.

- [`align()`](https://spang-lab.github.io/metabodeconplus/reference/align.md)
  : Align deconvoluted spectra
- [`clupa()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md)
  [`snap_to_ref()`](https://spang-lab.github.io/metabodeconplus/reference/alignment_funs.md)
  : Alignment building blocks
- [`harmonize_grid()`](https://spang-lab.github.io/metabodeconplus/reference/harmonize_grid.md)
  : Harmonize a corpus of spectra onto a shared chemical-shift grid

## Feature matrices and models

Functions to turn aligned spectra into feature matrices and to fit and
benchmark classification models.

- [`si_mat()`](https://spang-lab.github.io/metabodeconplus/reference/si_mat.md)
  : Signal-integral matrix
- [`peak_mat()`](https://spang-lab.github.io/metabodeconplus/reference/peak_mat.md)
  : Peak feature matrix
- [`bin()`](https://spang-lab.github.io/metabodeconplus/reference/bin.md)
  : Bin a spectra-like object into a feature matrix
- [`bin700()`](https://spang-lab.github.io/metabodeconplus/reference/bin700.md)
  : 700-bin Zacharias 2013 feature matrix
- [`fit_mdm()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  [`benchmark()`](https://spang-lab.github.io/metabodeconplus/reference/mdm.md)
  **\[experimental\]** : Metabodecon Models
- [`predict(`*`<mdm>`*`)`](https://spang-lab.github.io/metabodeconplus/reference/mdm_methods.md)
  [`print(`*`<mdm>`*`)`](https://spang-lab.github.io/metabodeconplus/reference/mdm_methods.md)
  [`coef(`*`<mdm>`*`)`](https://spang-lab.github.io/metabodeconplus/reference/mdm_methods.md)
  [`plot(`*`<mdm>`*`)`](https://spang-lab.github.io/metabodeconplus/reference/mdm_methods.md)
  [`summary(`*`<mdm>`*`)`](https://spang-lab.github.io/metabodeconplus/reference/mdm_methods.md)
  [`print(`*`<summary.mdm>`*`)`](https://spang-lab.github.io/metabodeconplus/reference/mdm_methods.md)
  **\[experimental\]** : S3 methods for mdm objects

## Plotting

Functions to plot single and multiple spectra.

- [`plot_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/plot_spectrum.md)
  **\[experimental\]** : Plot Spectrum
- [`plot_spectra()`](https://spang-lab.github.io/metabodeconplus/reference/plot_spectra.md)
  : Plot Spectra
- [`draw_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/draw_spectrum.md)
  **\[experimental\]** : Draw Spectrum
- [`heat_spectra()`](https://spang-lab.github.io/metabodeconplus/reference/heat_spectra.md)
  : Plot Spectra Heatmap

## Classes

The spectrum and spectra classes and their methods.

- [`is_spectrum()`](https://spang-lab.github.io/metabodeconplus/reference/metabodeconplus-classes.md)
  [`is_spectra()`](https://spang-lab.github.io/metabodeconplus/reference/metabodeconplus-classes.md)
  [`as_spectra()`](https://spang-lab.github.io/metabodeconplus/reference/metabodeconplus-classes.md)
  [`as_decon2()`](https://spang-lab.github.io/metabodeconplus/reference/metabodeconplus-classes.md)
  [`as_decons2()`](https://spang-lab.github.io/metabodeconplus/reference/metabodeconplus-classes.md)
  [`get_names()`](https://spang-lab.github.io/metabodeconplus/reference/metabodeconplus-classes.md)
  : Metabodecon Classes and Helpers

## Datasets

Bundled example datasets and functions to download and locate them.

- [`sim`](https://spang-lab.github.io/metabodeconplus/reference/sim.md)
  : The Sim Dataset
- [`sim2`](https://spang-lab.github.io/metabodeconplus/reference/sim2.md)
  : The Sim2 Classification Dataset
- [`sap`](https://spang-lab.github.io/metabodeconplus/reference/sap.md)
  : The SAP Dataset
- [`datadir()`](https://spang-lab.github.io/metabodeconplus/reference/datadir.md)
  : Return path to metabodeconplus's data directory
- [`datadir_persistent()`](https://spang-lab.github.io/metabodeconplus/reference/datadir_persistent.md)
  : Persistent Data Directory
- [`datadir_temp()`](https://spang-lab.github.io/metabodeconplus/reference/datadir_temp.md)
  : Temporary Data Directory
- [`tmpdir()`](https://spang-lab.github.io/metabodeconplus/reference/tmpdir.md)
  : Temporary Session Directory
- [`download_example_datasets()`](https://spang-lab.github.io/metabodeconplus/reference/download_example_datasets.md)
  : Download metabodeconplus Example Datasets
- [`metabodeconplus_file()`](https://spang-lab.github.io/metabodeconplus/reference/metabodeconplus_file.md)
  : Return Path to File or Directory in metabodeconplus Package

## Rust backend

Functions to install and check the optional Rust backend.

- [`check_mdrb()`](https://spang-lab.github.io/metabodeconplus/reference/check_mdrb.md)
  [`check_mdrb_deps()`](https://spang-lab.github.io/metabodeconplus/reference/check_mdrb.md)
  : Check Rust Backend Requirements
- [`install_mdrb()`](https://spang-lab.github.io/metabodeconplus/reference/install_mdrb.md)
  **\[experimental\]** : Install Rust Backend

## Utility

Utility functions, e.g. for converting between units or testing.

- [`convert_pos()`](https://spang-lab.github.io/metabodeconplus/reference/convert_pos.md)
  [`convert_width()`](https://spang-lab.github.io/metabodeconplus/reference/convert_pos.md)
  : Convert from unit A to unit B
- [`width()`](https://spang-lab.github.io/metabodeconplus/reference/width.md)
  : Calculate the Width of a Numeric Vector
- [`transp()`](https://spang-lab.github.io/metabodeconplus/reference/transp.md)
  : Make transparent
- [`tree()`](https://spang-lab.github.io/metabodeconplus/reference/tree.md)
  [`tree_preview()`](https://spang-lab.github.io/metabodeconplus/reference/tree.md)
  : Print the Structure of a Directory Tree
- [`headtail()`](https://spang-lab.github.io/metabodeconplus/reference/headtail.md)
  : Show head and tail rows of a matrix-like object
- [`evalwith()`](https://spang-lab.github.io/metabodeconplus/reference/evalwith.md)
  : Evaluate an expression with predefined global state
- [`aaa_Get_Started()`](https://spang-lab.github.io/metabodeconplus/reference/aaa_Get_Started.md)
  [`get_started()`](https://spang-lab.github.io/metabodeconplus/reference/aaa_Get_Started.md)
  : Get URL of Metabodecon "Get Started" Page

## Deprecated

Deprecated functions. They will be removed in a future release.

- [`get_data_dir()`](https://spang-lab.github.io/metabodeconplus/reference/get_data_dir.md)
  **\[deprecated\]** : Retrieve directory path of an example dataset
