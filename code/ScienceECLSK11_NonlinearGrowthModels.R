#************************************************************************
# Title: Science ECLSK 2011 Nonlinear Mixed Effects Achievement Growth Models
# Author: William Murrah
# Description: Analytic modeling process for science achievement
# Created: Friday, 09 July 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************

require(nlme)


load("~/qmer/Data/ECLS_K/2011/eclska.Rdata")


# Base Models -------------------------------------------------------------

### Logistics ###
sciencelogisA <- nlme(Science ~ SSlogis(time2-.5, Asym, xmid, scal),
                   data = eclska, na.action = na.omit,
                   fixed = Asym + xmid + scal ~ 1,
                   random = Asym  ~ 1,
                   group = ~ id,
                   start = c(Asym = 120, xmid = 3.4, scal = 4.2))

sciencelogisAX <- update(sciencelogisA,
                      random = Asym + xmid ~ 1,
                      start = c(Asym = 77.8, xmid = .67, scal = 1.8))

sciencelogisAXS <- update(sciencelogisAX,
                       random = Asym + xmid + scal ~ 1)


save(sciencelogisA, sciencelogisAX, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/sciencelogisModels.Rdata")

### Gompertz ###
sciencegompA <- nlme(Science ~ SSgompertz(time2-.5, Asym, b2, b3),
                  data = eclska, na.action = na.omit,
                  fixed = Asym + b2 + b3 ~ 1,
                  random = Asym ~ 1 | id,
                  start = c(Asym = 99.3, b2 = 1.1, b3 = .77))

sciencegompAB <- update(sciencegompA,
                     random = Asym + b2 ~ 1 | id)

sciencegompABB <- update(sciencegompAB,
                      random = Asym + b2 + b3 ~ 1 |id)


save(sciencegompA, sciencegompAB, sciencegompABB, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/sciencegompModels\
     .Rdata")

### Richards ###



sciencerich.nls <- nls(Science ~ SSfpl(time2, A, B, xmid, scal),
                    data = eclska, na.action = na.omit)
summary(sciencerich.nls)
sciencerichB <- nlme(Science ~ SSfpl(time2, A, B, xmid, scal),
                  data = eclska, na.action = na.omit,
                  fixed = A + B + xmid + scal ~ 1,
                  random = B  ~ 1 | id,
                  start = c(A = -135.61, B = 133.67, xmid = -1.33, scal = 2.35))

## No convergence
sciencerichBX <- update(sciencerichB,
                     random = B + xmid ~ 1 | id)

## No convevergence
sciencerichBS <- update(sciencerichB,
                     random = B + scal ~ 1 | id)


save(sciencerichB, file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/sciencerichModel.Rdata")


# Covariates --------------------------------------------------------------

sciencegomp_RSS_RSS_RSS <- update(sciencegompAB, 
                         fixed = list(Asym ~ Race + SES + Sex, 
                                      b2 ~ Race + SES + Sex, 
                                      b3 ~ Race + SES + Sex),
                         start = c(Asym = 88, 
                                   Race = c(0,0,0), SES = 0, Sex = 0,
                                   b2 = 1, Race = c(0,0,0), SES = 0, Sex = 0,
                                   b3 = .8, Race = c(0,0,0), SES = 0, Sex = 0))

sciencegomp_RSS_RSS <- update(sciencegompAB, 
                                  fixed = list(Asym ~ Race + SES + Sex, 
                                               b2 ~ Race + SES + Sex, 
                                               b3 ~ 1),
                                  start = c(Asym = 85, 
                                            Race = c(0,0,0), SES = 0, Sex = 0,
                                            b2 = 1.1, Race = c(0,0,0), SES = 0, 
                                            Sex = 0,
                                            b3 = .8))


save(sciencegomp_RS, sciencegomp_RSS_RSS, sciencegomp_RSS_RSS_RSS, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/scienceCovariates.Rdata")
