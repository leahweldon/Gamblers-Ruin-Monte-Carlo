# Release verification gate: machine-checkable and conservative.
required <- c("results/baseline.csv","results/coverage-study.csv",
 "results/convergence-summary.csv","results/extended-sensitivity.csv",
 "results/benchmark-summary.csv","results/figure-baseline.pdf",
 "results/figure-coverage.pdf","results/FIGURE_CAPTIONS.md")
missing <- required[!file.exists(required)]
if (length(missing)) stop(paste("Missing release artifacts:",paste(missing,collapse=", ")))
figures <- required[grepl("[.]pdf$",required)]
for (f in figures) {
 size <- file.info(f)$size
 if (!is.finite(size) || size<1500) stop(paste("Empty or suspicious PDF:",f))
 h <- readBin(f,"raw",n=4)
 if (!identical(rawToChar(h),"%PDF")) stop(paste("Invalid PDF header:",f))
}
b <- read.csv("results/baseline.csv")
stopifnot(nrow(b)==3L,all(is.finite(b$estimate)),
 all(b$estimate>=0 & b$estimate<=1))
cov <- read.csv("results/coverage-study.csv")
stopifnot(nrow(cov)==4L,all(cov$replicates==5000L))
cat("Required release evidence passed structural checks.\n")
