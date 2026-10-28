source("R/simulation.R")
dir.create("results",recursive=TRUE,showWarnings=FALSE)
# Binomial sampling is the exact marginal distribution of independent
# eventual-win indicators. This studies interval behaviour without
# confounding coverage with the cost of simulating every trajectory.
set.seed(6172026)
reps <- 5000L
sizes <- c(50L,250L,1000L,4000L)
rows <- lapply(sizes,function(n) {
 k <- rbinom(reps,size=n,prob=0.2)
 z <- qnorm(0.975)
 phat <- k/n
 denom <- 1+z^2/n
 center <- (phat+z^2/(2*n))/denom
 half <- z*sqrt(phat*(1-phat)/n+z^2/(4*n*n))/denom
 covered <- (center-half<=0.2) & (0.2<=center+half)
 coverage <- mean(covered)
 mc_se <- sqrt(coverage*(1-coverage)/reps)
 data.frame(n=n,replicates=reps,coverage=coverage,
            coverage_mc_se=mc_se,
            mean_interval_width=mean(2*half),
            nominal_coverage=0.95)
})
out <- do.call(rbind,rows)
write.csv(out,"results/coverage-study.csv",row.names=FALSE)
cat("Completed independent binomial coverage study.\n")
