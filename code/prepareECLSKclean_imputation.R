#------------------------------------------------------------------------
# Title: prepare ECLSK data for multiple imputation on cluster
# Author: William Murrah
# Description: this script is the first section of the original imputation
#              script, which prepares the data and mice objects for imputation.
#              This script is used on Franklin and the results copied to 
#              the cluster.
# Created: Wednesday, 14 December 2022
# R version: R version 4.2.2 Patched (2022-11-10 r83330)
# Project(working) directory: /home/wmmurrah/Projects/QMER/ECLS_ADMIN
#------------------------------------------------------------------------

library(mice)
library(data.table)
library(tidyverse)
load("~/qmer/Data/ECLS_K/2011/eclsk_clean.Rdata")
# Load vectors of variables names by category
source("code/variableNames.R")

# vector of variables used in the imputation process, both those
# to be imputed and those used in the imputation models.
imputation_variables <- c("childid", "x_chsex_r","x_raceth_r", 
                          variableNames$age,
                          "x1par1age", 
                          "x12sesl",  "x1numsib",
                          "x1nrsscr", "x1dccstot",
                          "x1mscalk5", "x1rscalk5", "x2sscalk5")

# Remove sampling weights from data
weights <- c("e2hrsspe", "e4hrsspe", "e6hrsspe", "e7hrsspe", "e8hrsspe", 
             "e9hrsspe", "w9c29p_9t91", "w9c29p_9apsu", "w9c29p_9astr", "w9c29p_9t92", 
             "w9c29p_9t93", "w9c29p_9t94", "w9c29p_9t95", "w9c29p_9t96", "w9c29p_9t97", 
             "w9c29p_9t98", "w9c29p_9t99", "w9c29p_9t910", "w9c29p_9t911", 
             "w9c29p_9t912", "w9c29p_9t913", "w9c29p_9t914", "w9c29p_9t915", 
             "w9c29p_9t916", "w9c29p_9t917", "w9c29p_9t918", "w9c29p_9t919", 
             "w9c29p_9t920", "w9c29p_9t921", "w9c29p_9t922", "w9c29p_9t923", 
             "w9c29p_9t924", "w9c29p_9t925", "w9c29p_9t926", "w9c29p_9t927", 
             "w9c29p_9t928", "w9c29p_9t929", "w9c29p_9t930", "w9c29p_9t931", 
             "w9c29p_9t932", "w9c29p_9t933", "w9c29p_9t934", "w9c29p_9t935", 
             "w9c29p_9t936", "w9c29p_9t937", "w9c29p_9t938", "w9c29p_9t939", 
             "w9c29p_9t940", "w9c29p_9t941", "w9c29p_9t942", "w9c29p_9t943", 
             "w9c29p_9t944", "w9c29p_9t945", "w9c29p_9t946", "w9c29p_9t947", 
             "w9c29p_9t948", "w9c29p_9t949", "w9c29p_9t950", "w9c29p_9t951", 
             "w9c29p_9t952", "w9c29p_9t953", "w9c29p_9t954", "w9c29p_9t955", 
             "w9c29p_9t956", "w9c29p_9t957", "w9c29p_9t958", "w9c29p_9t959", 
             "w9c29p_9t960", "w9c29p_9t961", "w9c29p_9t962", "w9c29p_9t963", 
             "w9c29p_9t964", "w9c29p_9t965", "w9c29p_9t966", "w9c29p_9t967", 
             "w9c29p_9t968", "w9c29p_9t969", "w9c29p_9t970", "w9c29p_9t971", 
             "w9c29p_9t972", "w9c29p_9t973", "w9c29p_9t974", "w9c29p_9t975", 
             "w9c29p_9t976", "w9c29p_9t977", "w9c29p_9t978", "w9c29p_9t979", 
             "w9c29p_9t980", "w9c29p_9t90", "w9c29p_9a1", "w9c29p_9a2", "w9c29p_9a3", 
             "w9c29p_9a4", "w9c29p_9a5", "w9c29p_9a6", "w9c29p_9a7", "w9c29p_9a8", 
             "w9c29p_9a9", "w9c29p_9a10", "w9c29p_9a11", "w9c29p_9a12", "w9c29p_9a13", 
             "w9c29p_9a14", "w9c29p_9a15", "w9c29p_9a16", "w9c29p_9a17", "w9c29p_9a18", 
             "w9c29p_9a19", "w9c29p_9a20", "w9c29p_9a21", "w9c29p_9a22", "w9c29p_9a23", 
             "w9c29p_9a24", "w9c29p_9a25", "w9c29p_9a26", "w9c29p_9a27", "w9c29p_9a28", 
             "w9c29p_9a29", "w9c29p_9a30", "w9c29p_9a31", "w9c29p_9a32", "w9c29p_9a33", 
             "w9c29p_9a34", "w9c29p_9a35", "w9c29p_9a36", "w9c29p_9a37", "w9c29p_9a38", 
             "w9c29p_9a39", "w9c29p_9a40", "w9c29p_9a41", "w9c29p_9a42", "w9c29p_9a43", 
             "w9c29p_9a44", "w9c29p_9a45", "w9c29p_9a46", "w9c29p_9a47", "w9c29p_9a48", 
             "w9c29p_9a49", "w9c29p_9a50", "w9c29p_9a51", "w9c29p_9a52", "w9c29p_9a53", 
             "w9c29p_9a54", "w9c29p_9a55", "w9c29p_9a56", "w9c29p_9a57", "w9c29p_9a58", 
             "w9c29p_9a59", "w9c29p_9a60", "w9c29p_9a61", "w9c29p_9a62", "w9c29p_9a63", 
             "w9c29p_9a64", "w9c29p_9a65", "w9c29p_9a66", "w9c29p_9a67", "w9c29p_9a68", 
             "w9c29p_9a69", "w9c29p_9a70", "w9c29p_9a71", "w9c29p_9a72", "w9c29p_9a73", 
             "w9c29p_9a74", "w9c29p_9a75", "w9c29p_9a76", "w9c29p_9a77", "w9c29p_9a78", 
             "w9c29p_9a79", "w9c29p_9a80", "w9c29p_9a0", "x12yrrnd", "x2schbdd", 
             "x4schbdd", "x6schbdd", 
             "x7schbdd", "x8schbdd", "x9schbdd", "x2schedd", "x4schedd", "x6schedd", 
             "x7schedd", "x8schedd", "x9schedd", "c1schedl", "c2schedl", "c3schedl", 
             "c4schedl", "c5schedl", "c6schedl", "c7schedl", "c8schedl", "c9schedl")

eclskimp <- eclsk[ ,!(names(eclsk) %in% weights)]


#clskimp$x_chsex_r <- factor(eclskimp$x_chsex_r)
#eclskimp$x_raceth_r <- factor(eclskimp$x_raceth_r)
visitseq <- c("x1kage_r", "x2kage_r", "x3age", "x4age", "x5age", "x6age", 
              "x7age", "x8age", "x9age","x1par1age", "x1numsib", "x1nrsscr", "x1dccstot",
              "x_chsex_r","x_raceth_r", "x1kage_r","x12sesl",
              "x1mscalk5", "x1rscalk5", "x2sscalk5")


pred <- make.predictorMatrix(eclskimp)
meth <- make.method(eclskimp)
# Remove childid from variables used in imputation
pred[ ,1] <- 0
pred[1, ] <- 0
# Remove all variables but imputation variables from pred matrix
nonimputation_variables <- names(eclskimp)[ !(names(eclskimp) %in% imputation_variables)]
pred[nonimputation_variables, ] <- 0
pred[ , nonimputation_variables] <- 0
meth[nonimputation_variables] <- ""


# Drop llevel attribute which seems to be causing problems in imputation call
# for(var in colnames(eclskimp)) {
#   attr(eclskimp[ ,deparse(as.name(var))], "llevels") <- NULL
# }

eclskimp[sapply(eclskimp, is.factor)] <- lapply(eclskimp[sapply(eclskimp, 
                                                                is.factor)],
                                                as.factor)
save(eclskimp, pred, meth, visitseq,
     file = "~/qmer/Data/ECLS_K/2011/eclskimpObjects.Rdata")
