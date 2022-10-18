#------------------------------------------------------------------------
# Title: Impute data for multiple imputation analyses
# Author: William Murrah
# Description: Use `mice` to impute data in wide format before creating
 #             long data.
# Created: Tuesday, 30 August 2022
# R version: R version 4.2.1 (2022-06-23)
# Project(working) directory: /home/wmmurrah/Projects/QMER/ECLS_ADMIN
#------------------------------------------------------------------------

library(mice)


load("~/qmer/Data/ECLS_K/2011/eclsk_clean.Rdata")
# Load vectors of variables names by category
source("code/variableNames.R")

# Problem with labels on some factor(s), so removing variables to see which ones:

#str(eclskimp[ , which(sapply(eclskimp, is.factor))])

imputation_variables <- c("childid", "x_chsex_r","x_raceth_r", "x1kage_r",
                          #"x2inccat_i",
                          "x1par1age", #"x12par1ed_i",
                          "x12sesl",  "x1numsib",
                          #"x1par1emp", "x1par2emp",
                          # "x1par1occ_i", "x1par2occ_i",
                          "x1nrsscr", "x1dccstot",
                          "x1mscalk5", "x1rscalk5", "x2sscalk5")



eclskimp <- eclsk[ , imputation_variables]


eclskimp$x_chsex_r <- factor(eclskimp$x_chsex_r)
eclskimp$x_raceth_r <- factor(eclskimp$x_raceth_r)
visitseq <- c("x1par1age", "x1numsib", "x1nrsscr", "x1dccstot",
              "x_chsex_r","x_raceth_r", "x1kage_r","x12sesl",
              "x1mscalk5", "x1rscalk5", "x2sscalk5")

#save(eclskimp, file = "~/qmer/Data/ECLS_K/2011/eclskimp.Rdata")


pred <- make.predictorMatrix(eclskimp)
meth <- make.method(eclskimp)
# Remove childid from variables used in imputation
pred[ ,1] <- 0

# noimp <- c(1, 5, 7:12)
# pred[ noimp, ] <- 0

meth[noimp] <- ""
# Run imputation
startTime <- Sys.time()
eclskmi20 <- mice(eclskimp, m = 20, maxit = 50, predictorMatrix = pred, burn = 10,
                 visitSequence = visitseq)
endTime <- Sys.time()

endTime-startTime

plot(eclskmi20)

imputed <- complete(eclskmi20)
sapply(imputed, function(x) sum(is.na(x)))

save(eclskmi1, file = "data/eclskmi1_withsescomponents.Rdata")

save(eclskmi20, file = "data/eclskmi20_removeSEScomp.Rdata")
bwplot(eclskmi5)

densityplot(eclskmi20)

# Save imputed data in R drive
# Check that wmmurrah/qmer is attached
save(eclskmi20, file = "~/qmer/Data/ECLS_K/2011/eclskmi20_vs1.Rdata")
