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

# Covariate Models --------------------------------------------------------


eclskmath <- eclska[complete.cases(eclska[ , c("Math", "time2", "Race", "Sex", "SES")]), ]
load("~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/mathgompModels
     .Rdata")

mathbase.nls <- nls(Math ~ SSgompertz(time2, Asym, b2, b3),
                    data = eclskmath, na.action = na.omit)



mathbase <- update(mathgompAB,
                   data = eclskmath,
                   start = c(Asym = 127, b2 = 1.26, b3 = .6))


## b2 covariates

math0_Race <-  update(mathbase,
                      fixed = list(Asym ~ 1, b2 ~ Race, b3 ~ 1),
                      start = c(Asym = 127, b2 = 1.3, Race = c(0,0,0,0),  b3 = .6))
## Asym

math_SES <- update(mathbase,
                   fixed = list(Asym ~ SES, b2 ~ 1, b3 ~ 1),
                   start = c(Asym = 127, SES = 0, b2 = 1.2, b3 = .6))
math_Race <- update(mathbase,
                    fixed = list(Asym ~ Race, b2 ~ 1, b3 ~ 1),
                    start = c(Asym = 127, Race = c(0,0,0,0), b2 = 1.3, b3 = .6))

math_RxS <- update(mathbase,
                  fixed = list(Asym ~ Race*SES, b2 ~ 1, b3 ~ 1),
                  start = c(Asym = 127, Race = c(0,0,0,0), SES = 0, 
                            `Race:SES` = c(0,0,0,0), b2 = 1.2, b3 = .6))

math_RS <- update(mathbase,
                   fixed = list(Asym ~ Race + SES, b2 ~ 1, b3 ~ 1),
                   start = c(Asym = 127, Race = c(0,0,0,0), SES = 0, 
                             b2 = 1.2, b3 = .6))

math_RxSxG <-  update(mathbase,
                      fixed = list(Asym ~ Race + SES + Sex + Race:SES +
                                     Race:Sex + SES:Sex + Race:SES:Sex, b2 ~ 1, b3 ~ 1),
                      start = c(Asym = 127, Race = c(-13.5,-5.3, 5, -2.3), 
                                SES = 7.5, Sex =0, `Race:SES` = c(0,0,0,0),
                                `Race:Sex` = c(0,0,0,0), `SES:Sex` = 0,
                                `Race:SES:Sex` = c(0,0,0,0),
                                b2 = 1.3, b3 = .6))
math_RSxG <-  update(mathbase,
                    fixed = list(Asym ~ Race + SES + Sex + Race:Sex + SES:Sex, b2 ~ 1, b3 ~ 1),
                    start = c(Asym = 127, Race = c(-13,-5,2), SES = 7.5, Sex =0,
                              `Race:Sex` = c(0,0,0,0), `SES:Sex` = 0,
                              b2 = 1.3, b3 = .6))

math_RxSG <-  update(mathbase,
                      fixed = list(Asym ~ Race + SES + Sex + Race:SES, 
                                   b2 ~ 1, b3 ~ 1),
                      start = c(Asym = 127, Race = c(-13.5,-5.3, 5, -2.3), 
                                SES = 7.5, Sex =0, `Race:SES` = c(0,0,0,0),
                                b2 = 1.3, b3 = .6))

math_RSG <-  update(mathbase,
                    fixed = list(Asym ~ Race + SES + Sex, b2 ~ 1, b3 ~ 1),
                    start = c(Asym = 127, Race = c(-13,-5,2), SES = 7.5, Sex =0,
                              b2 = 1.3, 
                              b3 = .6))

## Asym and b2

mathA_Race <-  update(mathbase,
                      fixed = list(Asym ~ Race*SES + Sex, b2 ~ Race, b3 ~ 1),
                      start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                                SES = 7.5, Sex =0, 
                                `Race:SES` = c(1.6, 0, -3, 2.3),
                                b2 = 1.3, Race = c(0,0,0,0),
                                b3 = .6))

mathA_RxS <-  update(mathbase,
                     fixed = list(Asym ~ Race*SES + Sex, b2 ~ Race*SES, b3 ~ 1),
                     start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                               SES = 7.5, Sex =0, 
                               `Race:SES` = c(1.6, 0, -3, 2.3),
                               b2 = 1.3, Race = c(0,0,0,0), SES = 0,
                               `Race:SES` = c(0,0,0,0),
                               b3 = .6))

mathA_S <-  update(mathbase,
                     fixed = list(Asym ~ Race*SES + Sex, b2 ~ SES, b3 ~ 1),
                     start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                               SES = 7.5, Sex =0, 
                               `Race:SES` = c(1.6, 0, -3, 2.3),
                               b2 = 1.3,  SES = 0,
                               b3 = .6))
mathA_RS <-   update(mathbase,
                     fixed = list(Asym ~ Race*SES + Sex, b2 ~ Race + SES, b3 ~ 1),
                     start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                               SES = 7.5, Sex =0, 
                               `Race:SES` = c(1.6, 0, -3, 2.3),
                               b2 = 1.3, Race = c(0,0,0,0), SES = 0,
                               b3 = .6)) 

mathA_RxSxG <-  update(mathbase,
                       fixed = list(Asym ~ Race*SES + Sex, b2 ~ Race*SES*Sex, b3 ~ 1),
                       start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                                 SES = 7.5, Sex =0, 
                                 `Race:SES` = c(1.2, 0, -3, 2),
                                 b2 = 1.3, Race = c(0,0,0,0), SES = 0, Sex = 0,
                                 `Race:SES` = c(0,0,0,0), 
                                 `Race:Sex` = c(0,0,0,0),
                                 `SES:Sex`=0, 
                                 `Race:SES:Sex`=c(0,0,0,0),
                                 b3 = .6)) 
mathA_RxSxG2way <-  update(mathbase,
                           fixed = list(Asym ~ Race*SES + Sex, b2 ~ Race + SES +
                                          Sex + Race:SES +
                                          Race:Sex + SES:Sex, 
                                        b3 ~ 1),
                           start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                                     SES = 7.5, Sex =0, 
                                     `Race:SES` = c(1.2, 0, -3, 2),
                                     b2 = 1.3, Race = c(0,0,0,0), SES = 0, 
                                     Sex = 0,
                                     `Race:SES` = c(0,0,0,0), 
                                     `Race:Sex` = c(0,0,0,0),
                                     `SES:Sex`= 0, 
                                     b3 = .6)) 

mathA_RxSG2way <- update(mathbase,
                         fixed = list(Asym ~ Race*SES + Sex, b2 ~ Race + SES +
                                        Sex + Race:SES +
                                        SES:Sex, 
                                      b3 ~ 1),
                         start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                                   SES = 7.5, Sex =0, 
                                   `Race:SES` = c(1.2, 0, -3, 2),
                                   b2 = 1.3, Race = c(0,0,0,0), SES = 0, 
                                   Sex = 0,
                                   `Race:SES` = c(0,0,0,0), 
                                   `SES:Sex`= 0, 
                                   b3 = .6)) 

mathA_RSxG2way <- update(mathbase,
                         fixed = list(Asym ~ Race*SES + Sex, b2 ~ Race + SES +
                                        Sex +
                                        SES:Sex, 
                                      b3 ~ 1),
                         start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                                   SES = 7.5, Sex =0, 
                                   `Race:SES` = c(1.2, 0, -3, 2),
                                   b2 = 1.3, Race = c(0,0,0,0), SES = 0, 
                                   Sex = 0, 
                                   `SES:Sex`= 0, 
                                   b3 = .6)) 
mathA_RSG <-  update(mathbase,
                           fixed = list(Asym ~ Race + SES + Sex, b2 ~ Race + 
                                          SES + Sex, b3 ~ 1),
                           start = c(Asym = 127, Race = c(-13,-5,2), SES = 7.5, 
                                     Sex =-3.1,
                                     b2 = 1.2, Race = c(0,0,0), SES = 0, 
                                     Sex = 0,
                                     b3 = .6))

mathA_B_S <- update(mathbase,
                    fixed = list(Asym ~ Race*SES + Sex, 
                                 b2 ~ Race + SES +
                                   Sex + Race:SES +
                                   SES:Sex, 
                                 b3 ~ SES),
                    start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                              SES = 7.5, Sex =0, 
                              `Race:SES` = c(1.2, 0, -3, 2),
                              b2 = 1.3, Race = c(0,0,0,0), SES = 0, 
                              Sex = 0, 
                              `Race:SES` = c(0,0,0,0),
                              `SES:Sex`= 0, 
                              b3 = .6, SES = 0))

mathA_B_R <- update(mathbase,
                    fixed = list(Asym ~ Race*SES + Sex, b2 ~ Race + SES +
                                   Sex + Race:SES +
                                   SES:Sex, 
                                 b3 ~ Race),
                    start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                              SES = 7.5, Sex =0, 
                              `Race:SES` = c(1.2, 0, -3, 2),
                              b2 = 1.3, Race = c(0,0,0,0), SES = 0, 
                              Sex = 0, 
                              `Race:SES` = c(0,0,0,0),
                              `SES:Sex`= 0, 
                              b3 = .6, Race = c(0,0,0,0)))

# Best fitting Model for math
mathA_B_RxG <- update(mathbase,
                    fixed = list(Asym ~ Race*SES + Sex, 
                                 b2 ~ Race + SES +
                                   Sex + Race:SES +
                                   SES:Sex, 
                                 b3 ~ Race*Sex),
                    start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                              SES = 7.5, Sex =0, 
                              `Race:SES` = c(1.2, 0, -3, 2),
                              b2 = 1.3, Race = c(0,0,0,0), SES = 0, 
                              Sex = 0, 
                              `Race:SES` = c(0,0,0,0),
                              `SES:Sex`= 0, 
                              b3 = .6, Race = c(0,0,0,0), Sex = 0,
                              `Race:Sex`=c(0,0,0,0)))

mathA_B_RG <- update(mathbase,
                    fixed = list(Asym ~ Race*SES + Sex, b2 ~ Race + SES +
                                   Sex +
                                   SES:Sex, 
                                 b3 ~ Race + Sex),
                    start = c(Asym = 127, Race = c(-13,-5,6,-2.3), 
                              SES = 7.5, Sex =0, 
                              `Race:SES` = c(1.2, 0, -3, 2),
                              b2 = 1.3, Race = c(0,0,0,0), SES = 0, 
                              Sex = 0, 
                              `SES:Sex`= 0, 
                              b3 = .6, Race = c(0,0,0,0), Sex = 0))

save(math_Race, math_RS, math_RxS, math_RxSG, math_RxSxG, 
     math_SES, math0_Race, mathA_B_G, mathA_B_R, mathA_B_RG, 
     mathA_B_RxG, mathA_B_S, mathA_Race, mathA_RS, mathA_RSxG2way, 
     mathA_RxS, mathA_RxSG2way, mathA_RxSxG, mathA_RxSxG2way, 
     mathA_S, mathbase, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/mathCovariateModels.Rdata")
