#**************************************************************************
# Title: install_ECLSK2011.R
# Author: William Murrah
# Description: Script to download and extract with labels the 2011 ECLSK,
#              using the EdSurvey Package (version 2.3.2). Then a compressed
#              version is saved with source data in ~/Data/ECLSK/2011/
# Created: Tuesday, 31 December 2019
# R version: R version 3.6.2 (2019-12-12)
# Directory: /home/hank01/Projects/ECLSK_Manage
#**************************************************************************
# packages used -----------------------------------------------------------
  
library(EdSurvey)

# Downlaad ECLSK2011
#downloadECLS_K(root = "/media/hank01/source_data/", years = (2011), cache = TRUE)

## Received error that layout file was not downloaded, so manually 
## downloaded and placed in Data folder with .dat file.

# Read .dat file into EdSurvey data frame.
eclsk2011 <- readECLS_K2011("~/qmerDrive/source_data/ECLS_K/2011/", 
                            filename = "childK5p.dat", 
                            layoutFilename = "ECLSK2011_K5PUF.sps")

# Save compressed version of EdSurvey dataframe to save time in future.
saveRDS(eclsk2011, file = "~/qmerDrive/data/ECLS_K/2011/eclsk2011.Rds", 
        compress = TRUE)
