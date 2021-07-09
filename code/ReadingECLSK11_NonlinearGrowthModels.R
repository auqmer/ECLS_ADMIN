#************************************************************************
# Title: Reading ECLSK 2011 Nonlinear Mixed Effects Achievement Growth Models
# Author: William Murrah
# Description: Analytic modeling process for reading achievement
# Created: Friday, 09 July 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************

require(nlme)


load("~/qmer/Data/ECLS_K/2011/eclska.Rdata")


# Base Models -------------------------------------------------------------

### Logistics ###
readlogisA <- nlme(Reading ~ SSlogis(time2, Asym, xmid, scal),
                   data = eclska, na.action = na.omit,
                   fixed = Asym + xmid + scal ~ 1,
                   random = Asym  ~ 1,
                   group = ~ id,
                   start = c(Asym = 120, xmid = 3.4, scal = 4.2))

readlogisAX <- update(readlogisA,
                      random = Asym + xmid ~ 1)

readlogisAXS <- update(readlogisA,
                       random = Asym + xmid + scal ~ 1)


save(readlogisA, readlogisAX, readlogisAXS, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/readlogisModels.Rdata")

### Gompertz ###
readgompA <- nlme(Reading ~ SSgompertz(time2, Asym, b2, b3),
                  data = eclsk, na.action = na.omit,
                  fixed = Asym + b2 + b3 ~ 1,
                  random = Asym ~ 1 | id,
                  start = c(Asym = 124, b2 = 1.2, b3 = .6))


readgompAB <- update(readgompA,
                     random = Asym + b2 ~ 1 | id)

readgompABB <- update(readgompAB,
                      random = Asym + b2 + b3 ~ 1 |id)


save(readgompA, readgompAB, readgompABB, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/readgompModels\
     .Rdata")

### Richards ###

library(FlexParamCurve)

readrich.nls <- nls(Reading ~ SSfpl(time2, A, B, xmid, scal),
                    data = eclska, na.action = na.omit)
summary(readrich.nls)
readrichB <- nlme(Reading ~ SSfpl(time2, A, B, xmid, scal),
                  data = eclska, na.action = na.omit,
                  fixed = A + B + xmid + scal ~ 1,
                  random = B  ~ 1 | id,
                  start = c(A = -135.61, B = 133.67, xmid = -1.33, scal = 2.35))

## No convergence
readrichBX <- update(readrichB,
                     random = B + xmid ~ 1 | id)

## No convevergence
readrichBS <- update(readrichB,
                     random = B + scal ~ 1 | id)


save(readrichB, file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/readrichModel.Rdata")
