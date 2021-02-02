#**************************************************************************
# Title: subset_ECLSK2011_efmodels.R
# Author: William Murrah
# Description:
# Created: Thursday, 09 January 2020
# R version: R version 3.6.2 (2019-12-12)
# Directory: /home/hank01/Projects/ECLSK_Manage
#**************************************************************************
# packages used -----------------------------------------------------------
  
library(EdSurvey)
library(data.table)

load("/media/hank01/source_data/ECLS_K/2011/eclsk2011.Rds")

ids <- c("childid", "parentid", "psuid")

# Demographics
demog <- c("x_chsex_r", "x_raceth_r")
age <- c("x1kage_r", "x2kage_r", paste0("x", 3:8, "age"))

# Cognitive
numrev <- c(paste0("x", 1:8, "nrwabl"), paste0("x", 1:8, "nrsscr"))

flank <- "x8flanker"

dccs <- c(paste0("x",1:4, "dccstot"), (paste0("x", 5:8, "dccsscr")))

math <- paste0("x", 1:8, "mscalk4")
read <- paste0("x", 1:8, "rscalk4")
sci <- paste0("x", 2:8, "sscalk4")

# "Non-cognitive"
sknum <- c('x1', 'x2', 'x3', 'x4', 'x4k', 'x5', 'x6', 'x7', 'x8')
socskill <- c(paste0(sknum, "tchapp"),
              paste0(sknum, "tchcon"), 
              paste0(sknum, "tchper"), 
              paste0(sknum, "tchext"), 
              paste0(sknum, "tchint")
)

vars <- c(ids, demog, dccs, numrev, math, read, sci, socskill)

eclsk <- getData(eclsk2011, varnames = vars, addAttributes = TRUE,
                 omittedLevels = FALSE, defaultConditions = FALSE)

mode(eclsk)
percentile("x1mscalk4", c(10, 50, 100), data = eclsk, 
           weightVar = "w4pf40")
