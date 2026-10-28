source("R/simulation.R")
# Cross-check events and invariants at the trajectory level, including
# deterministic paths and alternative absorbing boundaries.
for (N in c(2L,3L,7L,10L)) {
 for (s in seq_len(N-1L)) {
  for (p in c(0,0.3,0.5,0.9,1)) {
   g <- simulate_ruin(n=150L,start=s,target=N,p=p,seed=1000L+N*10L+s)
   stopifnot(nrow(g)==150L,all(g$steps>=1L),
     all(g$steps%%2L == if (s%%2L == 0L) ifelse(g$won,N%%2L,0L)
                                  else ifelse(g$won,(N-1L)%%2L,1L)))
   if (p==0) stopifnot(!any(g$won),all(g$steps==s))
   if (p==1) stopifnot(all(g$won),all(g$steps==N-s))
  }
 }
}
# Preservation of caller RNG state, including the no-preexisting-state case.
set.seed(888)
old <- get(".Random.seed",envir=.GlobalEnv)
invisible(simulate_ruin(n=200L,seed=15L))
stopifnot(identical(get(".Random.seed",envir=.GlobalEnv),old))
rm(".Random.seed",envir=.GlobalEnv)
invisible(simulate_ruin(n=10L,seed=15L))
stopifnot(!exists(".Random.seed",envir=.GlobalEnv,inherits=FALSE))
# Inputs must reject NA, non-integers, out-of-range values and malformed data.
bad <- function(expr) stopifnot(inherits(try(force(expr),silent=TRUE),"try-error"))
bad(simulate_ruin(n=NA_real_))
bad(simulate_ruin(n=2.5))
bad(simulate_ruin(seed=NA_real_))
bad(win_probability(start=NaN,target=10))
bad(win_probability(start=2,target=1))
bad(wilson_interval(successes=3,n=2))
bad(wilson_interval(successes=0,n=10,level=0))
bad(summarise_simulation(data.frame(won=c(TRUE,NA),steps=c(1,2))))
cat("Trajectory invariants and input contracts passed.\n")
