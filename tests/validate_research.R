source("R/model.R")
a <- read.csv("results/convergence-replicates.csv")
b <- read.csv("results/convergence-summary.csv")
c <- read.csv("results/extended-sensitivity.csv")
stopifnot(nrow(a)==128L,nrow(b)==4L,nrow(c)==81L,
          identical(sort(unique(a$n)),c(250L,1000L,4000L,16000L)),
          all(a$win_estimate>=0 & a$win_estimate<=1),
          all(a$abs_error>=0 & a$abs_error<=1),
          all(a$covered %in% c(TRUE,FALSE)),
          all(b$replicates==32L),
          all(b$rmse>=0 & b$rmse<=1),
          all(b$empirical_coverage>=0 & b$empirical_coverage<=1),
          all(c$win_probability>=0 & c$win_probability<=1),
          all(c$mean_steps>=0),
          all(is.finite(c$mean_steps)))
stopifnot(max(abs(c$win_probability -
  mapply(function(i,p) win_probability(i,10,p),c$start,c$p)))<1e-10)
stopifnot(max(abs(c$mean_steps -
  mapply(function(i,p) unname(markov_moments(i,10,p)["mean_time"]),
         c$start,c$p)))<1e-8)
stopifnot(all(file.exists(c("results/convergence.pdf",
                          "results/expected-time-sensitivity.pdf"))))
cat("Extended experiment outputs validated.\n")
