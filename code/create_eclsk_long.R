# ***********************************************************************
# Title: ECLSK wide to long
# Author: William Murrah
# Description: Create long version of ECLSK data for growth models
# Created: Thursday, 24 June 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
# ***********************************************************************
library(data.table)
load("~/qmer/Data/ECLS_K/2011/eclsk_clean.Rdata")

# Load vectors of variables names by category
source("code/variableNames.R")

eclskdt <- data.table(eclsk)

# Add empty science score at first time point, as science was not 
# assessed until end of kindergarten year. This is needed to make the
# science score vectors the same length as math and reading.
eclskdt$x1sscalk5 <- NA

eclsklong <- melt(eclskdt, variable.name = "time",
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
                    )
                  )

# Reorder rows by childid and time.
eclsklong <- setorder(eclsklong, childid, time)
save(eclsklong, file = "~/qmer/Data/ECLS_K/2011/eclsklong.Rdata")

rm(variableNames, eclskdt, eclsk)
