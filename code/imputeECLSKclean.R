#------------------------------------------------------------------------
# Title: Impute data for multiple imputation analyses
# Author: William Murrah
# Description: Use `mice` to impute data in wide format before creating
#             long data. 
# Created: Tuesday, 30 August 2022
# Modified: 2022/12/07 to use futuremice on HPC cluster Easley
# R version: R version 4.2.1 (2022-06-23)
# Project(working) directory: /home/wmmurrah/Projects/QMER/ECLS_ADMIN
#------------------------------------------------------------------------
library(mice)
library(data.table)
library(tidyverse)
# Load imputation objects
load("~/qmer/Data/ECLS_K/2011/eclskimpObjects.Rdata")
source("code/variableNames.R")
# Run imputation
nimps <- 20
startTime <- Sys.time()
eclskmi20 <- mice(data = eclskimp, m = nimps, 
                        maxit = 50, 
                        predictorMatrix = pred,
                 visitSequence = visitseq)

endTime <- Sys.time()

endTime-startTime


#plot(eclskmi20)

# Transform imputed data from wide to long
# following code modified from: https://stats.stackexchange.com/questions/515598/is-it-possible-to-imput-values-using-mice-package-reshape-and-perform-gee-in-r
eclskmi20complete <- complete(eclskmi20, action = "long", include = TRUE)
# Create column for unmeasured science scores at k entry.
eclskmi20complete$x1sscalk5 <- NA

working_dats <- list()
for(i in 0:max(eclskmi20complete$.imp)) {
  working_dats[[i+1]] <- 
    eclskmi20complete %>%
    subset(.imp == i) %>%
    #data.table() %>% 
    data.table::melt(variable.name = "time",
         measure  = list(
           age    = variableNames[["age"]],
           sids   = variableNames[["sids"]],
           sloc   = variableNames[["sloc"]],
           math   = variableNames[["math"]],
           read   = variableNames[["read"]],
           sci    = c("x1sscalk5", variableNames[["sci"]]),
           tchapp = variableNames[["tchapp"]],
           tchcon = variableNames[["tchcon"]],
           tchext = variableNames[["tchext"]],
           tchint = variableNames[["tchint"]],
           tchper = variableNames[["tchper"]],
           dccs   = variableNames[["dccs"]],
           nrsscr = variableNames[["nrsscr"]],
           nrwabl = variableNames[["nrwabl"]]
         )) %>%
    mutate(.id = 1:nrow(.))
}
eclskmi20_long <- as.mids(do.call(rbind, working_dats))


# Save imputed data in R drive
# Check that wmmurrah/qmer is attached
save(eclskmi20, file = "~/qmer/Data/ECLS_K/2011/eclskmi20_vs2.Rdata")

save(eclskmi20_long, file = "~/qmer/Data/ECLS_K/2011/eclskmi20long.Rdata")
