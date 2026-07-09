# Return Path to File or Directory in metabodeconplus Package

Recursively searches for files or directories within the
'metabodeconplus' package that match the given name.

## Usage

``` r
metabodeconplus_file(name = "sim_01")
```

## Arguments

- name:

  The name to search for.

## Value

The file or directory path.

## Author

2024-2025 Tobias Schmidt: initial version.

## Examples

``` r
# Unambiguous paths
metabodeconplus_file("urine_1")
#> [1] "/home/runner/work/_temp/Library/metabodeconplus/example_datasets/bruker/urine/urine_1"
metabodeconplus_file("urine_1.dx")
#> [1] "/home/runner/work/_temp/Library/metabodeconplus/example_datasets/jcampdx/urine/urine_1.dx"
metabodeconplus_file("sim/sim_01")
#> [1] "/home/runner/work/_temp/Library/metabodeconplus/example_datasets/bruker/sim/sim_01"

# Ambiguous paths (i.e. multiple matches)
metabodeconplus_file("sim")
#> [1] "/home/runner/work/_temp/Library/metabodeconplus/example_datasets/bruker/sim"
metabodeconplus_file("urine")
#> [1] "/home/runner/work/_temp/Library/metabodeconplus/example_datasets/bruker/urine" 
#> [2] "/home/runner/work/_temp/Library/metabodeconplus/example_datasets/jcampdx/urine"

# Non-existing paths (i.e. a character vector of length zero gets returned)
metabodeconplus_file("asdfasdf")
#> character(0)
```
