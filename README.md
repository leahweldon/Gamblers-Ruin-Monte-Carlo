# Gambler's Ruin: Monte Carlo and Absorbing Markov Chains

A reproducible base-R investigation of an absorbing random walk using exact
Markov-chain calculations, Monte Carlo trajectory simulations, uncertainty
quantification, convergence experiments, and finite-horizon first passage.

## Model

States range from 0 (ruin) to N (target), with independent unit transitions
up with probability p and down with probability 1-p. Both boundaries are absorbing.

The original motivating example uses GBP 20 starting capital, GBP 10 stakes,
and absorbing endpoints at GBP 0 and GBP 100: start=2, target=10, p=0.5.

| Event | Exact probability |
| --- | ---: |
| Eventually reach the target | 0.2 |
| Absorption at either boundary within ten flips | 0.560546875 |
| Reach target within ten flips | 0.01171875 |

Expected stopping time is 16 flips. Finishing within ten flips is **not**
the same as winning within ten flips.

## Reproduce

Install R, then from the repository root:

```sh
Rscript tests/test_all.R
Rscript tests/test_independent_theory.R
Rscript tests/test_trajectory_contracts.R
Rscript tests/test_first_passage_boundaries.R
Rscript scripts/run_experiments.R
Rscript tests/validate_results.R
Rscript scripts/research_experiments.R
Rscript tests/validate_research.R
Rscript scripts/benchmark.R
Rscript tests/validate_benchmark.R
Rscript tests/test_numerical_stability.R
Rscript scripts/coverage_study.R
Rscript tests/validate_coverage.R
Rscript scripts/publication_figures.R
Rscript tests/release_gate.R
```

All generated tables and PDF figures are placed under `results/`. CI also
retains those files as an Actions artifact. The workflow uses only base R.

## Results and interpretation

See [Research findings](docs/RESULTS.md) and [Research design](docs/RESEARCH_DESIGN.md).
Exact Markov-chain solutions are distinct from simulations and confidence
interval estimates. Benchmark results are host-specific.

## Historical and development provenance

The motivating problem was explored in a 2022 university Applied Probability I
group assignment. This repository contains a separate, modern computational
research extension with AI-assisted implementation and documentation. It does
not contain the historical coursework submission.

## Licence

