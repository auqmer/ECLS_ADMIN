#************************************************************************
# Title: Math ECLSK 2011 Nonlinear Mixed Effects Achievement Growth Models
# Author: William Murrah
# Description: Analytic modeling process for math achievement
# Created: Friday, 09 July 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************

require(nlme)


load("~/qmer/Data/ECLS_K/2011/eclska.Rdata")


# Base Models -------------------------------------------------------------

### Logistics ###
mathlogisA <- nlme(Math ~ SSlogis(time2, Asym, xmid, scal),
                   data = eclska, na.action = na.omit,
                   fixed = Asym + xmid + scal ~ 1,
                   random = Asym  ~ 1,
                   group = ~ id,
                   start = c(Asym = 120, xmid = 3.4, scal = 4.2))

mathlogisAX <- update(mathlogisA,
                      random = Asym + xmid ~ 1)

mathlogisAXS <- update(mathlogisA,
                       random = Asym + xmid + scal ~ 1)


save(mathlogisA, mathlogisAX, mathlogisAXS, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/mathlogisModels.Rdata")

### Gompertz ###
mathgompA <- nlme(Math ~ SSgompertz(time2, Asym, b2, b3),
                  data = eclsk, na.action = na.omit,
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

### Richards ###

library(FlexParamCurve)

mathrich.nls <- nls(Math ~ SSfpl(time2, A, B, xmid, scal),
                    data = eclska, na.action = na.omit)
summary(mathrich.nls)
mathrichB <- nlme(Math ~ SSfpl(time2, A, B, xmid, scal),
                  data = eclska, na.action = na.omit,
                  fixed = A + B + xmid + scal ~ 1,
                  random = B  ~ 1 | id,
                  start = c(A = -135.61, B = 133.67, xmid = -1.33, scal = 2.35))

## No convergence
mathrichBX <- update(mathrichB,
                     random = B + xmid ~ 1 | id)

## No convevergence
mathrichBS <- update(mathrichB,
                     random = B + scal ~ 1 | id)


save(mathrichB, file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/mathrichModel.Rdata")
