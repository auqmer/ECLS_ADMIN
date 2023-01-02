#------------------------------------------------------------------------
# Title: Create Pretty Names for ECLSK 2011 Multiple Imputation Data
# Author: William Murrah
# Description: Create publication quality names for Gompertz curve MI data
# Created: Monday, 07 November 2022
# R version: R version 4.2.1 (2022-06-23)
# Project(working) directory: /home/wmmurrah/Projects/QMER/ECLS_ADMIN
#------------------------------------------------------------------------

library(data.table)
library(dplyr)
library(mice)
load(file = "~/qmer/Data/ECLS_K/2011/eclskmi20long.Rdata")

# Transform mids object to data frame.
eclska <- complete(eclskmi20_long, action = "long", include = TRUE)
rm(eclskmi20_long)
gc()
eclska <- data.table(eclska)
gc()

eclska <- eclska[ ,.(
  .imp = .imp,
  .id = .id,
  id = childid,
  pid = parentid,
  Sex = x_chsex_r,
  Race = race,
  Age = age,
  Time = time,
  SES = x12sesl,
  PreK = prek,
  District_Poverty = x_distpov,
  Parent_Age = x1par1age,
  Number_Siblings = x1numsib,
  Math = math,
  Reading = read,
  Science = sci,
  DCCS = dccs,
  Numbers_Reversed = nrsscr,
  Numbers_Reversed_Wability = nrwabl
)]

eclska$Sex <- factor(eclska$Sex, labels = c("Male", "Female"))

levels(eclska$Time) <- c("Fall kindergarten", "Spring kindergarten",
                         "Fall first-grade", "Spring first-grade",
                         "Fall second-grade", "Spring second-grade",
                         "Spring third-grade", "Spring fourth-grade",
                         "Spring fifth-grade")

eclska$time <- as.numeric(eclska$Time)-1
eclska <- eclska %>% 
  mutate(time2 = dplyr::recode(time,
                               `0` = 0,
                               `1` = .5,
                               `2` = 1,
                               `3` = 1.5,
                               `4` = 2,
                               `5` = 2.5,
                               `6` = 3.5,
                               `7` = 4.5,
                               `8` = 5.5))

gc()

# Convert data.table back to mids object.
eclskmi20_longPN <- as.mids(eclska)
save(eclskmi20_longPN, file = "~/qmer/Data/ECLS_K/2011/eclskmi20longPN.Rdata")
