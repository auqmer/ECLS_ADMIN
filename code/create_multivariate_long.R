# ************************************************************************
# Title: Create Multivariate Long Data
# Author: William Murrah
# Description: Create a longdata frame with an Achievement variable and
#              factor for subject (math, reading, science) for 
#              multivariate mixed-effects models from Analytic Data.   
# Created: Tuesday, 15 March 2022
# R version: R version 4.1.2 (2021-11-01)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
# ************************************************************************
library(data.table)
load("~/qmer/Data/ECLS_K/2011/eclska.Rdata")

eclskmva <- melt(eclska, variable.name = "Subject",
                    measure = c("Math", "Reading", 
                                                "Science"),
                 value.name = "Achievement")

save(eclskmva, file = "~/qmer/Data/ECLS_K/2011/eclskmva.Rdata")
