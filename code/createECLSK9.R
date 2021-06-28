#************************************************************************
# Title: create ECLSK with only cases with 9 time points
# Author: William Murrah
# Description: Remove cases with fewer than 9 timepoints for exploratory
#              analysis and model building.
# Created: Monday, 28 June 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************


library(dplyr)
load("~/qmer/Data/ECLS_K/2011/eclsklong.Rdata")

ntimepoints <- eclsklong %>% 
  select(childid, age, math) %>% 
  filter(complete.cases(.)) %>% 
  group_by(childid) %>% 
  summarise(no_rows = length(!is.na(math)))


ids9 <- as.character(ntimepoints$childid[ntimepoints$no_rows == 9])
eclsk9 <- subset(eclsklong, childid %in% ids9)

eclsk9$childid <- droplevels(eclsk9$childid)

eclsk9wf <- subset(eclsk9, 
                   x_raceth_r == "1: WHITE, NON-HISPANIC" & 
                   x_chsex_r == "2: FEMALE")

eclsk9wf$childid <- droplevels(eclsk9wf$childid)
save(eclsk9, file = "~/qmer/Data/ECLS_K/2011/eclsk9.Rdata")
save(eclsk9wf, file = "~/qmer/Data/ECLS_K/2011/eclsk9fw.Rdata")
