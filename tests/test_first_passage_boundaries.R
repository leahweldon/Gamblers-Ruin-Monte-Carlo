source("R/model.R")
# Boundary and invariance checks for finite-horizon first-passage probabilities.
for (N in c(2L,3L,10L,25L)) {
 for (s in c(0L,1L,N-1L,N)) {
  for (p in c(0,0.1,0.5,0.9,1)) {
   f <- first_passage(s,N,p,200L)
   total <- cumsum(f$ruin+f$win)
   stopifnot(nrow(f)==201L,all(is.finite(total)),
     all(f$ruin>=0),all(f$win>=0),
     all(diff(total)>=-1e-12), all(total<=1+1e-10))
   if (s==0L) stopifnot(f$ruin[1L]==1, sum(f$win)==0)
   if (s==N) stopifnot(f$win[1L]==1, sum(f$ruin)==0)
   if (s>0L && s<N) {
     stopifnot(abs(sum(f$ruin+f$win)+
       (1-tail(total,1))-1)<1e-10)
     stopifnot(sum(f$win)<=win_probability(s,N,p)+1e-9)
   }
  }
 }
}
# All finite-horizon first-passage mass must have the same parity as
# the destination distance from the starting state.
f <- first_passage(2L,10L,0.5,100L)
stopifnot(all(f$ruin[f$step%%2L != 0L]==0),
          all(f$win[f$step%%2L != 0L]==0))
cat("First-passage boundary and mass checks passed.\n")
