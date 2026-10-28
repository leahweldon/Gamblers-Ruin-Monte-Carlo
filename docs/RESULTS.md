# Reproducible findings

The baseline fair game (start=2, target=10, p=0.5) has exact eventual success
probability 20%, absorption by ten flips 56.0546875%, target success by ten
flips 1.171875%, and expected stopping time 16 steps.

In a seeded 100,000-game development run, observed proportions were 19.899%,
56.105%, and 1.163% respectively. These are one sample, not exact truths.

A 32-replicate convergence study at sample sizes 250, 1000, 4000, and 16000
showed decreasing empirical RMSE broadly consistent with the n^(-1/2) rate.
Coverage estimates based on only 32 replicates were exploratory.

A separate 5,000-replicate-per-size binomial Wilson-interval coverage experiment
recorded 94.86%, 95.58%, 94.76%, and 95.28% coverage at sample sizes 50, 250,
1000, and 4000. The corresponding mean interval widths were approximately
21.49, 9.84, 4.95, and 2.48 percentage points.

Those values are provenance-labelled *development-run observations*, not
measurements from this public repository. Run its own CI workflow and inspect
the regenerated CSVs and PDFs to verify the public build independently.

The mathematical assumptions include iid coin tosses, fixed stakes and
absorbing endpoints; neither Monte Carlo intervals nor exact solutions cover
model misspecification. Runtime benchmarks are environment-specific.
