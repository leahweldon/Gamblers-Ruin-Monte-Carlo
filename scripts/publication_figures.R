source("R/model.R")
dir.create("results", showWarnings=FALSE, recursive=TRUE)

baseline <- read.csv("results/baseline.csv")
pdf("results/figure-baseline.pdf", width=8, height=5)
par(mar=c(7,5,3,1))
bp <- barplot(rbind(baseline$exact, baseline$estimate),
  beside=TRUE, col=c("gray30","gray75"), border=NA,
  names.arg=c("Eventual win","Absorption by 10","Win by 10"),
  ylab="Probability", ylim=c(0,0.65),
  main="Gambler's ruin: exact versus Monte Carlo")
arrows(bp[2,],baseline$lower_95,bp[2,],baseline$upper_95,
  angle=90,code=3,length=0.05)
legend("topright",c("Exact","Monte Carlo / Wilson 95% CI"),
  fill=c("gray30","gray75"),bty="n")
mtext("100,000 independent simulated games",side=1,line=5)
dev.off()

coverage <- read.csv("results/coverage-study.csv")
pdf("results/figure-coverage.pdf",width=8,height=5)
plot(coverage$n,100*coverage$coverage,log="x",type="b",pch=19,
  xlab="Games per estimate (log scale)",
  ylab="Observed coverage (%)",ylim=c(93,97),
  main="Wilson interval calibration: 5,000 replicates per size")
arrows(coverage$n,100*(coverage$coverage-1.96*coverage$coverage_mc_se),
  coverage$n,100*(coverage$coverage+1.96*coverage$coverage_mc_se),
  angle=90,code=3,length=0.05)
abline(h=95,lty=2)
legend("bottomright",c("Observed +/- 1.96 MC SE","Nominal 95%"),
  lty=c(1,2),pch=c(19,NA),bty="n")
dev.off()

writeLines(c(
  "# Figure captions",
  "",
  "Figure 1: Exact absorption events versus 100,000 simulated games.",
  "Intervals show Wilson uncertainty for simulated proportions.",
  "Absorption within ten flips includes wins and losses.",
  "",
  "Figure 2: Estimated Wilson coverage over 5,000 independent binomial",
  "replicates for each workload. Bars show 1.96 Monte Carlo standard",
  "errors of estimated coverage, not uncertainty in game parameters."
), "results/FIGURE_CAPTIONS.md")
cat("Publication figures produced.\n")
