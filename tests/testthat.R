# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)
library(metabodeconplus)

# DIAGNOSTIC (branch fix/test-mdm-windows-crash): restrict to test-mdm.R to
# reproduce and localize the Windows 0xC0000005 crash. Revert before merge.
test_check("metabodeconplus", filter = "mdm")
