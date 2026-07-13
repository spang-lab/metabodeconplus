# DIAGNOSTIC (branch fix/test-mdm-windows-crash): loop the lasso ops
# (op1 -> op2 -> op3) that trigger the Windows 0xC0000005 crash, so a gdb
# wrapper on CI can catch the native fault and print a backtrace naming the
# faulting module (expected: glmnet). Not part of the package.
suppressMessages(library(metabodeconplus))
mbp <- asNamespace("metabodeconplus")
args <- commandArgs(trailingOnly = TRUE)
reps <- if (length(args) >= 1) as.integer(args[[1]]) else 8L

set.seed(1); n <- 32; npk <- 3
cs <- seq(from = 3.6, length.out = 512, by = -0.0006)
x0 <- sort(runif(npk, 3.42, 3.56)); A <- runif(npk, 8, 14) * 1e3
lam <- runif(npk, 0.9, 1.3) / 1e3
y <- factor(rep(c("A", "B"), each = n / 2)); sp <- vector("list", n)
for (i in seq_len(n)) {
    xi <- x0 + rnorm(npk, sd = 0.0003); Ai <- A * runif(npk, 0.8, 1.2)
    li <- lam * runif(npk, 0.9, 1.1)
    Ai[1] <- Ai[1] * (if (y[i] == "A") 1.3 else 0.7)
    sp[[i]] <- simulate_spectrum(name = sprintf("s_%02d", i), cs = cs,
        x0 = sort(xi), A = Ai, lambda = li,
        noise = rnorm(length(cs), sd = 500))
}
class(sp) <- "spectra"
bc <- function(...) { cat(sprintf("[SEQ] %s\n", paste0(...))); flush(stdout()) }
for (i in seq_len(reps)) {
    bc("rep ", i, " op1"); invisible(fit_mdm(sp, y, npmax=0L, maxShift=50L,
        maxCombine=20L, use_rust=0.5, nworkers=1, verbosity=0))
    bc("rep ", i, " op2"); invisible(benchmark(sp, y, npmax=0L, maxShift=50L,
        maxCombine=20L, k=4, use_rust=0.5, nworkers=1, verbosity=0))
    bc("rep ", i, " op3"); invisible(mbp$fit_mdm_internal(sp, y, feat_fun=bin,
        decon_fun=mbp$identity2, align_fun=mbp$identity_align,
        snap_fun=mbp$identity_snap, npmax=0L, maxShift=0L, maxCombine=64L,
        igrs=list(), verbosity=0))
}
bc("ALL DONE ", reps)
