# Convex Optimization with MATLAB CVX

A collection of reproducible MATLAB examples for **convex optimization, semidefinite programming (SDP), second-order cone programming (SOCP), semidefinite relaxation (SDR), and Gaussian randomization** using [CVX](https://cvxr.com/cvx/).

The examples focus on wireless beamforming and quadratic optimization. Each script generates its own synthetic problem instances, solves the convex model, and plots the relaxed or randomized objective values.

## Repository contents

| Script | Formulation | Main idea |
|---|---|---|
| `01_single_user_beamforming_socp.m` | SOCP | Power minimization under per-user SINR constraints |
| `02_multiuser_beamforming_sdp.m` | SDP | Transmit covariance optimization for a multiuser downlink |
| `03_quadratic_constraints_sdr.m` | SDP + randomization | Minimize a quadratic cost under multiple quadratic lower bounds |
| `04_binary_quadratic_sdr.m` | SDP + rounding | Relax a binary quadratic problem and round feasible candidates |
| `05_max_min_sdr.m` | SDP + rank-one rounding | Maximize the worst-case quadratic response under a trace budget |
| `06_minimum_norm_sdr.m` | SDP + randomization | Minimize vector norm subject to quadratic lower bounds |

See [the model notes](docs/model-formulations.md) for the mathematical formulations, assumptions, and interpretation of the approximation methods.

## Requirements

- MATLAB (R2021a or newer recommended).
- [CVX](https://cvxr.com/cvx/) installed and configured for MATLAB.
- A CVX-supported solver. The examples use CVX's configured default solver unless you change it.
- No Statistics and Machine Learning Toolbox is required; Gaussian samples are generated using base MATLAB matrix operations.

Install CVX according to its official instructions, add it to the MATLAB path, and run `cvx_setup` once. CVX is a separate dependency and is not bundled in this repository.

## Quick start

Clone the repository:

```bash
git clone https://github.com/shayan878/Optimzation-with-CVX.git
cd Optimzation-with-CVX
```

In MATLAB, set the repository as the current folder or run:

```matlab
setup_project
```

Then run one example at a time:

```matlab
run(fullfile("examples", "01_single_user_beamforming_socp.m"))
run(fullfile("examples", "02_multiuser_beamforming_sdp.m"))
```

The remaining scripts follow the same pattern. Each example has a fixed random seed near its configuration block; adjust the seed, number of trials, or number of randomization samples to explore different instances and runtime/accuracy trade-offs.

## Reproducibility and solver status

The Monte Carlo examples use explicit random seeds. Every CVX solve is checked for a `Solved` or `Inaccurate/Solved` status before its result is recorded. The scripts stop with a descriptive error if CVX reports an infeasible, unbounded, or otherwise unsuccessful status.

The plotted values are results from newly generated random problem instances. They are not published benchmark data, and they should not be compared across runs unless the random seed, MATLAB/CVX versions, solver, and configuration are held fixed.

## Run the MATLAB tests

From the repository root, run:

```matlab
run_tests
```

The MATLAB unit tests cover the shared PSD Gaussian sampler and solver-status validation. They do not invoke a commercial solver or solve the six full optimization examples. Run the example scripts separately to validate end-to-end CVX execution in your local MATLAB/CVX environment.

The GitHub Actions workflow performs source-structure checks only; it does not execute MATLAB or CVX.

## Project layout

```text
.
├── +cvxexamples/             Shared MATLAB utilities
├── .github/workflows/        Repository source checks
├── docs/                     Mathematical formulations and reproducibility notes
├── examples/                 Six standalone CVX examples
├── scripts/                  Static repository validation
├── tests/                    MATLAB unit tests for shared utilities
├── run_tests.m
└── setup_project.m
```

## References

- M. Grant and S. Boyd, [CVX: MATLAB Software for Disciplined Convex Programming](https://cvxr.com/cvx/).
- S. Boyd and L. Vandenberghe, [*Convex Optimization*](https://web.stanford.edu/~boyd/cvxbook/), Cambridge University Press, 2004.
- Original introductory walkthrough: [CVX Optimization in MATLAB](https://www.youtube.com/watch?v=XOcnVQ2HkEQ).

## Scope and licensing

This is an educational collection of optimization formulations and numerical experiments, not a production solver or a certified performance benchmark. The repository does not currently declare an open-source license; reuse and redistribution are therefore not granted by this repository.
