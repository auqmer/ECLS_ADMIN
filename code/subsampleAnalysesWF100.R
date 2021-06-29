#************************************************************************
# Title: subsample analyses for MEMs
# Author: William Murrah
# Description: description
# Created: Monday, 28 June 2021
# R version: R version 4.1.0 (2021-05-18)
# Project(working) directory: /home/hank01/Projects/QMER/ECLS_ADMIN
#************************************************************************
library(ggplot2)
library(nlme)
load("~/qmer/Data/ECLS_K/2011/eclsk9fw.Rdata")


ids <- as.character(unique(eclsk9wf$childid))

set.seed(1234)
ids100 <- sample(ids, 100, replace = FALSE)

eclskwf100 <- subset(eclsk9wf, childid %in% ids100)
eclskwf100$childid <- droplevels(eclskwf100$childid)

eclskwf100$agey <- eclskwf100$age/12
eclskwf100$cagey <- eclskwf100$agey - 8
ggplot(eclskwf100, aes(x = cagey, y = math, group = childid)) + 
  geom_line()

form <- math ~ SSgompertz(I(age/12 - 9), Asym, b2, b3) | childid
modgomp.lis <- nlsList(form , data = eclskwf100,
                       na.action = na.pass)


coefs <- coef(modgomp.lis)
summary(coefs)
modgomp <- nlme(math ~ SSgompertz(cagey, Asym, b2, b3),
                 data = eclskwf100,
                 fixed = list(Asym ~ 1, b2 ~1, b3 ~ 1),
                 start = c(143, 28, .63),
                 random = Asym + b2 +  b3 ~ 1 | childid)

modlogis.lis <- nlsList(math ~ SSlogis(cagey, Asym, xmid, scal) | childid,
                        data = eclskwf100,
                        na.action = na.pass)
modlogis.nls <- nls(math ~ SSlogis(cagey, Asym, xmid, scal),
                    data = eclskwf100)

modlogis.nlme <- nlme(math ~ SSlogis(cagey, Asym, xmid, scal),
                      data = eclskwf100,
                      fixed = As)
summary(coef(modlogis.nls))
modlogis <- nlme(math ~ SSlogis(cagey, Asym, xmid, scal),
                 data = eclskwf100,
                 fixed = list(Asym ~ 1, xmid ~ 1, scal ~ 1),
                 random = Asym + xmid + scal ~ 1 | childid,
                 start = c(Asym = 133, xmid = -1.3, scal = 1.4),
                 na.action = na.omit)
summary(modlogis)
modlogis_scal <- update(modlogis, random = Asym + xmin ~ 1 | childid)

summary(modlogis_xmid)
anova(modlogis, modlogis_xmid)
plot(modlogis)
plot(modlogis, childid ~ resid(.), abline = 0)

modjb.nls <- nls(math ~ b_1i + b_2i*cagey + b_3i*(exp(gamma*cagey)-1),
                 data = eclskwf100,
                 params = b_1i + b_2i + b_3i + gamma ~1,
                 start = c(133, -1.3, 1.5, 1))
modjb.lis <- nlsList(math ~ b_1i + b_2i*cagey + b_3i*(exp(b_4i*cagey)-1) |childid,
                     data = eclskwf100,
                     na.action = na.pass)

summary(coef(modjb.lis))

modjb <- nlme(math ~ b_1i + b_2i*cagey + b_3i*(exp(b_4i*cagey)-1),
              data = eclskwf100,
              fixed = b_1i + b_2i + b_3i + b_4i ~ 1,
              random = b_1i + b_2i + b_3i + b_4i ~ 1 | childid,
              start = c(133, -1.3, 1.5, 4),
              control = lmeControl(opt='optim', msMaxIter = 2000))


library(FlexParamCurve)

mp <- modpar(eclskwf100$cagey, y = eclskwf100$math, )
modrich.nls <- nls(math ~ SSposnegRichards(cagey, Asym, K, Infl, M, 
                                           RAsym, Rk, Ri, modno = 12),
                   data = eclskwf100,
                   pn.options = mp)


library(NRAIA)

modrich.nls <- nls(math ~ richards(cagey, Asym, xmid, scal, lpow),
                   data = eclskwf100,
                   start = c(Asym = 133, xmid))

modrich <- nlme(math ~ richards(cagey, Asym, xmid, scal, lpow),
                data = eclskwf100,
                fixed = list(Asym ~ x12sesl, xmid ~ 1, scal ~ 1, lpow ~ 1),
                random = Asym + xmid + scal + lpow ~ 1 | childid,
                start = c(Asym = 133, xmid = -1.3, scal = 1.5, lpow = 2,
                          x12sesl = 2),
                na.action = na.omit)


richards <- deriv( ~ Asym/(1 + lpow*exp(-(x - xmid)/scal)),
                  c("Asym", "xmid", "scal", "lpow"), 
                  function(x, Asym, xmid, scal, lpow){})
