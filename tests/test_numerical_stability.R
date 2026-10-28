source("R/model.R")
# Numerical cross-checks: near-fair bias, extreme bias, and larger systems.
# Near-fair values are expected to approach the fair closed form continuously.
for (N in c(10L,25L,50L,100L)) {
 for (i in unique(as.integer(c(1L,floor(N/3),floor(N/2),N-1L)))) {
  fair <- win_probability(i,N,0.5)
  for (eps in c(1e-8,1e-6,1e-4)) {
   for (p in c(0.5-eps,0.5+eps)) {
    val <- win_probability(i,N,p)
    stopifnot(is.finite(val),val>=0,val<=1)
    if (eps==1e-8) stopifnot(abs(val-fair)<1e-5)
   }
  }
 }
}
# Compare closed form against independently constructed transient Markov solves.
for (N in c(3L,10L,30L,75L)) {
 for (p in c(0.001,0.05,0.25,0.49,0.5,0.51,0.75,0.95,0.999)) {
  for (i in unique(as.integer(c(1L,floor(N/2),N-1L)))) {
   v <- win_probability(i,N,p)
   m <- markov_moments(i,N,p)
   stopifnot(is.finite(v),v>=0,v<=1,
     abs(v-unname(m["win"]))<1e-7,
     is.finite(m["mean_time"]),m["mean_time"]>=0)
  }
 }
}
cat("Numerical stability checks passed.\n")
