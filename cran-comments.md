## Resubmission
This is a resubmission. In this version I have:

* Fixed the clang-UBSAN error

## R CMD check results

There were no ERRORs or WARNINGs.

There were 2 NOTEs:

❯ checking installed package size ... NOTE
    installed size is 57.4Mb
    sub-directories of 1Mb or more:
      libs  56.0Mb

❯ checking for GNU extensions in Makefiles ... NOTE
  GNU make is a SystemRequirements.

Both of the above notes are a consequence of using rstan in the package following the usage steps as described by the stan developers [here](https://cran.r-project.org/web/packages/rstantools/vignettes/minimal-rstan-package.html). Our understanding from the [developers](https://discourse.mc-stan.org/t/using-rstan-in-an-r-package-generates-r-cmd-check-notes/26628) is that they are acceptable to ignore.

## Test environments

The package was tested in the following environments (in GitHub actions):

- Ubuntu 20.04, R release
- Windows latest, R release
- Mac OS latest, R release
- Ubuntu 20.04, R devel


## Downstream dependencies

There are currently no downstream dependencies for this package