source("R/simulation.R")
dir.create("results",recursive=TRUE,showWarnings=FALSE)
# Wall-clock timings depend on runner hardware and load; report observations,
# not a portable performance guarantee. Avoid timing R startup.
sizes <- c(1000L,10000L,100000L)
repetitions <- 5L
rows <- vector("list",length(sizes)*repetitions)
k <- 1L
for (n in sizes) for (rep in seq_len(repetitions)) {
  timings <- system.time({
    games <- simulate_ruin(n,start=2L,target=10L,p=0.5,
                           seed=as.integer(100000L+n+rep))
  })
  rows[[k]] <- data.frame(n=n,repetition=rep,
    elapsed_seconds=unname(timings[["elapsed"]]),
    user_seconds=unname(timings[["user.self"]]),
    mean_steps=mean(games$steps))
  k <- k+1L
}
raw <- do.call(rbind,rows)
write.csv(raw,"results/benchmark-raw.csv",row.names=FALSE)
summary <- do.call(rbind,lapply(split(raw,raw$n),function(z) {
 data.frame(n=z$n[1L],repetitions=nrow(z),
   median_elapsed_seconds=median(z$elapsed_seconds),
   min_elapsed_seconds=min(z$elapsed_seconds),
   max_elapsed_seconds=max(z$elapsed_seconds),
   mean_steps=mean(z$mean_steps))
}))
summary <- summary[order(summary$n),]
write.csv(summary,"results/benchmark-summary.csv",row.names=FALSE)
writeLines(c(paste0("R version: ",R.version.string),
  paste0("Platform: ",R.version$platform),
  paste0("OS: ",Sys.info()[["sysname"]]),
  "Timings include simulation but exclude interpreter startup.",
  "Wall-clock measurements are environment-specific and may vary."),
  "results/benchmark-environment.txt")
cat("Recorded measured simulation benchmark.\n")
