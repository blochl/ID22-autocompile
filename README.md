# ID22 Autocompilation script

This script can be used to automatically compile all the data acquired during a session on the ID22 beamline at the ESRF. It also adds the raw data to the relevant results' directory, so that the **complete** dataset could be saved by the user for further analysis back home.

## Assumptions

It is assumed that all your raw data is named with the experiment number (in proper casing) as the prefix, and *.dat* as the suffix. For example: **ma1234**_Sample1**.dat** .

## Usage

1. Edit the experiment number, the required binnings, and other parameters (only if necessary) near the top of the file.
2. Run it: `./compile_all.sh` or `bash compile_all.sh`
3. Wait.

## Resulting Directory Structure

* For each *.dat* file a directory will be created, and the raw data file will be copied into it.
* Inside it, for each scan a directory will be created.
* Inside it, for each desired binning a directory will be created. This directory will contain the relevant *.xye* and *.gsa* files.
* If several scans are present in the *.dat* file, an additional directory, named *All_scans* will be created, which will contain *.xye* and *.gsa* files for each binning, after processing **all** the scans in the current *.dat* file.

## Notes

This script compiles the data only for each scan, and then for all scans. If you need to compile for several selected scans, or using just some of the detectors - please do it manually.

* If for *all* the scans just few of the detectors are needed, it can be easily achieved using the `SUM_BIN_EXTRA_PARAMS` parameter.

## Troubleshooting

If for some reason the scans are not consecutively numbered in the *.dat* file (happened before!), the script will give an error and exit. In such case, please fix the scan numbering in the *.dat* file manually.

## Licensing

Distributed under GPLv2. You can find the full license text [here](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html).
