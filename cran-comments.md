## R CMD check results

0 errors | 0 warnings | 1 note

The single note is the "CRAN incoming feasibility" note, which reports
two expected items:

* This is a new submission.
* The suggested package 'mdrb' is not in a mainstream repository; it is
  available from the 'Additional_repositories' entry
  https://spang-lab.r-universe.dev (see below).

## Relationship to the 'metabodecon' package

'metabodeconplus' is the actively developed successor to our existing
CRAN package 'metabodecon' (same maintainer). It keeps the deconvolution
and alignment core but adds an end-to-end model-fitting workflow
(`fit_mdm()` / `benchmark()`) that turns aligned signal integrals into
classification models, and it introduces backwards-incompatible API
changes. We are shipping it under a new name so that existing
'metabodecon' workflows keep working unchanged; both packages will be
maintained side by side. This is why the Title and Description overlap
with 'metabodecon'.

## The suggested 'mdrb' dependency

The note also flags the suggested dependency 'mdrb', which is available
from https://spang-lab.r-universe.dev and listed under
'Additional_repositories' in DESCRIPTION. It provides optional Rust code
that speeds up some functions and is maintained by our group (Spang Lab,
University of Regensburg). All functionality works without it; it is used
conditionally and only in 'Suggests'.
