<!-- badges: start -->
[![R-CMD-check](https://github.com/spang-lab/metabodeconplus/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/spang-lab/metabodeconplus/actions/workflows/R-CMD-check.yaml)
[![Install-Check](https://github.com/spang-lab/metabodeconplus/actions/workflows/test-install.yaml/badge.svg)](https://github.com/spang-lab/metabodeconplus/actions/workflows/test-install.yaml)
[![Codecov test coverage](https://codecov.io/gh/spang-lab/metabodeconplus/branch/main/graph/badge.svg)](https://app.codecov.io/gh/spang-lab/metabodeconplus?branch=main)
[![GitHub version](https://img.shields.io/github/v/release/spang-lab/metabodeconplus?label=GitHub&color=blue)](https://github.com/spang-lab/metabodeconplus/releases)
[![CRAN version](https://img.shields.io/cran/v/metabodeconplus?label=CRAN&color=blue)](https://cran.r-project.org/package=metabodeconplus)
[![CRAN Downloads](https://cranlogs.r-pkg.org/badges/grand-total/metabodeconplus)](https://cranlogs.r-pkg.org/badges/grand-total/metabodeconplus)
<!-- badges: end -->

# metabodeconplus <img src="man/figures/logo.svg" alt="man/figures/logo.svg" align="right" height="138" />

A framework for deconvolution, alignment and postprocessing of 1D NMR spectra, resulting in a data matrix of aligned signal integrals. The deconvolution part uses the algorithm described in [Koh et al. (2009)](https://doi.org/10.1016/j.jmr.2009.09.003). The alignment part is based on functions from the 'speaq' package, described in [Beirnaert et al. (2018)](https://doi.org/10.1371/journal.pcbi.1006018) and [Vu et al. (2011)](https://doi.org/doi:10.1186/1471-2105-12-405). A detailed description and evaluation of an early version of the package, 'MetaboDecon1D v0.2.2', can be found in [Haeckl et al. (2021)](https://doi.org/doi:10.3390/metabo11070452).

## Installation

To install the **stable version** from [CRAN](https://cran.r-project.org/), including all [Bioconductor](https://www.bioconductor.org/) dependencies, paste the following commands in a running R session (e.g. in RStudio):

```R
install.packages("pak")
pak::pkg_install("metabodeconplus")
```

Alternatively, if you prefer installing via the traditional `install.packages()` function, you can do so by running the following commands:

```R
# Install Bioconductor dependencies
install.packages("BiocManager")
BiocManager::install(c("MassSpecWavelet", "impute"))

# Install metabodeconplus
install.packages("metabodeconplus")
```

To install the **development version** from [GitHub](https://github.com/spang-lab/metabodeconplus/) use:

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
- [Contribution Guidelines](https://spang-lab.github.io/metabodeconplus/articles/Contributing.html)
- [Function Reference](https://spang-lab.github.io/metabodeconplus/reference/index.html)
