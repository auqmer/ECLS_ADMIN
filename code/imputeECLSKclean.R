#------------------------------------------------------------------------
# Title: Impute data for multiple imputation analyses
# Author: William Murrah
# Description: Use `mice` to impute data in wide format before creating
 #             long data.
# Created: Tuesday, 30 August 2022
# R version: R version 4.2.1 (2022-06-23)
# Project(working) directory: /home/wmmurrah/Projects/QMER/ECLS_ADMIN
#------------------------------------------------------------------------

library(mice)
library(data.table)
library(tidyverse)
load("~/qmer/Data/ECLS_K/2011/eclsk_clean.Rdata")
# Load vectors of variables names by category
source("code/variableNames.R")

# vector of variables used in the imputation process, both those
# to be imputed and those used in the imputation models.
imputation_variables <- c("childid", "x_chsex_r","x_raceth_r", "x1kage_r",
                          #"x2inccat_i",
                          "x1par1age", #"x12par1ed_i",
                          "x12sesl",  "x1numsib",
                          #"x1par1emp", "x1par2emp",
                          # "x1par1occ_i", "x1par2occ_i",
                          "x1nrsscr", "x1dccstot",
                          "x1mscalk5", "x1rscalk5", "x2sscalk5")

eclskimp <- eclsk


#clskimp$x_chsex_r <- factor(eclskimp$x_chsex_r)
#eclskimp$x_raceth_r <- factor(eclskimp$x_raceth_r)
visitseq <- c("x1par1age", "x1numsib", "x1nrsscr", "x1dccstot",
              "x_chsex_r","x_raceth_r", "x1kage_r","x12sesl",
              "x1mscalk5", "x1rscalk5", "x2sscalk5")


pred <- make.predictorMatrix(eclskimp)
meth <- make.method(eclskimp)
# Remove childid from variables used in imputation
pred[ ,1] <- 0
pred[1, ] <- 0
# Remove all variables but imputation variables from pred matrix
nonimputation_variables <- names(eclskimp)[ !(names(eclskimp) %in% imputation_variables)]
pred[nonimputation_variables, ] <- 0
pred[ , nonimputation_variables] <- 0
meth[nonimputation_variables] <- ""
# Remove kindergarten achievement score from being imputed
pred[c("x1mscalk5", "x1rscalk5", "x2sscalk5"), ] <- 0
meth[c("x1mscalk5", "x1rscalk5", "x2sscalk5")] <- ""

# Drop llevel attribute which seems to be causing problems in imputation call
# for(var in colnames(eclskimp)) {
#   attr(eclskimp[ ,deparse(as.name(var))], "llevels") <- NULL
# }

eclskimp[sapply(eclskimp, is.factor)] <- lapply(eclskimp[sapply(eclskimp, 
                                                                is.factor)],
                                                as.factor)
# Run imputation
startTime <- Sys.time()
eclskmi20 <- mice(eclskimp, m = 20, maxit = 50, predictorMatrix = pred, burn = 10,
                 visitSequence = visitseq)
endTime <- Sys.time()

endTime-startTime

plot(eclskmi20)

# Transform imputed data from wide to long
# following code modified from: https://stats.stackexchange.com/questions/515598/is-it-possible-to-imput-values-using-mice-package-reshape-and-perform-gee-in-r
eclskmi20complete <- complete(eclskmi20, action = "long", include = TRUE)
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

############### using with

eclskmi20long <- with(eclskmi20,
             {
               dat <- data.frame(mget(ls()))
               
               dat_long <- pivot_longer(dat,
                                        cols = c(variableNames[["age"]],
                                                 variableNames[["sids"]],
                                                 variableNames[["sloc"]],
                                                 variableNames[["math"]],
                                                 variableNames[["read"]],
                                                 variableNames[["sids"]],
                                                 c("x1sscalk5", variableNames[["sci"]]),
                                                 variableNames[["tchapp"]],
                                                 variableNames[["tchcon"]],
                                                 variableNames[["tchext"]],
                                                 variableNames[["tchint"]],
                                                 variableNames[["tchper"]],
                                                 variableNames[["dccs"]],
                                                 variableNames[["nrsscr"]],
                                                 variableNames[["nrwabl"]]),
                                        names_to = c("age", "sids", "sloc",
                                                     "math", "read", "tchapp",
                                                     "tchcon", "tchext", "tchint",
                                                     "tchper", "dccs", "nrsscr",
                                                     "nrwabl"))
             })

eclskmi20list <- miceadds::mids2datlist(eclskmi20)

eclskmi20list <- lapply(eclskmi20list, data.table)

eclsk20long <- lapply(eclskmi20list, 
                      pivot_longer(cols = ))

eclskmi20list <- lapply(eclskmi20list, 
                        melt(data = .data,
                             id.vars = c("childid", "parentid"),
                             variable.name = "time",
                             measure.vars  = list(
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
                             )))

eclskmi20long <- with(eclskmi20list, {
  setDT(.)
})
# Save imputed data in R drive
# Check that wmmurrah/qmer is attached
save(eclskmi20, file = "~/qmer/Data/ECLS_K/2011/eclskmi20_vs2.Rdata")

save(eclskmi20_long, file = "~/qmer/Data/ECLS_K/2011/eclskmi20long.Rdata")
