source("R/model.R")

# Independently verify the transition-system calculation using a
# backward recurrence for the target hitting probability.
recurrence_win <- function(start,target,p) {
  if (start==0L) return(0)
  if (start==target) return(1)
  if (p==0) return(0)
  if (p==1) return(1)
  # Solve the linear boundary-value problem directly; this test uses
  # a separate matrix construction from markov_system().
  n <- target-1L
  A <- diag(n)
  rhs <- numeric(n)
  for (i in seq_len(n)) {
    if (i>1L) A[i,i-1L] <- -(1-p)
    if (i<n) A[i,i+1L] <- -p
    if (i==n) rhs[i] <- p
  }
  unname(solve(A,rhs)[start])
}

# Probability mass conservation at every horizon (not only at t=100).
for (p in c(0,0.01,0.1,0.45,0.5,0.55,0.9,0.99,1)) {
  for (start in c(1L,2L,5L,9L)) {
    f <- first_passage(start,10L,p,100L)
    stopifnot(all(is.finite(f$ruin)), all(is.finite(f$win)),
      all(f$ruin >= 0),all(f$win >= 0),
      sum(f$ruin+f$win) <= 1+1e-10,
      abs(win_probability(start,10L,p)-
          recurrence_win(start,10L,p)) < 1e-8)
    # Exact eventual winning must exceed its truncated first-passage mass.
    stopifnot(sum(f$win) <= win_probability(start,10L,p)+1e-10)
  }
}

# Symmetry under swapping win/loss probabilities and reflecting capital.
for (p in c(0.1,0.3,0.49,0.5,0.51,0.7,0.9)) {
  for (i in 1:9) {
    stopifnot(abs(win_probability(i,10,p) +
                  win_probability(10-i,10,1-p)-1)<1e-9)
  }
}

# Fair walk: mean duration is i*(N-i).
for (target in c(3L,5L,10L,30L)) {
  for (i in seq_len(target-1L)) {
    m <- markov_moments(i,target,0.5)
    stopifnot(abs(m["mean_time"]-i*(target-i))<1e-7,
              m["variance_time"]>=0)
  }
}
cat("Independent analytical cross-checks passed.\n")
