source("R/simulation.R")
dir.create("results",showWarnings=FALSE,recursive=TRUE)
baseline <- exact_summary(2,10,0.5,10)
games <- simulate_ruin(100000L,2L,10L,0.5,2026L)
summary <- summarise_simulation(games,10L)
summary$exact <- as.numeric(baseline[match(summary$metric,names(baseline))])
summary$absolute_error <- abs(summary$estimate-summary$exact)
write.csv(summary,"results/baseline.csv",row.names=FALSE)

grid <- expand.grid(start=c(1L,2L,4L,6L,8L,9L),
                    p=c(0.4,0.45,0.5,0.55,0.6))
grid$exact_win <- mapply(win_probability,grid$start,
                          MoreArgs=list(target=10),p=grid$p)
write.csv(grid,"results/sensitivity.csv",row.names=FALSE)
pdf("results/sensitivity.pdf",width=8,height=5)
matplot(sort(unique(grid$start)),
        sapply(sort(unique(grid$p)),function(q)
          vapply(sort(unique(grid$start)),function(s)
            win_probability(s,10,q),numeric(1))),
        type="l",lty=1,lwd=2,xlab="Starting wealth (units)",
        ylab="Exact probability of reaching target",
        main="Gambler's ruin: sensitivity to coin bias")
legend("topleft",legend=paste0("p=",sort(unique(grid$p))),
       lty=1,col=seq_along(unique(grid$p)),bty="n")
dev.off()
f <- first_passage(2,10,0.5,100)
write.csv(f,"results/first-passage.csv",row.names=FALSE)
pdf("results/first-passage.pdf",width=8,height=5)
plot(f$step,f$ruin,type="h",lwd=2,xlab="Number of flips",
     ylab="Probability mass",main="First-passage time distribution")
lines(f$step,f$win,type="h",col=2,lwd=1)
legend("topright",legend=c("Ruin","Target"),col=c(1,2),
       lty=1,bty="n")
dev.off()
cat("Wrote reproducible experiments to results/.\n")
