x <- read.csv("results/coverage-study.csv")
stopifnot(nrow(x)==4L,all(x$replicates==5000L),
          identical(x$n,c(50L,250L,1000L,4000L)),
          all(is.finite(as.matrix(x))),all(x$coverage>0.85),
          all(x$coverage<1),all(x$coverage_mc_se>0),
          all(x$mean_interval_width>0),
          all(diff(x$mean_interval_width)<0),
          all(x$nominal_coverage==0.95))
cat("Coverage-study output structure validated.\n")
