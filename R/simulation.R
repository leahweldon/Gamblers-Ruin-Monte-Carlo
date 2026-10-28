source("R/model.R")
simulate_ruin <- function(n=100000L,start=2L,target=10L,p=0.5,seed=2026L) {
  validate_model(start,target,p)
  if (!is.numeric(n) || length(n)!=1L || !is.finite(n) ||
      n!=floor(n) || n<1 || n>1e7) stop("Invalid run count")
  if (!is.numeric(seed) || length(seed)!=1L || !is.finite(seed) ||
      seed!=floor(seed) || seed<0 || seed>.Machine$integer.max)
    stop("Invalid random seed")
  prior <- exists(".Random.seed",envir=.GlobalEnv,inherits=FALSE)
  if (prior) original <- get(".Random.seed",envir=.GlobalEnv)
  on.exit({
    if (prior) assign(".Random.seed",original,envir=.GlobalEnv)
    else if (exists(".Random.seed",envir=.GlobalEnv,inherits=FALSE))
      rm(".Random.seed",envir=.GlobalEnv)
  },add=TRUE)
  set.seed(as.integer(seed))
  if (start==0 || start==target)
    return(data.frame(won=rep(start==target,n),steps=integer(n)))
  wealth <- rep(as.integer(start),n)
  steps <- integer(n)
  active <- seq_len(n)
  while (length(active)>0L) {
    wealth[active] <- wealth[active] +
      ifelse(runif(length(active))<p,1L,-1L)
    steps[active] <- steps[active]+1L
    active <- active[wealth[active]>0L & wealth[active]<target]
  }
  data.frame(won=wealth==target,steps=steps)
}

wilson_interval <- function(successes,n,level=0.95) {
  valid <- function(x) is.numeric(x) && length(x)==1L && is.finite(x)
  if (!valid(successes) || !valid(n) || !valid(level) ||
      n<1 || n!=floor(n) || successes<0 || successes>n ||
      successes!=floor(successes) || level<=0 || level>=1)
    stop("Invalid interval parameters")
  z <- qnorm(1-(1-level)/2)
  phat <- successes/n
  denom <- 1+z^2/n
  center <- (phat+z^2/(2*n))/denom
  radius <- z*sqrt(phat*(1-phat)/n+z^2/(4*n^2))/denom
  c(lower=max(0,center-radius),upper=min(1,center+radius))
}

summarise_simulation <- function(games,horizon=10L) {
  if (!is.data.frame(games) || !all(c("won","steps") %in% names(games)) ||
      nrow(games)<1L || !is.logical(games$won) || anyNA(games$won) ||
      !is.numeric(games$steps) || any(!is.finite(games$steps)) ||
      any(games$steps<0) || any(games$steps!=floor(games$steps)) ||
      !is.numeric(horizon) || length(horizon)!=1L ||
      !is.finite(horizon) || horizon<0 || horizon!=floor(horizon))
    stop("Invalid simulated games or horizon")
  cases <- list(games$won,games$steps<=horizon,
                games$won & games$steps<=horizon)
  labels <- c("eventual_win","end_by_horizon","win_by_horizon")
  do.call(rbind,lapply(seq_along(cases),function(i) {
    k <- sum(cases[[i]]); n <- nrow(games); ci <- wilson_interval(k,n)
    data.frame(metric=labels[i],count=k,n=n,estimate=k/n,
               lower_95=unname(ci[1L]),upper_95=unname(ci[2L]))
  }))
}
