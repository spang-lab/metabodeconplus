# Check Rust Backend Availability

`check_mdrb()` returns a boolean indicating whether a suitable version
of the metabodeconplus Rust backend
[mdrb](https://github.com/spang-lab/mdrb) is currently installed. The
Rust backend is entirely optional; metabodeconplus's pure-R backend is
the default and always available.

## Usage

``` r
check_mdrb(stop_on_fail = FALSE)
```

## Arguments

- stop_on_fail:

  If TRUE, an error is thrown if the check fails, providing instructions
  on how to install mdrb.

## Value

`check_mdrb()` returns TRUE if a suitable version of mdrb is installed,
else FALSE.

## Author

2024-2025 Tobias Schmidt: initial version.

## Examples

``` r
check_mdrb()
#> [1] TRUE
```
