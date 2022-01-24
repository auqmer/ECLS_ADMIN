# ************************************************************************
# Title: variableNames.R
# Author: William Murrah
# Description: vectors of variables by category. 
# Created: Thursday, 24 June 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
# ************************************************************************
require(dplyr)

sknum <- c('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'x8', 'x9')

variableNames <- list(
  ids = c("childid", "parentid"),
  # Demographics
  demog = c("x_chsex_r", "x_raceth_r", "x1ageent"),
  age = c("x1kage_r", "x2kage_r", paste0("x", 3:9, "age")),
  # Date of birth
  dob = c("x_dobmm_r", "x_dobyy_r"),
  # Family
  income = c("x2inccat_i", "x4inccat_i", "x6inccat_i", 
            "x7inccat_i", "x8inccat_i", "x9inccat_i"),
  parents = c("x1par1age", "x1par1rac", # Parent age and race
             "x12par1ed_i", "x12par2ed_i",    # Parent's highest ed. level
             "x1par1emp", "x1par2emp",        # Parent employment status
             "x1par1occ_i", "x1par2occ_i",    # Parent occupation type
             "x12sesl",                       # SES (composite)
             "x12momar"                       # bio par married at birth
             ),
  household = c("x1htotal", "x2htotal", # Household Counts (total, siblings, 
               "x1numsib", "x2numsib", # less and over 18)
               "x1less18", "x2less18", 
               "x1over18", "x2over18"),
  foodsecurity = c("x2fsscal2", "x2fsadsc2", "x2fschsc", 
                  "x2fsstat2", "x2fsadst2", "x2fschst"),
  # Cognitive
  nrwabl = paste0("x", 1:9, "nrwabl"),
  nrsscr = paste0("x", 1:9, "nrsscr"),
  flanker = c("x8flanker", "x9flanker"),
  dccs = c(paste0("x",1:4, "dccstot"), # Dimensional card sort task
          (paste0("x", 5:9, "dccsscr"))),
  # achievement
  math = paste0("x", 1:9, "mscalk5"),
  read = paste0("x", 1:9, "rscalk5"),
  sci = paste0("x", 2:9, "sscalk5"),
  # "Non-cognitive"
  tchapp = paste0(sknum, "tchapp"),
  tchcon = paste0(sknum, "tchcon"),
  tchper = paste0(sknum, "tchper"),
  tchext = paste0(sknum, "tchext"),
  tchint = paste0(sknum, "tchint"),
  # School variables
  sids = c("s1_id", "s2_id", "s3_id", "s4_id", "s5_id", "s6_id", "s7_id", 
          "s8_id", "s9_id"),
  sloc = c("x1locale", "x2locale", "x3locale", "x4locale", "x5locale", 
          "x6locale", "x7locale", "x8locale", "x9locale"),
  stype = c("x1ksctyp", "x2ksctyp", "x4sctyp", "x6sctyp", 
           "x7sctyp", "x8sctyp", "x9sctyp"),
  schoolvars = c("x2krceth", "x2flch2_i", "x2rlch2_i",
                "x12yrrnd", "x_distpov"),
  # Community variables
  community = c("x1hrsnow", "x12primpk", 
               "x2fsscal2", "x2fsadst2", "x2fsadst2", # 
               "x2fschst"),
  # Weights
  # TODO: select relevant weights for longitudinal analyses.
  # Rounds: 1, 2, 4, 6,7,8,9
  #wts = names(eclsk11$weights)
  wts = c("w9c29p_9t90", "w9c29p_9t91", "w9c29p_9a0", "w9c29p_9apsu",
          "w9c29p_9astr")
)
rm(sknum)
