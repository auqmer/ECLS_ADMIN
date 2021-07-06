
library(ggplot2)
library(nlme)

load("~/qmer/Data/ECLS_K/2011/eclsk9.Rdata")



ggplot(eclsk9, aes(x = age/12, y = math, group = childid, color = x_raceth_r)) + 
  geom_line(alpha = .2) + facet_grid(x_raceth_r ~ x_chsex_r)

ggplot(eclsk9wf, aes(x = age/12, y = math, group = childid)) + 
  geom_line()

modjb.nls <- nls(math ~  b_1i + b_2i*(time2) + b_3i*(exp(gamma*(age/12))-1),
                 data = eclska7_100,
                 #fixed = b_1i + b_2i + b_3i + gamma ~ 1,
                 start = 
                 )

modjb <- nlme(math ~ b_1i + b_2i*(age/12) + b_3i*(exp(b_4i*(age/12))-1),
              data = eclsk9,
              fixed = b_1i + b_2i + b_3i + b_4i ~ 1,
              random = b_1i + b_2i + b_3i + b_4i ~ 1 | id,
              start = c(120,  80, -6, 3),
              na.action = na.omit)

inits <- getInitial(math ~ SSgompertz(age/12, Asym, b2, b3),
                    data = eclsk100)

modgomp <- nlme(math ~ SSgompertz(age/12, Asym, b2, b3),
                data = eclsk9wf,
                fixed = list(Asym ~ 1, b2 ~ 1, b3 ~ 1),
                start = c(129.7, 20, .61),
                random = Asym + b2 + b3 ~ 1 | childid)


modgomp.list <- nlsList(math ~ SSgompertz(age/12, Asym, b2, b3) | childid,
                        data = eclsklong,
                        na.action = na.pass)
modgomp.nls <- nls(math ~ SSgompertz(age/12, Aysm, b2, b3),
                   data = eclsk100)


form <- math ~ SSlogis(age/12, Asym, xmid, scal)
inits <- getInitial(form, data = eclsk9)

modlogiswf <- nlme(form,
                 data = eclsk9wf,
                 fixed = list(Asym ~ 1, xmid ~ 1, scal ~ 1),
                 random = Asym + xmid + scal ~ 1 | childid,
                 start = inits,
                 na.action = na.omit)
modlogiswf <- nlme(form,
                 data = eclsk9wf,
                 fixed = list(Asym ~ 1, xmid ~ 1, scal ~ 1),
                 random = Asym + xmid +scal ~ 1 | childid,
                 start = inits,
                 na.action = na.omit)
summary(modlogiswf)
modlogiswf2 <- nlme(form,
                   data = eclsk9wf,
                   fixed = Asym + xmid + scal ~ 1,
                   random = Asym + xmid +scal ~ 1 | childid,
                   start = inits,
                   na.action = na.omit)
summary(modlogiswf2)

anova(modlogiswf, modlogiswf2)
modlogis <- nlme(form,
                 data = eclsk9,
                 fixed = list(Asym ~ 1, xmid ~ 1, scal ~ 1),
                 random = Asym + xmid +scal ~ 1 | childid,
                 start = inits,
                 na.action = na.omit)
