#************************************************************************
# Title: ECLSK:11 Nonlinear Growth Curve Analyses
# Author: William Murrah
# Description: Nonlinear Mixed Effects Growth Curves replicating 
#              Cameron et. al (2015) article with more recent data and
#              science achievement outcomes.
# Created: Thursday, 08 July 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************
# package used ------------------------------------------------------------

library(nlme)

# Data --------------------------------------------------------------------


#### TODO: reconcile data frame missingness. Currently in the middle of
#.         playing with complete case data 


# load("~/qmer/Data/ECLS_K/2011/eclska7.Rdata")
load("~/qmer/Data/ECLS_K/2011/eclska.Rdata")

eclsk <- eclska[complete.cases(eclska[ ,c(3:4, 7,10)]), ]
# Math --------------------------------------------------------------------


# Reading -----------------------------------------------------------------

readgompA <- nlme(Math ~ SSgompertz(time2, Asym, b2, b3),
                  data = eclska, na.action = na.omit,
                  fixed = Asym + b2 + b3 ~ 1,
                  random = Asym ~ 1 | id,
                  start = c(Asym = 124, b2 = 1.2, b3 = .6))

readgompAB <- update(readgompA,
                     random = Asym + b2 ~ 1 |id)

readgompABB <- update(readgompAB,
                      random = Asym + b2 + b3 ~ 1 | id,
                      start = c(Asym = 126, b2 = 1.2, b3 = .6)
                      )

save(readgompA, readgompAB, readgompABB, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/readgompModels.\
     Rdata")
# Science -----------------------------------------------------------------

sciencegomp.nls <- nls(Science ~ SSgompertz(time2-.5, Asym, b2, b3),
                       data = eclsk, na.action = na.omit)
sciencegompAB <-  nlme(Science ~ SSgompertz(time2-.5, Asym, b2, b3),
                      data = eclsk, 
                      na.action = na.omit, 
                      fixed = Asym + b2 + b3 ~ 1,
                      random = Asym + b2 ~ 1 | id,
                      start = c(Asym = 85.12, b2 = .97, b3 = .71))

sciencegompAB <- update(sciencegompA,
                        random = Asym + b2 ~ 1 | id)
sciencegompABB <- update(mathgompABB, Science ~ 1 | id)

save(sciencegompAB, file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/\
     sciencegompModels.Rdata")



eclskcc <- eclska[complete.cases(eclska[ ,c("Science", "time2")]), ]

plot(resid(sciencegompAB) ~ SES, data = eclskcc)
abline(h = 0, col = "red")

sciRE <- ranef(sciencegompAB, augFrame = TRUE)
plot(ranef(sciencegompAB, augFrame = TRUE) ~ Sex*Race)
abline(h=0, col = "red")
MathRE <- random.effects(mathgompA, augFrame = TRUE, which = c(3,4), omitGroupingFactor = T)
