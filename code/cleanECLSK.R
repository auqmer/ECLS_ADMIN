#************************************************************************
# Title: clean ECLSK EF data
# Author: William Murrah
# Description: Prepare data for analysis
# Created: Wednesday, 23 June 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************
library(dplyr)
tb <- function(x) {
  table(x, useNA = "always")
}

load("~/qmer/Data/ECLS_K/2011/eclsk.Rdata")
eclsk <- transform(eclsk,
                   childid = factor(childid),
                   parentid = factor(parentid))


# Recode missing values (but not others such as Not applicable).
nas <- c("-9: NOT ASCERTAINED")

for(i in 1:length(names(eclsk))) {
  if(is.factor(eclsk[ , i])) {
    levels(eclsk[ , i])[levels(eclsk[ ,i]) %in% nas] <- NA 
  }
}


# Relevel specific factors

eclsk$x1ksctyp <- relevel(eclsk$x1ksctyp, ref = "4: PUBLIC")


# Recode covariates

# create 4 category race  and prek variables
eclsk <- eclsk %>% 
  mutate(
    # Create 4 category race variable.
    race = recode_factor(x_raceth_r,
                         `1: WHITE, NON-HISPANIC` = "White",
                         `2: BLACK/AFRICAN AMERICAN, NON-HISPANIC` =  "Black",
                         `3: HISPANIC, RACE SPECIFIED` = "Hispanic",
                         `4: HISPANIC, NO RACE SPECIFIED` = "Hispanic",
                         .default = "other"),
    # Create 4 category prekindergarten care variable.
    prek = recode_factor(x12primpk,
                         `0: NO NONPARENTAL CARE` = "none",
                         `1: RELATIVE CARE IN CHILD'S HOME` = "relative",
                         `2: RELATIVE CARE IN ANOTHER HOME` = "relative",
                         `3: RELATIVE CARE, LOCATION VARIES/NOT ASKED` =
                             "relative",
                          `4: NONRELATIVE CARE IN CHILD'S HOME` =
                             "non-relative",
                         `5: NONRELATIVE CARE IN ANOTHER HOME` = 
                             "non-relative",
                         `6: NONRELATIVE CARE, LOCATION VARIES/NOT ASKED` = 
                             "non-relative",
                         `7: CENTER-BASED PROGRAM` = "center",
                         `8: 2 OR MORE TYPES OF CARE WITH EQUAL HOURS` = 
                                "center"),
    # 
    )





save(eclsk, file = "~/qmer/Data/ECLS_K/2011/eclsk_clean.Rdata")

rm(i, nas, tb)
