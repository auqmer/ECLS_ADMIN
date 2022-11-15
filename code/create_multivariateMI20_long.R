# ------------------------------------------------------------------------
# Title: Create Multivariate Long Data
# Author: William Murrah
# Description: Create a longdata frame with an Achievement variable and
#              factor for subject (math, reading, science) for 
#              multivariate mixed-effects models from Analytic Data.   
# Created: Tuesday, 15 March 2022
# R version: R version 4.1.2 (2021-11-01)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
# ------------------------------------------------------------------------
library(data.table)
library(mice)
library(dplyr)
load("~/qmer/Data/ECLS_K/2011/eclskmi20longPN.Rdata")

# Create a list of original and imputed data frames
eclskmvalong <- complete(eclskmi20_long, action = "all", include = TRUE)

# Clean up R memory
rm(eclskmi20_long)
gc()

# Stack Achievement subjects in each data frame
eclskmvalong <- lapply(X = eclskmvalong, 
                       FUN = function(x) {
                         melt(data = x, variable.name = "Subject",
                    measure = c("Math", "Reading", 
                                                "Science"),
                 value.name = "Achievement")}
)

# Add .imp variable to each data frame
eclskmvalong <- eclskmvalong %>% 
  bind_rows(.id = ".imp")

# Transform back to mids object for analyses and save.
eclskmvalong <- as.mids(eclskmvalong)
gc()
save(eclskmvalong, file = "~/qmer/Data/ECLS_K/2011/eclskmvalong.Rdata")
