# ssb-utils

A collection of wrappers for use by the Science Software Branch at STScI.

# Installation

```bash
git clone http://github.com/astroconda/ssb-utils.git
```

It is recommended you copy the `ssb-utils` directory to a "safe" place (i.e. not your `Downloads` directory)

# Requirements

- BASH >=3.2

## conda.sh

### Activation

```bash
source /path/to/ssb-utils/conda.sh
```

### Usage

```bash
$ ssb --help
Usage: ssb {-i|-u} {-p|-d} [-an] [[package] ...]

General Arguments:
    --help          -h      This usage message
    --name [env]    -n      Update existing environment by name
    --public        -p      Use astroconda
    --dev           -d      Use conda-dev
    --all           -a      Update all packages (supersedes [package] requests)
    --yes           -y      Do not prompt (use with care)

Mode Arguments:
    --install       -i      Perform an installation
    --update        -u      Perform an update

Positional Arguments:
package                 Name of package(s) to update
```

# Support

Use at your own risk.
