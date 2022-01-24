# ************************************************************************
# Title: createAnalyticDataPrettyNames.R
# Author: William Murrah
# Description: Subset data to analytic variables with publication 
#              quality names.
# Created: Wednesday, 30 June 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
# ************************************************************************
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
  "nrwabl",
  "w9c29p_9a0",
  "w9c29p_9astr",
  "w9c29p_9apsu"
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
  `Numbers Reversed (W-ability)` = nrwabl,
  `w9c29p_9a0` = w9c29p_9a0,
  `w9c29p_9astr` = w9c29p_9astr,
  `w9c29p_9apsu` = w9c29p_9apsu
  )]

eclska$Sex <- factor(eclska$Sex, labels = c("Male", "Female"))

levels(eclska$Time) <- c("Fall kindergarten", "Spring kindergarten",
                         "Fall first-grade", "Spring first-grade",
                         "Fall second-grade", "Spring second-grade",
                         "Spring third-grade", "Spring fourth-grade",
                         "Spring fifth-grade")

eclska$time <- as.numeric(eclska$Time)-1
eclska <- eclska %>% 
  mutate(time2 = recode(time,
                        `0` = 0,
                        `1` = .5,
                        `2` = 1,
                        `3` = 1.5,
                        `4` = 2,
                        `5` = 2.5,
                        `6` = 3.5,
                        `7` = 4.5,
                        `8` = 5.5))

rm(variableNames, analyticVariables)

save(eclska, file = "~/qmer/Data/ECLS_K/2011/eclska.Rdata")
