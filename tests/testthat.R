# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)
library(metabodeconplus)

# DIAGNOSTIC (branch fix/test-mdm-windows-crash): filter is env-driven so the
# CI matrix can run the full suite (MDM_FILTER="") or just test-mdm.R
# (MDM_FILTER="mdm"). Revert before merge.
.flt <- Sys.getenv("MDM_FILTER", "mdm")
test_check("metabodeconplus", filter = if (nzchar(.flt)) .flt else NULL)
