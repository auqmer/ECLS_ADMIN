#************************************************************************
# Title: subset ECLSK 7 primary time points
# Author: William Murrah
# Description: description
# Created: Thursday, 01 July 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************
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
        ` 0` = 0L,
        ` 1` = 1L,
        ` 3` = 3L,
        ` 5` = 5L,
        ` 6` = 7L,
        ` 7` = 9L,
        ` 8` = 11L))

eclska7_100 <- eclska7[eclska7$id %in% ids100, ]

save(eclska7, file = "~/qmer/Data/ECLS_K/2011/eclska7.Rdata")
save(eclska7_100, file = "~/qmer/Data/ECLS_K/2011/eclska7_100.Rdata")
