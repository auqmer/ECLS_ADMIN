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

# load("~/qmer/Data/ECLS_K/2011/eclska7.Rdata")
load("~/qmer/Data/ECLS_K/2011/eclska.Rdata")

# Math --------------------------------------------------------------------

### Logistics ###
mathlogisA <- nlme(Math ~ SSlogis(time20, Asym, xmid, scal),
                  data = eclska, na.action = na.omit,
                  fixed = Asym + xmid + scal ~ 1,
                  random = Asym  ~ 1,
                  group = ~ id,
                  start = c(Asym = 120, xmid = 3.4, scal = 4.2))

mathlogisAX <- update(mathlogisA,
                      random = Asym + xmid ~ 1)

mathlogisAXS <- update(mathlogisA,
                       random = Asym + xmid + scal ~ 1)


### Gompertz ###

mathgompA <- nlme(Math ~ SSgompertz(time2, Asym, b2, b3),
                  data = eclska, na.action = na.omit,
                  fixed = Asym + b2 + b3 ~ 1,
                  random = Asym ~ 1 | id,
                  start = c(Asym = 124, b2 = 1.2, b3 = .6))


mathgompAB <- update(mathgompA,
                     random = Asym + b2 ~ 1 | id)

mathgompABB <- update(mathgompAB,
                      random = Asym + b2 + b3 ~ 1 |id)


save(mathgompA, mathgompAB, mathgompABB, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/mathgompModels\
     .Rdata")
# Reading -----------------------------------------------------------------

readgompA <- nlme(Math ~ SSgompertz(time2, Asym, b2, b3),
                  data = eclska, na.action = na.omit,
                  fixed = Asym + b2 + b3 ~ 1,
                  random = Asym ~ 1 | id,
                  start = c(Asym = 124, b2 = 1.2, b3 = .6))

readgompAB <- update(readgompA,
                     random = Asym + b2 ~ 1 |id)

readgompABB <- update(readgompA,
                      random = Asym + b2 + b3 ~ 1 | id,
                      start = c(Asym = 126, b2 = 1.2, b3 = .6)
                      )

save(readgompA, readgompAB, readgompABB, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/readgompModels.\
     Rdata")
# Science -----------------------------------------------------------------

scidat <- eclska[eclska$time2 > 0, ]

eclska$timesci <- eclska$time2 - .5
sciencegompA <-  nlme(Science ~ SSgompertz(time2-.5, Asym, b2, b3),
                      data = eclska, 
                      na.action = na.omit, 
                      fixed = Asym + b2 + b3 ~ 1,
                      random = Asym ~ 1 | id,
                      start = c(Asym = 99.3, b2 = 1.1, b3 = .8),
                      control = list(optim = "optim"))

sciencegompAB <- update(sciencegompA,
                        random = Asym + b2 ~ 1 | id)
sciencegompABB <- update(mathgompABB, Science ~ 1 | id)
