# ************************************************************************
# Title: subset ECLSK 7 primary time points
# Author: William Murrah
# Description: description
# Created: Thursday, 01 July 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
# ************************************************************************
library(dplyr)

load("~/qmer/Data/ECLS_K/2011/eclska.Rdata")

Timelevels <- c("Fall kindergarten", "Spring kindergarten",  
                "Spring first-grade", "Spring second-grade", 
                "Spring third-grade", "Spring fourth-grade", "Spring fifth-grade"
)



eclska7 <- eclska[eclska$Time %in% Timelevels, ]

eclska7$time <- as.numeric(eclska7$Time)-1

eclska7 <- eclska7 %>% 
  mutate(time2 = recode(time,
        ` 0` = 0,
        ` 1` = .5,
        ` 3` = 1.5,
        ` 5` = 2.5,
        ` 6` = 3.5,
        ` 7` = 4.5,
        ` 8` = 5.5))


save(eclska7, file = "~/qmer/Data/ECLS_K/2011/eclska7.Rdata")
