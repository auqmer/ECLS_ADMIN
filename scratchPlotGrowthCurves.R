 <- predict(mathA_RSxG2way, )

library(ggplot2)

ggplot(eclskmath, aes(x = time2, y = predict(mathA_RSxG2way))) + geom_line() +
  facet_grid(Race ~ Sex)


gomp <- function(Asym, b2, b3, time) {
   Asym*exp(-b2*exp(-b3*time))
  
}


time <- seq(0, 5.5, by = .01)
b0 <- 131.7
white <- gomp(131.7, 1.26, .6, time)
black <- gomp(118.3, 1.25, .6, time)
hispanic <- gomp(126.3, 1.31, .6, time)
asian <- gomp(134.4, 1.27, .6, time)
plot(white ~ time, type = "l", ylim = c(30, 132))
lines(time, black, col = "red")
lines(time, hispanic, col = "blue")
lines(time, asian, col = "green")
abline(h = 131.7)

plot(Math ~ jitter(time2,3), data = eclskmath, subset = eclskmath$Race == "White")
lines(time, white, col = "red")
lines(time, black)