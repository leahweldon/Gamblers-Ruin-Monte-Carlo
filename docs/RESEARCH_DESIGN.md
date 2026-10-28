# Research design and interpretation

## Scope

We study an absorbing nearest-neighbour random walk on integer states 0,1,...,N. From each interior state the capital increases by one with probability p and decreases by one with probability 1-p. States 0 (ruin) and N (target) are absorbing. The historical £20 / £100 case with £10 stakes corresponds to i=2, N=10, p=0.5.

### Questions

1. Does the implemented Monte Carlo estimator agree with an independent exact solution?
2. How does even a modest bias affect the probability of reaching the target?
3. What proportion of games terminate by a fixed horizon, and how many are still running?
4. How does Monte Carlo accuracy improve with computational budget?
5. When is direct simulation preferable to exact dynamic programming?

## Methods

For fair play, the eventual target probability is i/N and the expected absorption time is i(N-i). For biased play, q=1-p and p != q, the exact target probability is (1-(q/p)^i)/(1-(q/p)^N), evaluated with numerically stable exponentials where possible.

A separate transient-state Markov chain Q provides the absorption probabilities by solving (I-Q)h=r, and the mean hitting time by solving (I-Q)t=1. For finite horizons, dynamic programming evolves the transient probability mass and records first-passage mass at each boundary. The total recorded first-passage probability need not equal one at a finite horizon: its complement is the probability that the game remains active.

Monte Carlo reports sample proportions and two-sided Wilson intervals. Coverage is a repeated-sampling property; an individual 95% interval does not guarantee it contains the exact value. Validation tests should avoid treating a single seeded run as a proof of coverage.

## Reproducibility and caveats

Use fixed seeds, record the R runtime version in CI, retain generated CSVs and plots as CI artifacts, and keep all machine-generated outputs distinct from source files. The model omits changing stakes, dependence between flips, economic transaction costs, and behavioural responses. Bias scenarios are hypothetical parameters, not empirical casino estimates.

## Report release gate

Populate the results section only after running the relevant experiments and reviewing generated outputs. Do not describe unrun scenarios as measured findings, and do not claim numerical benchmarking without actual timings.
