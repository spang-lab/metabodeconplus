# metabodeconplus

A framework for deconvolution, alignment and postprocessing of 1D NMR
spectra, resulting in a data matrix of aligned signal integrals that can
be used directly for fitting statistical models. The package is
described in [Schmidt et
al. (2026)](https://doi.org/10.3390/metabo16090604).

## Installation

To install the stable version from
[CRAN](https://cran.r-project.org/package=metabodeconplus), paste the
following command in a running R session:

``` r

install.packages("metabodeconplus")
```

To install the development version from
[GitHub](https://github.com/spang-lab/metabodeconplus/) use:

``` r

install.packages("pak")
pak::pkg_install("spang-lab/metabodeconplus")
```

## Usage

At [Getting
Started](https://spang-lab.github.io/metabodeconplus/articles/Get_Started.html)
you can see an example how metabodeconplus can be used to deconvolute an
existing data set, followed by alignment of the data and some additional
postprocessing steps, resulting in a data matrix of aligned signal
integrals.

At [Function
Reference](https://spang-lab.github.io/metabodeconplus/reference/index.html)
you get an overview of all functions provided by metabodeconplus.

## Documentation

metabodeconplus’s documentation is available at
[spang-lab.github.io/metabodeconplus](https://spang-lab.github.io/metabodeconplus/).
It includes pages about

- [Getting
  Started](https://spang-lab.github.io/metabodeconplus/articles/Get_Started.html)
- [Model
  Fitting](https://spang-lab.github.io/metabodeconplus/articles/MDM.html)
- [Datasets](https://spang-lab.github.io/metabodeconplus/articles/Datasets.html)
- [Contribution
  Guidelines](https://spang-lab.github.io/metabodeconplus/articles/Contributing.html)
- [Function
  Reference](https://spang-lab.github.io/metabodeconplus/reference/index.html)

## Related work

metabodeconplus is the latest stage of a package that has been renamed
twice:

- MetaboDecon1D (up to v0.2.2, until 2023) was the first implementation,
  described and evaluated in [Haeckl et
  al. (2021)](https://doi.org/10.3390/metabo11070452).

- [metabodecon](https://github.com/spang-lab/metabodecon) (v1.0.0 to
  v1.7.x, since 2023) is its renamed and reworked successor, which
  remains available for existing workflows.

- metabodeconplus (v0.20.0 onwards, since 2026) continues metabodecon
  1.7 and adds model fitting.

Methods and software used by the package:

- Deconvolution: [Koh et
  al. (2009)](https://doi.org/10.1016/j.jmr.2009.09.003); optional Rust
  backend [mdrb](https://github.com/spang-lab/mdrb).

- Alignment: the ‘speaq’ package, described in [Beirnaert et
  al. (2018)](https://doi.org/10.1371/journal.pcbi.1006018) and [Vu et
  al. (2011)](https://doi.org/10.1186/1471-2105-12-405).

- Choice of the number of signals: the Kneedle method of [Satopää et
  al. (2011)](https://doi.org/10.1109/ICDCSW.2011.20).

- Classification: random forests ([Breiman,
  2001](https://doi.org/10.1023/A:1010933404324)) via ‘ranger’ ([Wright
  and Ziegler, 2017](https://doi.org/10.18637/jss.v077.i01)) and the
  lasso via ‘glmnet’ ([Friedman et al.,
  2010](https://doi.org/10.18637/jss.v033.i01)).

- 700-bin feature matrix and AKI dataset: [Zacharias et
  al. (2013)](https://doi.org/10.1007/s11306-012-0479-4).

Other tools for 1D NMR processing:

- Deconvolution and profiling: BATMAN ([Hao et al.,
  2012](https://doi.org/10.1093/bioinformatics/bts308)), rDolphin
  ([Cañueto et al., 2018](https://doi.org/10.1007/s11306-018-1319-y)),
  ASICS ([Lefort et al.,
  2019](https://doi.org/10.1093/bioinformatics/btz248)), BAYESIL
  ([Ravanbakhsh et al.,
  2015](https://doi.org/10.1371/journal.pone.0124219)), DEEP Picker1D
  ([Li et al., 2023](https://doi.org/10.5194/mr-4-19-2023)), decon1d
  ([Hughes et al., 2015](https://doi.org/10.1371/journal.pone.0134474)),
  mldecon ([Schmid et al.,
  2023](https://doi.org/10.1016/j.jmr.2022.107357)).

- Alignment: icoshift ([Savorani et al.,
  2010](https://doi.org/10.1016/j.jmr.2009.11.012)), COW ([Tomasi et
  al., 2004](https://doi.org/10.1002/cem.859)).

- Processing workflows: NMRProcFlow ([Jacob et al.,
  2017](https://doi.org/10.1007/s11306-017-1178-y)), SigMa ([Khakimov et
  al., 2020](https://doi.org/10.1016/j.aca.2020.02.025)).

- Downstream statistical analysis: MetaboAnalyst ([Pang et al.,
  2024](https://doi.org/10.1093/nar/gkae253)).

## Citation

If you use metabodeconplus in your research, please cite:

Schmidt T, Sombke M, Zacharias HU, Oefner PJ, Spang R, Gronwald W, on
behalf of the GCKD Investigators. Metabodeconplus—An R Package for
Automated Deconvolution and Alignment of 1D NMR Metabolomics Data.
Metabolites. 2026;16(9):604.
[doi:10.3390/metabo16090604](https://doi.org/10.3390/metabo16090604)
