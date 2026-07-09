# metabodeconplus 0.20.0

* First release of **metabodeconplus**, the continuation of the *metabodecon*
  package under a new name. It provides an integrated workflow for 1D NMR
  spectra: deconvolution, alignment, feature-matrix construction and
  classification models (`fit_mdm()` / `benchmark()`), with an optional Rust
  backend (`mdrb`).
* The classic *metabodecon* (1.7.0) remains available separately, so existing
  workflows keep working while metabodeconplus evolves. As a fresh `0.x`
  package, metabodeconplus does not yet make backwards-compatibility promises.
