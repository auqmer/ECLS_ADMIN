# scratch_timeAnalyses

library(nlme)


adat <- eclska7_100[complete.cases(eclska7_100$SES), c("id", "Math", "time2","SES",
                                                   "Race", "Sex")]
tmodlogis.nls <- nls(Math ~ SSlogis(time2, Asym, xmid, scal),
                     data = eclska7_100, na.action = na.omit)
summary(tmodlogis.nls)
tmodlogis.lis <- nlsList(Math ~ SSlogis(time2, Asym, xmid, scal) | id,
                         data = eclska7_100,
                         na.action = na.omit)
summary(tmodlogis.nls)
tmodlogis <- nlme(Math ~ SSlogis(time2, Asym, xmid, scal),
                  data = eclska7_100, na.action = na.omit,
                  fixed = Asym + xmid + scal ~ 1,
                  random = Asym  ~ 1,
                  group = ~ id,
                  start = c(Asym = 117, xmid = 2.2, scal = 2.7))
summary(tmodlogis)

tmodlogisAX <- update(tmodlogis, 
                      random = Asym + xmid ~ 1)
anova(tmodlogis, tmodlogisAX)
summary(tmodlogisAX)

tmodlogisAS <- update(tmodlogis,
                      random = Aysm +scal ~ 1,
                      control = list(optim = "optim"))
tmodlogisAXS <- update(tmodlogis,
                       random = Asym + xmid + scal ~ 1  |id,
                       control = nlmeControl(maxIter = 100))

summary(tmodlogisAXS)
anova(tmodlogisAX, tmodlogisAXS)

tmodlogisX <- update(tmodlogis,
                     random = xmid ~ 1)
summary(tmodlogisX)



tmodlogisXS <- update(tmodlogis,
                      random = xmid + scal ~ 1)
summary(tmodlogisXS)
anova(tmodlogisX, tmodlogisXS)

# Gompertz ----------------------------------------------------------------

tmodgomp.nls <- nls(Math ~ SSgompertz(time2, Asym, b2, b3),
                    data = eclska7_100, na.action = na.omit)
summary(tmodgomp.nls)
tmodgompfull <- nlme(Math ~ SSgompertz(time2, Asym, b2, b3),
                 data = eclska7, na.action = na.omit,
                 fixed = Asym + b2 + b3 ~ 1,
                 random = Asym ~ 1 | id,
                 start = c(Asym = 127.5, b2 = 1.3, b3 = .8))
summary(tmodgomp)

tmodgompAB <- update(tmodgomp,
                     random = Asym + b2 ~ 1 | id)
anova(tmodgomp, tmodgompAB)
summary(tmodgompAB)
tmodgompABBfull <- update(tmodgompfull,
                      random = Asym + b2 + b3 ~ 1 | id)
anova(tmodgompAB, tmodgompABB)
summary(tmodgompABB)
anova(tmodgomp, tmodgompABB)

anova(tmodlogisAXS, tmodgompABB)

tmodgompSES <- update(tmodgompABB,
                      fixed = list(Asym ~ SES, b2 + b3 ~ 1),
                      group = ~ id, 
                      start = c(Asym = 127.5, SES = 0, b2 = 1.3, b3 = .8))

anova(tmodgompABB, tmodgompSES)
summary(tmodgompSES)


# Reading -----------------------------------------------------------------


Rtmodgomp <- update(tmodgompABB, Reading ~ .)
summary(Rtmodgomp)



# Science -----------------------------------------------------------------
Smodgomp <- update(tmodgomp, Science ~ .)
summary(Smodgomp)

SmodgompAB <- update(Smodgomp, 
                     random = Asym + b2 ~ 1 | id,
                     control = list(msMaxIter = 100, maxIter = 1000,
                                    optim = "optim"))
anova(Smodgomp, SmodgompAB)


# Richards ----------------------------------------------------------------

modrich.nls <- nls(Math ~ SSfpl(time2, A, B, xmid, scal),
                   data = eclska7_100, na.action = na.omit)

tmodrich <- nlme(Math ~ SSfpl(time2, A, B, xmid, scal),
                 data = eclska7_100, na.action = na.omit,
                 fixed = A + B + xmid + scal ~ 1,
                 random = Asym ~ 1 | id,
                 start = c(A = 35, B = 127.5, xmid = 1.3, scal = 1.2))



save(tmodgompfull, tmodgompABBfull, file = "data/fulltimemodels.Rdata")
