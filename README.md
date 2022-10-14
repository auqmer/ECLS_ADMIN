

## Dataset Creation Progression for ECLSK 2011

### Local Source File

* The ECLSK 2011 source files are in the directory: "~/qmer/source_data/ECLS_K/2011/".


### Creating Analytic files

* `code/install_ECLSK2011.R` is used to download the ECLSK 2011 files to the qmer drive at:
   "~/qmer/Data/ECLS_K/2011/eclsk2011_v2.Rds" named `eclsk2011.Rdata`. This is the primary `.Rdata` file for the 2011 ECLSK.
   
* The `subset_ECLSK2011_efmodels.R` is used to subset the `eclsk2011.Rdata` to include the variables selected in the `code/variableNames.R` script, to create "~/qmer/Data/ECLS_K/2011/eclskraw.Rdata".

* The `code/cleanECLSK.R` script cleans the "~/qmer/Data/ECLS_K/2011/eclskraw.Rdata" by createing factors, restructuring variables (e.g. race) etc. and creates the "~/qmer/Data/ECLS_K/2011/eclsk_clean.Rdata" data file with cleaned variables.

* The `code/create _eclsk_long.R` script reshapes the data from wide to long format and creates "~/qmer/Data/ECLS_K/2011/eclsklong.Rdata".

* The `code/createAnalyticPrettyNames.R` script subsets the data and creates publication quality variable names resulting in the data file "~/qmer/Data/ECLS_K/2011/eclska.Rdata".

* The `code/create_multivariate_long.R` script takes the "~/qmer/Data/ECLS_K/2011/eclska.Rdata" and stacks the achievement variables and creates a subject factor, resulting in "~/qmer/Data/ECLS_K/2011/eclskmva.Rdata".

### Multiple Imputation Data



