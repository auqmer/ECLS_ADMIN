#************************************************************************
# Title: clean ECLSK EF data
# Author: William Murrah
# Description: Prepare data for analysis
# Created: Wednesday, 23 June 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************
library(dplyr)
tb <- function(x) {
  table(x, useNA = "always")
}

load("~/qmer/Data/ECLS_K/2011/eclsk.Rdata")
eclsk <- transform(eclsk,
                   childid = factor(childid),
                   parentid = factor(parentid))


# Recode missing values (but not others such as Not applicable).
nas <- c("-9: NOT ASCERTAINED")

for(i in 1:length(names(eclsk))) {
  if(is.factor(eclsk[ , i])) {
    levels(eclsk[ , i])[levels(eclsk[ ,i]) %in% nas] <- NA 
  }
}