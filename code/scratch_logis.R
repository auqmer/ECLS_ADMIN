
library(nlme)
library(growthmodels)
load("~/qmer/Data/ECLS_K/2011/eclska.Rdata")

eclska$Age8 <- (eclska$Age/12) - 8


eclskcc <- eclska[ ,c("id", "Age8", "Math") ]
eclskcc <- eclskcc[complete.cases(eclskcc), ]
modlogis7 <- nlme(Math ~ SSlogis(Age8, Asym, xmid, scal),
                 data = eclska7, na.action = na.omit,
                 fixed = list(Asym ~ 1, xmid ~ 1, scal ~1),
                 random = Asym + xmid + scal ~ 1 | id,
                 start = c(Aysm = 120, xmid = -1.3, scal = 1.3),
                 )

modlogis7_scal <- nlme(Math ~ SSlogis(Age8, Asym, xmid, scal),
                  data = eclska7, na.action = na.omit,
                  fixed = list(Asym ~ 1, xmid ~ 1, scal ~1),
                  random = Asym + xmid  ~ 1 | id,
                  start = c(Aysm = 120, xmid = -1.3, scal = 1.3),
)

modlogis7_scalxmid <- update(modlogis7_scal, 
                             random = Asym ~ 1 | id)

modlogis.s <- nlme(Math ~ SSlogis(Age8, Asym, xmid, scal),
                 data = eclska7, na.action = na.omit,
                 fixed = list(Asym ~ 1, xmid ~ 1, scal ~ 1),
                 random = Asym + xmid + scal ~ 1 | id,
                 start = c(Aysm = 120, xmid = -1.3, scal = 1.3),
)


modfpl <-  nlme(Math ~ SSfpl(time, A, B, xmid, scal),
                data = eclska100, na.action = na.omit,
                fixed = A + B + xmid + scal ~ 1,
                random = A + B + xmid + scal ~ 1 | id,
                start = c(A = -75, B = 133, xmid = -2.7, scal = 2.3),
                control = list(msMaxIter = 1000, maxIter = 100, 
                               optim = "optim"))

summary(modfpl)


logisRG <- nlme(Math ~ SSlogis(time, Asym, xmid, scal),
                data = eclska7, na.action = na.omit,
                fixed = Asym + xmid + scal ~ 1,
                random = Asym + xmid  ~ 1 | id,
                start= c(Asym = 133, xmid = 2.6, scal = 2.8))
summary(logisRG)
