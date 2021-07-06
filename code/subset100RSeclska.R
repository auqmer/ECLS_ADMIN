# Create 100 RS cases from eclska.

load("~/qmer/Data/ECLS_K/2011/eclska.Rdata")


ids <- as.character(unique(eclska$id))

set.seed(1234)
ids100 <- sample(ids, 100, replace = FALSE)


eclska100 <- subset(eclska, id %in% ids100)
eclska100$id <- droplevels(eclska100$id)

eclska100$Age8 <- (eclska100$Age/12) - 8

ggplot(eclska7, aes(x = Time, y = Math, group = id)) + 
  geom_line(alpha = .05) + ylim(0, 200) #+ facet_grid(Sex ~ Race)


modjb <- nlme(Math ~ b_1i + b_2i*Age8 + b_3i*(exp(gamma*Age8) - 1),
              data = eclska100, na.action = na.omit,
              fixed = b_1i + b_2i + b_3i + gamma ~ 1,
              random = b_1i + b_2i + b_3i ~ 1,
              group = ~ id, method = "ML",
              start = c(b_1i = 120, b_2i = - 1.3, b_3i = 1.3, gamma = 1),
              control = list(msMaxIter=100, maxIter = 100, 
                             opt="optim", optimMethod = "BFGS", 
                             msVerbose=TRUE))

modlogis <- nlme(Math ~ b0 + (b1*Age/(1 + exp(-(b2*(Age - 8))))),
              data = eclska100, na.action = na.omit,
              fixed =  b0 + b1 + b2 ~ 1,
              random = b0 + b1 + b2 ~ 1,
              group = ~ id,
              start = c(b0 = 120, b1 = - 1.3, b2 = 1.3))


modlogisSS <- nlme(Math ~ SSlogis(Age, Asym, xmid, scal),
                   data = eclska, na.action = na.omit,
                   fixed = Asym + xmid + scal ~ 1,
                   random = Asym + xmid + scal ~ 1,
                   group = ~ id,
                   start = c(Asym = 120, xmid = -1.3, scal = 1.3))
