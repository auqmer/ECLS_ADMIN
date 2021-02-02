#************************************************************************
# Title: install_ECLSK1998
# Author: William Murrah
# Description: Install ECLSK original data into QMER R drive.
# Created: Saturday, 17 October 2020
# R version: R version 4.0.3 (2020-10-10)
# Project(working) directory: /home/hank01/Projects/CMCaL/ECLSK_Manage
#************************************************************************
library(EdSurvey)

# manually downloaded all zip files and used :
# 7za x Childk8p.dat 
# to extract and combine.


eclsk98 <- readECLS_K1998("~/qmerDrive/source_data/ECLS_K/1998/", 
               filename = "childk8p.dat", 
               layoutFilename = "ECLSK_Kto8_child_SPSS.sps")
eclsk98 <- readECLS_K1998("~/qmerDrive/source_data/ECLS_K/1998/",
            filename = "childk8p.dat", 
            layoutFilename = "ECLSK_Kto8_child_SPSS.sps")
