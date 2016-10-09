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
    --create        -c      Create an environment

Positional Arguments:
package                 Name of package(s) to update
```

### Examples

(There are many permutations of this command, but the samples below should be sufficient to get you started)

Creating a dev environment

```bash
ssb --create --dev --name mydev27 python=2.7 stsci
ssb --create --dev --name mydev35 python=3.5 stsci
```

Creating an AstroConda environment

```bash
ssb --create --public --name mypublic27 python=2.7 stsci
ssb --create --public --name mypublic35 python=3.5 stsci
```

Updating a dev environment by name

```bash
ssb --update --all --dev --name mydev
```

Updating an active dev environment

```bash
source activate mydev
ssb --update --all --dev
```

Installing a package into a dev environment

```bash
ssb --install --dev --name mydev [pkg_name]
```

Installing a package into an active dev environment

```bash
source activate mydev
ssb --install --dev [pkg_name]
```

# Support

Use at your own risk.
