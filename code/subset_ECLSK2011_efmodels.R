#**************************************************************************
# Title: subset_ECLSK2011_efmodels.R
# Author: William Murrah
# Description: Script to create analytic ECLSK2011 file.
# Created: Thursday, 09 January 2020
# R version: R version 3.6.2 (2019-12-12)
# Directory: /home/hank01/Projects/ECLSK_Manage
#**************************************************************************
# packages used -----------------------------------------------------------
library(EdSurvey)

eclsk11 <- readECLS_K2011("~/qmer/source_data/ECLS_K/2011")

# ID varibles
ids <- c("childid", "parentid", "psuid")

# Demographics
demog <- c("x_chsex_r", "x_raceth_r")
age <- c("x1kage_r", "x2kage_r", paste0("x", 3:8, "age"))

# Cognitive
numrev <- c(paste0("x", 1:8, "nrwabl"), paste0("x", 1:8, "nrsscr"))

flank <- "x8flanker"

dccs <- c(paste0("x",1:4, "dccstot"), (paste0("x", 5:8, "dccsscr")))

math <- paste0("x", 1:8, "mscalk5")
read <- paste0("x", 1:8, "rscalk5")
sci <- paste0("x", 2:8, "sscalk5")

# "Non-cognitive"
sknum <- c('x1', 'x2', 'x3', 'x4', 'x4k', 'x5', 'x6', 'x7', 'x8')
socskill <- c(paste0(sknum, "tchapp"),
              paste0(sknum, "tchcon"), 
              paste0(sknum, "tchper"), 
              paste0(sknum, "tchext"), 
              paste0(sknum, "tchint")
)

# Weights
# TODO: Add weights

vars <- c(ids, demog, dccs, numrev, flanker, math, read, sci, socskill)

projdir <- getwd()
#setwd("~/qmer/")
eclsk <- getData(data = eclsk11,
                 varnames = vars,
                 addAttributes = TRUE,
                 omittedLevels = FALSE, 
                 defaultConditions = FALSE)

class(eclsk)
percentile("x1mscalk5", c(10, 50, 100), data = eclsk, 
           weightVar = "w4pf40")

