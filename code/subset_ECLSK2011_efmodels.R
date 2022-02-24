# **************************************************************************
# Title: subset_ECLSK2011_efmodels.R
# Author: William Murrah
# Description: Script to create analytic ECLSK2011 file.
# Created: Thursday, 09 January 2020
# R version: R version 3.6.2 (2019-12-12)
# Directory: /home/hank01/Projects/ECLSK_Manage
# **************************************************************************
# packages used -----------------------------------------------------------
library(EdSurvey)

eclsk11 <- readECLS_K2011("~/qmer/source_data/ECLS_K/2011")

# Load variable name vectors
source("code/variableNames.R")

# Create Data frame -------------------------------------------------------

# Create vector of all selected variables
vars <- unlist(variableNames)

# Create lightweight data.frame
eclsk <- getData(data = eclsk11,
                 varnames = vars,
                 addAttributes = TRUE,
                 omittedLevels = FALSE, 
                 defaultConditions = FALSE)



# Save raw data file.
save(eclsk, file = "~/qmer/Data/ECLS_K/2011/eclskraw.Rdata")

# Clean objects from environment
rm(vars, variableNames, eclsk11)
