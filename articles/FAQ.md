# FAQ

## FAQ

### File Structure

**Question:** What file structure is expected for `bruker` and `jcampdx`
formats?

**Answer:** The expected file structure is as follows:

``` txt
C:/bruker/urine              # data_path (user input)
├── urine_1/                 # name (user input)
│   └── 10/                  # spectroscopy_value (user input), called expno in TopSpin manual
│       ├── acqus            # acqus_file (constant)
│       └── pdata/           # processings_dir (constant)
│           └── 10/          # processing_value (user input), called procno in TopSpin manual
│               ├── 1r       # spec_file (constant)
│               └── procs    # spectrum_file (constant)
├── urine_2/...
└── ...
C:/jcampdx/urine    # data_path (user input)
├── urine_1.dx      # spectrum_file (user input)
├── urine_2.dx
└── ...
```
