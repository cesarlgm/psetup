# psetup

Stata package with utilities for efficient project setup and management in research workflows.

## Commands

### `clean_folders`
Erases and recreates the temporary and output working directories for a project. Call this at the top of a master do-file to guarantee a clean slate before producing new outputs. Supports an optional `subfolders` flag that automatically creates `fig/`, `tab/`, and `text/` subdirectories inside the output folder. Cross-platform (Windows and macOS).

```stata
clean_folders, folder("C:/projects/mypaper") subfolders
```

### `create_references`
Reads a semicolon-delimited manifest file (`input_manifest.txt`) and creates symbolic links — or file copies — from another project's output directory into the current project's `input/` folder. This lets downstream projects consume upstream outputs without duplicating files. On Windows it executes a generated PowerShell script; on macOS it uses shell commands.

```stata
create_references, opath("C:/projects/main_analysis/output")
```

**Manifest format** (`input_manifest.txt`):
```
# Lines starting with # are comments
local_name.dta;source_name.dta
figures_dir;output_figures
```

## Installation

```stata
net install psetup, from("https://raw.githubusercontent.com/cesarlgm/psetup/main") replace
```

Or from a local clone:

```stata
net install psetup, from("/path/to/psetup") replace
```

## Requirements

Stata 14 or later. No external package dependencies.

## Author

César Garro-Marín, University of Edinburgh — cgarrom@ed.ac.uk
