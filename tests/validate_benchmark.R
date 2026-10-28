source("R/model.R")
x <- read.csv("results/benchmark-raw.csv")
y <- read.csv("results/benchmark-summary.csv")
stopifnot(nrow(x)==15L,nrow(y)==3L,
 all(x$n %in% c(1000L,10000L,100000L)),
 all(is.finite(x$elapsed_seconds)),all(x$elapsed_seconds>=0),
 all(is.finite(x$mean_steps)),all(x$mean_steps>0),
 all(y$repetitions==5L),all(y$min_elapsed_seconds<=y$median_elapsed_seconds),
 all(y$median_elapsed_seconds<=y$max_elapsed_seconds),
 file.exists("results/benchmark-environment.txt"))
cat("Performance benchmark output validated.\n")
