<!-- badges: start -->
[![R-CMD-check](https://github.com/spang-lab/metabodeconplus/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/spang-lab/metabodeconplus/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/spang-lab/metabodeconplus/branch/main/graph/badge.svg)](https://app.codecov.io/gh/spang-lab/metabodeconplus?branch=main)
[![GitHub version](https://img.shields.io/github/v/release/spang-lab/metabodeconplus?label=GitHub&color=blue)](https://github.com/spang-lab/metabodeconplus/releases)
[![CRAN version](https://img.shields.io/cran/v/metabodeconplus?label=CRAN&color=blue)](https://cran.r-project.org/package=metabodeconplus)
[![CRAN Downloads](https://cranlogs.r-pkg.org/badges/grand-total/metabodeconplus)](https://cran.r-project.org/package=metabodeconplus)
<!-- badges: end -->

# metabodeconplus <img src="man/figures/logo.svg" alt="man/figures/logo.svg" align="right" height="138" />

A framework for deconvolution, alignment and postprocessing of 1D NMR spectra, resulting in a data matrix of aligned signal integrals.
On top of that, `fit_mdm()` and `benchmark()` fit and cross-validate classification models (random forest or lasso) on these signal integrals, running the whole pipeline from raw spectra to a trained model in a single call.
The deconvolution part uses the algorithm described in [Koh et al. (2009)](https://doi.org/10.1016/j.jmr.2009.09.003).
The alignment part is based on functions from the 'speaq' package, described in [Beirnaert et al. (2018)](https://doi.org/10.1371/journal.pcbi.1006018) and [Vu et al. (2011)](https://doi.org/10.1186/1471-2105-12-405).
A detailed description and evaluation of an early version of the package, 'MetaboDecon1D v0.2.2', can be found in [Haeckl et al. (2021)](https://doi.org/10.3390/metabo11070452).
The current package is described in [Schmidt et al. (2026)](https://doi.org/10.3390/metabo16090604).
metabodeconplus is the successor of the [metabodecon](https://github.com/spang-lab/metabodecon) package, which remains available for existing workflows.

## Installation

To install the stable version from [CRAN](https://cran.r-project.org/package=metabodeconplus), paste the following command in a running R session:

```R
install.packages("metabodeconplus")
```

To install the development version from [GitHub](https://github.com/spang-lab/metabodeconplus/) use:

```R
install.packages("pak")
pak::pkg_install("spang-lab/metabodeconplus")
```

## Usage

At [Getting Started](https://spang-lab.github.io/metabodeconplus/articles/Get_Started.html) you can see an example how metabodeconplus can be used to deconvolute an existing data set, followed by alignment of the data and some additional postprocessing steps, resulting in a data matrix of aligned signal integrals.

At [Function Reference](https://spang-lab.github.io/metabodeconplus/reference/index.html) you get an overview of all functions provided by metabodeconplus.

## Documentation

metabodeconplus's documentation is available at [spang-lab.github.io/metabodeconplus](https://spang-lab.github.io/metabodeconplus/). It includes pages about

- [Getting Started](https://spang-lab.github.io/metabodeconplus/articles/Get_Started.html)
- [Model Fitting](https://spang-lab.github.io/metabodeconplus/articles/MDM.html)
- [Datasets](https://spang-lab.github.io/metabodeconplus/articles/Datasets.html)
- [Contribution Guidelines](https://spang-lab.github.io/metabodeconplus/articles/Contributing.html)
- [Function Reference](https://spang-lab.github.io/metabodeconplus/reference/index.html)

## Citation

If you use metabodeconplus in your research, please cite:

Schmidt T, Sombke M, Zacharias HU, Oefner PJ, Spang R, Gronwald W, on behalf of the GCKD Investigators. Metabodeconplus—An R Package for Automated Deconvolution and Alignment of 1D NMR Metabolomics Data. Metabolites. 2026;16(9):604. [doi:10.3390/metabo16090604](https://doi.org/10.3390/metabo16090604)
