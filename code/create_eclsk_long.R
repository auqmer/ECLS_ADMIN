#************************************************************************
# Title: ECLSK wide to long
# Author: William Murrah
# Description: Create long version of ECLSK data for growth models
# Created: Thursday, 24 June 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************
library(data.table)

load("~/qmer/Data/ECLS_K/2011/eclsk_clean.Rdata")

# Load vectors of variables names by category
source("code/variableNames.R")

eclskdt <- data.table(eclsk)

eclsklong <- melt(eclskdt, variable.name = "time",
                  measure = list(
                    age = age,
                    sids = sids,
                    sloc = sloc,
                    math = math,
                    read = read,
                    sci  = sci,
                    tchapp = tchapp,
                    tchcon = tchcon,
                    tchext = tchext,
                    tchint = tchint,
                    tchper = tchper,
                    dccs = dccs,
                    nrsscr = nrsscr,
                    nrwabl = nrwabl
                    )
                  )

save(eclsklong, file = "~/qmer/Data/ECLS_K/2011/eclsklong.Rdata")
