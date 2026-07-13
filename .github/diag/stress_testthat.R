# DIAGNOSTIC (branch fix/test-mdm-windows-crash): high-power crash reproduction
# via the *parallel testthat* path (the crash only manifests inside a testthat
# callr worker, not a plain Rscript loop). Loop test_package (full suite,
# parallel per DESCRIPTION) many times in one job; the loop process survives a
# worker segfault (testthat reports it as an error), so we count crashes across
# many iterations. Remove before merge.
suppressMessages(library(metabodeconplus))
reps <- as.integer(Sys.getenv("REPS", "15"))
crashes <- 0
for (i in seq_len(reps)) {
    ok <- tryCatch({
        testthat::test_package(
            "metabodeconplus", reporter = "silent", stop_on_failure = FALSE
        )
        TRUE
    }, error = function(e) {
        msg <- conditionMessage(e)
        seg <- grepl("1073741819|crashed|subprocess exited", msg)
        cat(sprintf("[ITER %d] %s: %s\n",
                    i, if (seg) "CRASH" else "ERROR", msg))
        FALSE
    })
    if (!ok) crashes <- crashes + 1
    cat(sprintf("iter %d/%d  crashes-so-far=%d\n", i, reps, crashes))
    flush(stdout())
}
cat(sprintf("=== TOTAL crashes: %d / %d ===\n", crashes, reps))
