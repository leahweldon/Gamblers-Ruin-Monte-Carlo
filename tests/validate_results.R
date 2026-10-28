source("R/model.R")
x <- read.csv("results/baseline.csv")
expected <- exact_summary(2,10,0.5,10)
stopifnot(nrow(x)==3L,
  identical(x$metric,c("eventual_win","end_by_horizon","win_by_horizon")),
  all(x$n==100000),all(x$lower_95<=x$estimate),
  all(x$estimate<=x$upper_95))
stopifnot(max(abs(x$exact - as.numeric(expected[x$metric]))) < 1e-12)
se <- sqrt(x$exact*(1-x$exact)/x$n)
stopifnot(all(abs(x$estimate-x$exact) < 5*se))
stopifnot(all(x$lower_95 <= x$exact & x$exact <= x$upper_95))
y <- read.csv("results/first-passage.csv")
stopifnot(nrow(y)==101L,all(y$ruin>=0),all(y$win>=0),
  sum(y$ruin+y$win)<=1+1e-12,
  sum(y$ruin+y$win)>0.99, sum(y$win)<=0.2+1e-12)
z <- read.csv("results/sensitivity.csv")
stopifnot(nrow(z)==30L,all(z$exact_win>=0 & z$exact_win<=1))
for (p in unique(z$p)) {
  a <- z[z$p==p,]
  stopifnot(all(diff(a$exact_win[order(a$start)])>0))
}
for (s in unique(z$start)) {
  a <- z[z$start==s,]
  stopifnot(all(diff(a$exact_win[order(a$p)])>0))
}
stopifnot(all(file.exists(c("results/first-passage.pdf","results/sensitivity.pdf"))))
cat("Generated results validated.\n")
