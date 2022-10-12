#------------------------------------------------------------------------
# Title: ECLSKmi20 wide to long
# Author: William Murrah
# Description: Create long version of ECLSK data for growth models
# Created: Tuesday, 04 October 2022
# R version: R version 4.2.1 (2022-06-23)
# Project(working) directory: /home/wmmurrah/Projects/QMER/ECLS_ADMIN
#------------------------------------------------------------------------
library(data.table)
library(dplyr)
# library(purrr)
# library(tibble)
load("~/qmer/Data/ECLS_K/2011/eclskmi20.Rdata")

eclskmilist <- mitml::mids2mitml.list(eclskmi20)
# Load vectors of variables names by category
source("code/variableNames.R")



# Add column of k entry science score (NA) that are missing so each academic
#   subject has the same number of measurements
eclskmilist <- purrr::map(eclskmilist, ~.x %>% 
                     tibble::add_column(x1sscalk5 = NA))

# Convert each imputed data frame to a data.table for using the melt function
eclskdt <- purrr::map(eclskmilist, as.data.table)

eclskmilistlong <- purrr::map(eclskdt, ~.x %>% 
                 data.table::melt(variable.name = "time",
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
                    )
                  )
)

eclsklong <- map(eclskmilistlong, ~.x %>% 
                   setorder(childid, time)
)

save(eclsklong, file = "~/qmer/Data/ECLS_K/2011/eclsklong.Rdata")

rm(variableNames, eclskdt, eclsk)
