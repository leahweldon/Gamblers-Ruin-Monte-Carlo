validate_model <- function(start, target, p) {
  is_int <- function(x) is.numeric(x) && length(x) == 1L &&
    is.finite(x) && x == floor(x)
  if (!is_int(start) || !is_int(target) || target < 2 ||
      target > 500 || start < 0 || start > target ||
      !is.numeric(p) || length(p) != 1L || !is.finite(p) ||
      p < 0 || p > 1) stop("Invalid integer-state model parameters")
  invisible(TRUE)
}

win_probability <- function(start, target, p = 0.5) {
  validate_model(start, target, p)
  if (start == 0) return(0)
  if (start == target) return(1)
  if (p == 0) return(0)
  if (p == 1) return(1)
  if (p == 0.5) return(start / target)
  log_r <- log1p(-p) - log(p)
  if (p < 0.5) {
    return(exp((start - target) * log_r) *
             expm1(-start * log_r) / expm1(-target * log_r))
  }
  expm1(start * log_r) / expm1(target * log_r)
}

markov_system <- function(target, p = 0.5) {
  validate_model(0, target, p)
  m <- target - 1L
  Q <- matrix(0, m, m)
  for (i in seq_len(m)) {
    if (i > 1L) Q[i, i-1L] <- 1-p
    if (i < m) Q[i, i+1L] <- p
  }
  R <- matrix(0, m, 2L, dimnames=list(NULL,c("ruin","win")))
  R[1L,1L] <- 1-p
  R[m,2L] <- p
  list(Q=Q,R=R)
}

markov_moments <- function(start, target, p=0.5) {
  validate_model(start,target,p)
  if (start %in% c(0,target))
    return(c(win=as.numeric(start == target),mean_time=0,variance_time=0))
  sys <- markov_system(target,p)
  A <- diag(target-1L) - sys$Q
  win <- as.numeric(solve(A,sys$R[,2L]))[start]
  mean_vec <- as.numeric(solve(A,rep(1,target-1L)))
  second <- as.numeric(solve(A,2*mean_vec-1))
  c(win=win,mean_time=mean_vec[start],
    variance_time=max(0,second[start]-mean_vec[start]^2))
}

first_passage <- function(start,target,p=0.5,horizon=50L) {
  validate_model(start,target,p)
  if (!is.numeric(horizon) || length(horizon)!=1L ||
      !is.finite(horizon) || horizon!=floor(horizon) ||
      horizon<0 || horizon>100000) stop("Invalid horizon")
  horizon <- as.integer(horizon)
  out <- matrix(0,horizon+1L,2L)
  if (start == 0 || start == target) {
    out[1L,if (start==0) 1L else 2L] <- 1
  } else {
    live <- numeric(target-1L)
    live[start] <- 1
    if (horizon>0) for (t in seq_len(horizon)) {
      out[t+1L,1L] <- live[1L]*(1-p)
      out[t+1L,2L] <- live[target-1L]*p
      next_live <- numeric(target-1L)
      if (target>2L) for (i in seq_len(target-1L)) {
        if (i>1L) next_live[i-1L] <- next_live[i-1L]+live[i]*(1-p)
        if (i<target-1L) next_live[i+1L] <- next_live[i+1L]+live[i]*p
      }
      live <- next_live
    }
  }
  data.frame(step=0:horizon,ruin=out[,1L],win=out[,2L])
}

exact_summary <- function(start,target,p=0.5,horizon=10L) {
  f <- first_passage(start,target,p,horizon)
  m <- markov_moments(start,target,p)
  c(eventual_win=win_probability(start,target,p),
    end_by_horizon=sum(f$ruin+f$win),
    win_by_horizon=sum(f$win),
    expected_steps=unname(m["mean_time"]),
    variance_steps=unname(m["variance_time"]))
}
