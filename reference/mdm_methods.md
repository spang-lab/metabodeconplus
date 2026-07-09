# S3 methods for mdm objects

**\[experimental\]**

**WARNING: These methods are experimental and must not be used in
production. Their API is very likely to change in
non-backwards-compatible ways over the next few weeks.**

S3 methods for objects of class `mdm` and `summary.mdm`.

`predict.mdm()` predicts probabilities, classes, link scores, or all
three from an `mdm` object. When `newdata` is a spectra object, the
spectra are deconvoluted, aligned and snapped to the references stored
in the model before prediction. When `newdata` is a numeric matrix, it
is used directly as the feature matrix.

`print.mdm()` prints a compact model summary.

`coef.mdm()` returns lasso coefficients (or ranger importance).

`plot.mdm()` plots the lasso path (or ranger importance bars).

`summary.mdm()` builds a compact summary list.

`print.summary.mdm()` prints formatted output for `summary.mdm` objects.

## Usage

``` r
# S3 method for class 'mdm'
predict(
  object,
  newdata,
  type = c("all", "prob", "class", "link"),
  nworkers = 1,
  verbosity = 1,
  ...
)

# S3 method for class 'mdm'
print(x, ...)

# S3 method for class 'mdm'
coef(object, ...)

# S3 method for class 'mdm'
plot(x, ...)

# S3 method for class 'mdm'
summary(object, ...)

# S3 method for class 'summary.mdm'
print(x, ...)
```

## Arguments

- object, x:

  A fitted `mdm` object (for `predict`, `coef`, `summary`, `print` and
  `plot`) or a `summary.mdm` object (for `print.summary.mdm`).

- newdata:

  Spectra object or numeric feature matrix.

- type:

  Prediction type, one of `"all"`, `"prob"`, `"class"`, `"link"`.

- nworkers:

  Number of workers to deconvolute and align `newdata`.

- verbosity:

  Integer verbosity level.

- ...:

  Passed to underlying methods where applicable.

## Value

- `predict`: numeric vector of probabilities, classes, and/or link
  scores.

- `print`: invisibly returns `x`.

- `coef`: coefficient object from `glmnet` (or ranger importance).

- `plot`: invisibly returns `NULL`.

- `summary`: object of class `summary.mdm`.

- `print.summary.mdm`: invisibly returns `x`.
