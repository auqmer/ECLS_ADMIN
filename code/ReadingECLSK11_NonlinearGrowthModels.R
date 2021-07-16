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
                  data = eclska, na.action = na.omit,
                  fixed = Asym + b2 + b3 ~ 1,
                  random = Asym ~ 1 | id,
                  start = c(Asym = 137, b2 = .92, b3 = .6))


readgompAB <- update(readgompA,
                     random = Asym + b2 ~ 1 | id,
                     start = c(Asym = 139, b2 = .96, b3 = .57))

readgompABB <- update(readgompAB,
                      random = Asym + b2 + b3 ~ 1 |id,
                      start = c(Asym = 139, b2 = .96, b3 = .6))


save(readgompA, readgompAB, readgompABB, 
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/readgompModels\
     .Rdata")

### Richards ###

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



# Covariates --------------------------------------------------------------

eclskread <- eclska[complete.cases(eclska[ , c("Reading", "time2", "Race", "Sex", "SES")]), ]
#save(eclskread, file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/eclskread.Rdata")
load("~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/eclskread.Rdata")
load("~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/readgompModels.Rdata")

readbase.nls <- nls(Reading ~ SSgompertz(time2, Asym, b2, b3),
                    data = eclskread, na.action = na.omit)

readbase <- nlme(Reading ~ SSgompertz(time2, Asym, b2, b3),
                 data = eclskread,
                 fixed = list(Asym ~ 1, b2 ~ 1, b3 ~ 1),
                 random = Asym + b2 ~ 1 | id,
                 start = c(Asym = 141, b2 = .95, b3 = .6))

read_RxSxG <-  update(readbase,
                      fixed = list(Asym ~ Race + SES + Sex + Race:SES +
                                     Race:Sex + SES:Sex + Race:SES:Sex, b2 ~ 1, b3 ~ 1),
                      start = c(Asym = 145, Race = c(0,0,0,0), 
                                SES = 0, Sex =0, `Race:SES` = c(0,0,0,0),
                                `Race:Sex` = c(0,0,0,0), `SES:Sex` = 0,
                                `Race:SES:Sex` = c(0,0,0,0),
                                b2 = .99, b3 = .6))


readFull <- nlme(Reading ~ SSgompertz(time2, Asym, b2, b3),
                 data = eclskread,
                 fixed = list(Asym ~ Race*SES*Sex, 
                                 b2 ~ Race*SES*Sex, 
                                 b3 ~ Race*SES*Sex),
                 random = Asym + b2 + b3 ~ 1 |id,
                 start = c(Asym = 147, 
                           Race = c(-7.4,-3.3,1.2,.2), SES=4.6, Sex=.2,
                           `Race:SES` = c(2.4,.9,-1,1.8), 
                           `Race:Sex`=c(1,1.4,-.7,-.5),
                            `SES:Sex`=.25, `Race:SES:Sex`=c(0,0,0,0),
                            b2=1, 
                           Race=c(0,0,0,0), SES=-.05, Sex=-.01,
                           `Race:SES` = c(0,0,0,0), `Race:Sex`=c(0,0,0,0),
                            `SES:Sex`=0, `Race:SES:Sex`=c(0,0,0,0),
                            b3=.6,
                           Race=c(0,0,0,0), SES=-0, Sex=-0,
                           `Race:SES` = c(0,0,0,0), `Race:Sex`=c(0,0,0,0),
                           `SES:Sex`=0, `Race:SES:Sex`=c(0,0,0,0)))

read_dRxSxG <- update(readFull, . ~ . - Race:SES:Sex)


save(readFull, read_dRxSxG,
     file = "~/qmer/projects/ECLSK11_GrowthCurvePaper2022/data/readCovariateModels.Rdata")
