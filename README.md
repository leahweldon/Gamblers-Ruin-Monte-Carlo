
# Gambler's Ruin — Monte Carlo & Absorbing Markov Chains

[![R validation](https://github.com/leahweldon/Gamblers-Ruin-Monte-Carlo/actions/workflows/r-check.yml/badge.svg)](https://github.com/leahweldon/Gamblers-Ruin-Monte-Carlo/actions/workflows/r-check.yml)
![R](https://img.shields.io/badge/R-Base%20R-276DC3?logo=r&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A reproducible computational investigation of **Gambler's Ruin**, combining exact probability theory, absorbing Markov chains, Monte Carlo simulation, statistical uncertainty analysis, and performance benchmarking.

The project investigates how starting capital, target wealth, and the probability of winning an individual bet affect both the likelihood of success and the time required to reach an absorbing boundary.

## Research overview

Gambler's Ruin is a classical problem in stochastic processes. Consider a gambler whose capital changes by one unit after each independent trial:

- With probability \(p\), capital increases by one unit.
- With probability \(1-p\), capital decreases by one unit.
- The game terminates when capital reaches either \(0\) (ruin) or \(N\) (target).

This project approaches the problem using complementary analytical and computational methods:

- **Exact analysis:** Theoretical hitting probabilities, absorption-time moments, and finite-horizon first-passage probabilities.
- **Monte Carlo simulation:** Independently simulated trajectories, compared against exact mathematical results.
- **Statistical experimentation:** Convergence, confidence interval coverage, parameter sensitivity, and computational performance.

## Key findings

The motivating example begins with £20, uses £10 stakes, and terminates at either £0 or £100.

In integer units:

`start = 2`, `target = 10`, `p = 0.5`

| Quantity | Exact result |
|---|---:|
| Probability of eventually reaching £100 | 20.00% |
| Probability of reaching either boundary within 10 flips | 56.0547% |
| Probability of reaching £100 within 10 flips | 1.1719% |
| Expected number of flips until absorption | 16 |

**Finishing within ten flips is not the same as winning within ten flips.** The former includes both ruin and success.

In a seeded experiment involving 100,000 simulated trajectories, the estimated eventual success probability was approximately **19.899%**, compared with the exact value of 20%.

Further experiments found that:

- Monte Carlo estimation error decreased with increasing sample size, consistent with the theoretical \(n^{-1/2}\) convergence rate.
- A 20,000-replicate binomial experiment produced empirical Wilson confidence interval coverage close to the nominal 95% level at the tested sample sizes.
- Exact success probabilities and expected stopping times varied with initial capital and coin bias.

For details and limitations, see [Research Findings](docs/RESULTS.md) and [Research Design](docs/RESEARCH_DESIGN.md).

## Methods and implementation

| Component | Purpose |
|---|---|
| Exact hitting probabilities | Closed-form success probabilities under fair and biased play |
| Absorbing Markov chains | Transition matrices and absorption-time moments |
| First-passage analysis | Probabilities of absorption at individual time steps |
| Monte Carlo simulation | Seeded simulation of independent random-walk trajectories |
| Wilson confidence intervals | Uncertainty quantification for simulated proportions |
| Convergence experiments | Empirical estimation error compared with theoretical predictions |
| Parameter sensitivity | Analysis across starting balances and coin biases |
| Performance benchmarks | Execution times across different simulation workloads |

The implementation uses **base R**, with no additional R package dependencies.

## Repository structure

```text
Gamblers-Ruin-Monte-Carlo/
├── R/
│   ├── model.R
│   └── simulation.R
├── scripts/
│   ├── run_experiments.R
│   ├── research_experiments.R
│   ├── coverage_study.R
│   ├── benchmark.R
│   └── publication_figures.R
├── tests/
│   ├── test_all.R
│   ├── test_independent_theory.R
│   ├── test_numerical_stability.R
│   ├── test_trajectory_contracts.R
│   ├── test_first_passage_boundaries.R
│   ├── validate_results.R
│   ├── validate_research.R
│   ├── validate_coverage.R
│   ├── validate_benchmark.R
│   └── release_gate.R
├── docs/
│   ├── RESEARCH_DESIGN.md
│   ├── RESULTS.md
│   └── PROVENANCE.md
├── results/
│   └── README.md
├── .github/workflows/r-check.yml
├── .gitignore
├── LICENSE
└── README.md
```

## Reproducing the research

**Requirements:** R and a terminal capable of running `Rscript`.

Clone the repository:

```bash
git clone https://github.com/leahweldon/Gamblers-Ruin-Monte-Carlo.git
cd Gamblers-Ruin-Monte-Carlo
```

### 1. Run mathematical and simulation tests

```bash
Rscript tests/test_all.R
Rscript tests/test_independent_theory.R
Rscript tests/test_trajectory_contracts.R
Rscript tests/test_first_passage_boundaries.R
Rscript tests/test_numerical_stability.R
```

### 2. Generate and validate research experiments

```bash
Rscript scripts/run_experiments.R
Rscript tests/validate_results.R

Rscript scripts/research_experiments.R
Rscript tests/validate_research.R

Rscript scripts/coverage_study.R
Rscript tests/validate_coverage.R

Rscript scripts/benchmark.R
Rscript tests/validate_benchmark.R
```

### 3. Generate figures and validate artifacts

```bash
Rscript scripts/publication_figures.R
Rscript tests/release_gate.R
```

Generated CSV datasets and PDF figures are written to `results/`. These outputs are reproducible artifacts and are excluded from normal source-control tracking.

## Automated verification

GitHub Actions runs the mathematical tests, simulation experiments, statistical checks, performance benchmarks, figure generation, and artifact validation on each push and pull request.

The workflow retains generated research outputs as downloadable artifacts.

[View GitHub Actions](https://github.com/leahweldon/Gamblers-Ruin-Monte-Carlo/actions)

## Scientific limitations

The model assumes independent Bernoulli trials, fixed stakes, fixed absorbing boundaries, and no transaction costs.

Monte Carlo confidence intervals quantify **sampling uncertainty under the assumed model**, not uncertainty arising from model misspecification.

The confidence interval coverage study concerns the eventual-win indicator. Benchmark measurements are environment-specific and should not be interpreted as portable performance guarantees.

The computational experiments support the theoretical analysis but do not constitute formal proof of every implementation property.

## Project background and provenance

The motivating problem was explored in a 2022 university Applied Probability I group assignment.

This repository is a **separate, modern computational research extension**, rather than a reproduction of the original coursework submission. 

See [Provenance](docs/PROVENANCE.md) for further context.

## Licence

Copyright © 2026 Leah Weldon.

Licensed under the **MIT License**. See [LICENSE](LICENSE) for details.
