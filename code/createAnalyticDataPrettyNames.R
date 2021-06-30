#************************************************************************
# Title: createAnalyticDataPrettyNames.R
# Author: William Murrah
# Description: Subset data to analytic variables with publication 
#              quality names.
# Created: Wednesday, 30 June 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************
library(data.table)
library(dplyr)
load("~/qmer/Data/ECLS_K/2011/eclsklong.Rdata")
source("code/variableNames.R")

analyticVariables <- c(
  variableNames[["ids"]],
  variableNames[["demog"]][1:2],
  "age",
  "time",
  "race",
  "x12sesl",
  "x12primpk",
  "x_distpov",
  "prek",
  "math",
  "read",
  "sci",
  "dccs",
  "nrsscr",
  "nrwabl"
)

eclska <- subset(eclsklong, select = analyticVariables)


eclska <- eclska[ ,.(
  id = childid,
  pid = parentid,
  Sex = x_chsex_r,
  Race = race,
  Age = age,
  Time = time,
  SES = x12sesl,
  PreK = prek,
  `District Poverty` = x_distpov,
  Math = math,
  Reading = read,
  Science = sci,
  DCCS = dccs,
  `Numbers Reversed` = nrsscr,
  `Numbers Reversed (W-ability)` = nrwabl
           )]

eclska$Sex <- factor(eclska$Sex, labels = c("Male", "Female"))

levels(eclska$Time) <- c("Fall kindergarten", "Spring kindergarten",
                         "Fall first-grade", "Spring first-grade",
                         "Fall second-grade", "Spring second-grade",
                         "Spring third-grade", "Spring fourth-grade",
                         "Spring fifth-grade")
rm(variableNames, analyticVariables)

save(eclska, file = "~/qmer/Data/ECLS_K/2011/eclska.Rdata")
