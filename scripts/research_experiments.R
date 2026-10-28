source("R/simulation.R")
dir.create("results",recursive=TRUE,showWarnings=FALSE)

# Independent Monte Carlo replicates quantify how sampling error scales with n.
sizes <- c(250L,1000L,4000L,16000L)
replicates <- 32L
rows <- vector("list",length(sizes)*replicates)
idx <- 1L
for (n in sizes) for (r in seq_len(replicates)) {
  seed <- as.integer(100000L+n+r)
  g <- simulate_ruin(n=n,start=2L,target=10L,p=0.5,seed=seed)
  successes <- sum(g$won)
  ci <- wilson_interval(successes,n)
  rows[[idx]] <- data.frame(n=n,replicate=r,seed=seed,
    win_estimate=successes/n,abs_error=abs(successes/n-0.2),
    covered=ci[1L]<=0.2 && 0.2<=ci[2L])
  idx <- idx+1L
}
dat <- do.call(rbind,rows)
write.csv(dat,"results/convergence-replicates.csv",row.names=FALSE)
aggregate_stats <- do.call(rbind,lapply(split(dat,dat$n),function(z)
  data.frame(n=z$n[1L],replicates=nrow(z),
    mean_absolute_error=mean(z$abs_error),
    rmse=sqrt(mean((z$win_estimate-0.2)^2)),
    empirical_coverage=mean(z$covered),
    theoretical_sd=sqrt(0.2*0.8/z$n[1L]))))
aggregate_stats <- aggregate_stats[order(aggregate_stats$n),]
write.csv(aggregate_stats,"results/convergence-summary.csv",row.names=FALSE)

pdf("results/convergence.pdf",width=8,height=5)
plot(aggregate_stats$n,aggregate_stats$rmse,log="xy",type="b",pch=19,
  xlab="Simulations per independent replicate (log scale)",
  ylab="Root-mean-square estimation error (log scale)",
  main="Monte Carlo convergence: independent replicates")
lines(aggregate_stats$n,aggregate_stats$theoretical_sd,lty=2,lwd=2)
legend("topright",legend=c("Empirical RMSE","Theoretical standard deviation"),
  lty=c(1,2),pch=c(19,NA),bty="n")
dev.off()

# Sensitivity is exact; no Monte Carlo noise is introduced in this figure.
grid <- expand.grid(start=1:9,p=seq(0.40,0.60,by=0.025))
grid$win_probability <- mapply(function(i,p) win_probability(i,10,p),
                              grid$start,grid$p)
grid$mean_steps <- mapply(function(i,p) unname(markov_moments(i,10,p)["mean_time"]),
                          grid$start,grid$p)
write.csv(grid,"results/extended-sensitivity.csv",row.names=FALSE)
pdf("results/expected-time-sensitivity.pdf",width=8,height=5)
plot(NULL,xlim=range(grid$start),ylim=range(grid$mean_steps),
 xlab="Starting capital (units)",ylab="Expected steps until absorption",
 main="Expected duration under varying coin bias")
ps <- c(0.40,0.45,0.50,0.55,0.60)
for (j in seq_along(ps)) {
 z <- grid[abs(grid$p-ps[j])<1e-8,]
 lines(z$start,z$mean_steps,lwd=2,lty=j)
}
legend("topright",legend=paste0("p=",sprintf("%.2f",ps)),lty=1:5,bty="n")
dev.off()
cat("Created convergence and expanded sensitivity results.\n")
