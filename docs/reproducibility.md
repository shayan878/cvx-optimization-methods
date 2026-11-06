# Reproducibility and numerical validation

## Randomness

Each example sets a named MATLAB random seed with `rng(seed, "twister")`. Keep that seed, the trial count, and randomization sample count fixed when comparing code revisions. To explore other realizations, change the seed explicitly.

## Solver configuration

CVX is an external dependency. The examples use the solver configured by the local CVX installation; record `cvx_version`, the solver name, MATLAB release, and any solver-specific tolerances when publishing numerical results. A fixed random seed does not guarantee bit-for-bit identical results across solver versions or platforms.

## Status checks

Every optimization run passes `cvx_status` through `cvxexamples.assert_solved`. Only `Solved` and `Inaccurate/Solved` are accepted. The latter produces a warning and should be inspected before using the result.

## Testing layers

- `run_tests` runs MATLAB unit tests for the shared PSD Gaussian sampler and status validation.
- The GitHub Actions workflow checks that the example sources and expected CVX blocks are present. It does not run MATLAB, CVX, or an optimization solver.
- Each example must be run locally with a working MATLAB and CVX installation to validate solver execution and inspect numerical outputs.

## Reporting results

When reporting results, include MATLAB release, CVX version, selected solver and version, random seed, problem dimensions, number of trials, number of randomization samples, and solver status. Treat plots from these scripts as experiments on generated instances, not as universal performance claims.
