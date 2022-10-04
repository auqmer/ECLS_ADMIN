 <- predict(mathA_RSxG2way, )

library(ggplot2)

ggplot(eclskmath, aes(x = time2, y = predict(mathA_RSxG2way))) + geom_line() +
  facet_grid(Race ~ Sex)


gomp <- function(Asym, b2, b3, time) {
   Asym*exp(-b2*exp(-b3*time))
  
}


emmeans(mathA_B_RxG, param = "Asym", ~ Race | Sex)
emmeans(mathA_B_RxG, param = "b2", ~ Race | Sex)
emmeans(mathA_B_RxG, param = "b3", ~ Race | Sex)

time <- seq(-5, 12, by = .01)
b0 <- 131.7
male.white <- gomp(130, 1.26, .584, time)
male.black <- gomp(118.4, 1.26, .604, time)
male.hispanic <- gomp(126.1, 1.31, .601, time)
male.asian <- gomp(136.6, 1.27, .585, time)
plot(male.white ~ time, type = "l", ylim = c(0, 132))
lines(time, male.black, col = "red")
lines(time, male.hispanic, col = "blue")
lines(time, male.asian, col = "green")
abline(v = c(0, 5.5))

plot(Math ~ jitter(time2,3), data = eclskmath, subset = eclskmath$Race == "White")
lines(time, white, col = "red")
lines(time, black)