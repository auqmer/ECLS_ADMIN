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
ids <- c("childid", "parentid")

# Demographics
demog <- c("x_chsex_r", "x_raceth_r")
age <- c("x1kage_r", "x2kage_r", paste0("x", 3:8, "age"))
# Date of birth
dob <- c("x_dobmm_r", "x_dobyy_r")



income <- c("x2inccat_i", "x4inccat_i", "x6inccat_i", "x7inccat_i", "x8inccat_i", 
            "x9inccat_i")

# Cognitive
numrev <- c(paste0("x", 1:8, "nrwabl"), paste0("x", 1:8, "nrsscr"))

flanker <- "x8flanker"

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
wts <- names(eclsk11$weights)
# Create vector of all selected variables

# School variables
sids <- searchSDF("SCHOOL IDENTIFICATION NUMBER", eclsk11)$variableName
sloc <- searchSDF("LOCATION TYPE OF SCHOOL", eclsk11)$variableName
vars <- c(ids, age, dob, income, demog, dccs, numrev, flanker, math, read, sci, socskill, 
          sids, sloc)

# Create lightweight data.frame
eclsk <- getData(data = eclsk11,
                 varnames = vars,
                 addAttributes = TRUE,
                 omittedLevels = FALSE, 
                 defaultConditions = FALSE)

class(eclsk)
percentile("x1mscalk5", c(10, 50, 100), data = eclsk, 
           weightVar = "w4pf40")

save(eclsk, file = "~/qmer/Data/ECLS_K/2011/eclsk.Rdata")


edsurveyTable(formula = ~ x_chsex_r + p9curmar, data = eclsk11,
              weightVar = "w9c29p_9t90",
              varMethod = "jackknife")
