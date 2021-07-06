
load("~/qmer/Data/ECLS_K/2011/eclsklong.Rdata")
library(ggplot2)

ggplot(eclsklong, aes(x = age/12, y = math, group = childid, 
                      color = x_raceth_r)) + 
  geom_line(alpha = .1) + facet_grid( ~ x_raceth_r)

ggplot(eclsklong, aes(x = age/12, y = math, group = childid)) + geom_line(alpha = .02, color = "blue")

ggplot(eclsklong, aes(x = age/12, y = read, group = childid)) + geom_line(alpha = .02, color = "blue")

ggplot(eclsklong, aes(x = age/12, y = sci, group = childid)) + geom_line(alpha = .02, color = "blue")

ggplot(eclsklong, aes(x = age/12, y = nrsscr, group = childid)) + geom_line(alpha = .02, color = "blue")
ggplot(eclsklong, aes(x = age/12, y = nrwabl, group = childid)) + geom_line(alpha = .02, color = "blue")

ggplot(eclsklong, aes(x = age/12, y = dccs, group = childid)) + geom_line(alpha = .02, color = "blue")


ggplot(eclsklong, aes(x = age/12, y = math, color = x_raceth_r)) + geom_point(alpha = .1) + 
  geom_smooth(method = "lm", fill = NA, formula=math ~ poly(age/12, 3, raw=TRUE))


library(nlme)
library(texreg)
mod0 <- lme(math ~ age, data = eclsklong, ~ 1 | childid, na.action = na.omit,
            method = "ML")
mod1 <- lme(math ~ poly((age/12),2,raw=TRUE), data = eclsklong,
            ~ 1 | childid, na.action = na.omit,
            method = "ML")

mod2 <- lme(math ~ poly((age/12),3,raw=TRUE), data = eclsklong,
            ~ 1 | childid, na.action = na.omit,
            method = "ML")
mod3 <- lme(math ~ poly((age/12),4,raw=TRUE), data = eclsklong,
            ~ 1 | childid, na.action = na.omit,
            method = "ML")



anova(mod0, mod1)
anova(mod1, mod2)
anova(mod2, mod3)
summary(mod1)

ctr <- function(x) scale(x, scale = FALSE)
mmod2t <- lme(math ~ poly(as.numeric(time), 2,raw=TRUE) + x_chsex_r + x_raceth_r + 
               ctr(x12sesl) + x1ksctyp + x12primpk,
             data = eclsklong, 
             ~ 1 | childid, 
             na.action = na.omit,
             method = "ML"
             ) 

anova(mod1, mmod2)
summary(mmod2)
screenreg(mmod2t)

eclsklong$agey <- eclsklong$age/12

eclsklongg <- groupedData(math ~ agey | childid, data = eclsklong)
lmmod.nls <- nls(math ~ SSlogis(agey, Asym, xmid, scal), 
                 data = eclsklong)
summary(lmmod.nls)

lmmod.lis <- nlsList(math ~ SSlogis(agey, Asym, xmid, scal) | childid,
                     data = eclsklong, na.action = na.pass)

eclsklong$nid <- as.numeric(eclsklong$childid)

lmmod.nlme <- nlme(math ~ SSlogis(agey, Asym, xmid, scal),na.action = na.pass,
                   random = ~ 1 | childid, data = eclsklong, 
                   method = "ML")
lmmod.nlme <- nlme(lmmod.lis)



modjb <- nlme(Math ~ b_1i + b_2i*(Age8) + b_3i*(exp(gamma*(Age8))-1),
              data = eclska,
              fixed = b_1i + b_2i + b_3i + gamma ~ 1,
              random = b_1i + b_2i + b_3i ~ 1 | id,
              start = c(35.5, 20, -10, -2),
              na.action = na.omit)
