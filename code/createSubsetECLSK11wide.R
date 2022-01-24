# ************************************************************************
# Title: Create subset of ECLSK:11 
# Author: William Murrah
# Description: Randomly sample 250 students from ECLSK2011 wide data
# Created: Friday, 09 July 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
# ************************************************************************

load("~/qmer/Data/ECLS_K/2011/eclsk_clean.Rdata")

names(eclsk)

source("code/variableNames.R")

analyticVariables <- c(
  variableNames[["ids"]],
  variableNames[["demog"]][1:2],
  "x1kage_r",
  "x_raceth_r",
  "x12sesl",
  "x12primpk",
  "x_distpov",
  "x12primpk",
  variableNames[["math"]],
  variableNames[["read"]],
  variableNames[["sci"]],
  variableNames[["nrsscr"]],
  variableNames[["nrwabl"]]
)

eclsk <- subset(eclsk, select = analyticVariables)                 

eclsk250 <- eclsk[eclsk$childid %in% sample(eclsk$childid, size = 250, replace = FALSE), ]

save(eclsk250, file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/eclsk250.Rdata")
