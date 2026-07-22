# Public #####

#' @export
#'
#' @title Check Rust Backend Availability
#'
#' @description
#' `check_mdrb()` returns a boolean indicating whether a suitable version of the
#' metabodeconplus Rust backend [mdrb](https://github.com/spang-lab/mdrb) is
#' currently installed. The Rust backend is entirely optional; metabodeconplus's
#' pure-R backend is the default and always available.
#'
#' @param stop_on_fail
#' If TRUE, an error is thrown if the check fails, providing instructions on how
#' to install mdrb.
#'
#' @return
#' `check_mdrb()` returns TRUE if a suitable version of mdrb is installed, else
#' FALSE.
#'
#' @author 2024-2025 Tobias Schmidt: initial version.
#'
#' @examples
#' check_mdrb()
check_mdrb <- function(stop_on_fail = FALSE) {
    stopifnot(is_bool(stop_on_fail, 1))
    mdrb_version <- get_mdrb_version()
    req_version <- package_version("0.0.1")
    mdrb_is_ok <- mdrb_version >= req_version
    if (mdrb_is_ok || !stop_on_fail) return(mdrb_is_ok)
    err_msg <- paste(sep = "\n",
        "Using the Rust backend (use_rust >= 1) requires the optional 'mdrb'",
        "package (>= 0.0.1), which is not installed. Install it with:",
        "",
        '  install.packages("mdrb", repos = "https://spang-lab.r-universe.dev")',
        "",
        "For more information see: https://github.com/spang-lab/mdrb"
    )
    stop(err_msg, call. = FALSE)
}

# Internal #####

#' @noRd
#' @author 2024-2025 Tobias Schmidt: initial version.
get_mdrb_version <- function() {
    tryCatch(
        packageVersion("mdrb"),
        error = function(e) package_version("0.0.0")
    )
}
