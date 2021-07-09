library(ggplot2)
library(nlme)

load("~/qmer/Data/ECLS_K/2011/eclska.Rdata")

ids <- as.character(unique(eclska$id))

set.seed(1234)
ids500 <- sample(ids, 500, replace = FALSE)


eclska500 <- subset(eclska, id %in% ids500)
eclska500$id <- droplevels(eclska500$id)
eclska500cc <- eclska500[complete.cases(eclska500), ]

ggplot(eclska500cc, aes(x = time2, y = Science, group = id)) + 
  geom_point() + geom_line()


sciencelogis.nls <- nls(Science ~ SSlogis(time2-.5, Asym, xmid, scal),
                        data = eclska500, na.action = na.omit)

sciencelogis <-  nlme(Science ~ SSlogis(I(time2-.5), Asym, xmid, scal),
                      data = eclska500, na.action = na.omit,
                      fixed = Asym + xmid + scal ~ 1,
                      random = Asym  ~ 1,
                      group = ~ id,
                      start = c(Asym = 80.3, xmid = .72, scal = 2.1))
summary(sciencelogis)

sciencelogisAX <- update(sciencelogis,
                         random = Asym + xmid ~ 1 | id)
summary(sciencelogisAX)

sciencelogisAXS <- update(sciencelogis,
                          random = Asym + xmid + scal ~ 1 | id,
                          start = c(Asym = 78, xmid =.62, scal = 1.85))


sciencegomp.nls <- nls(Science ~ SSgompertz(I(time2-.5), Asym, b2, b3),
                      data = eclska500, na.action = na.omit)



sciencegompA <-  nlme(Science ~ SSgompertz(I(time2-.5), Asym, b2, b3),
                     data = eclska500cc, na.action = na.omit,
                     fixed = Asym + b2 + b3 ~ 1,
                     random = Asym ~ 1 | id,
                     start = c(Asym = 99.5, b2 = 1.1, b3 = .78))
summary(sciencegompA)

anova(sciencelogis, sciencegompA)

sciencegompAB <- update(sciencegompA,
                        random = Asym + b2 ~ 1 | id)
summary(sciencegompAB)

anova(sciencelogisAX, sciencegompAB)
sciencegompABB <- update(sciencegompA,
                         random = Asym + b2 + b3 ~ 1 | id,
                         start = c(Asym = 84.9, b2 = .96, b3 = .71))


sciencerich.nls <- nls(Science ~ SSfpl(time2-.5, A, B, xmid, scal),
                       data = eclska500, na.action = na.omit)
summary(sciencerich.nls)

sciencerich.lis <- nlsList(Science ~ SSfpl(time2-.5, A, B, xmid, scal) | id,
                           data = eclska500, na.action = na.omit,
                           control = list(maxit = 100))

sciencerichABX <- nlme(Science ~ SSfpl(time2-.5, A, B, xmid, scal),
                     data = eclska500, na.action = na.omit,
                     fixed = A + B + xmid + scal ~ 1,
                     random = A + B + xmid ~ 1 | id,
                     start = c(A = -6.53, B = 89.9, xmid = 1.44, scal = 2.68))


anova(sciencelogisAX, sciencegompAB)


sRE <- ranef(sciencegompAB, augFrame = TRUE)

plot(sRE, form = ~ Sex)

sciSex.nls <- nls(Science ~ SSgompertz(time2-.5, Asym, b2 , b3) | id,
                  data = eclska500, na.action = na.omit)

sciSex <- update(sciencegompAB,
                 fixed = list(Asym ~ 1, b2 ~ Sex + Race, b3 ~ 1),
                 random = Asym ~ 1 | id,
                 start = c()