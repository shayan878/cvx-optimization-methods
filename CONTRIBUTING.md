# Contributing

Contributions that improve mathematical clarity, numerical robustness, reproducibility, or documentation are welcome.

## Before making changes

1. Keep each example independently runnable from the repository root.
2. Document any change to an objective, constraint, data-generation process, or approximation method in `docs/model-formulations.md`.
3. Preserve deterministic random seeds unless a change intentionally updates the experiment.
4. Run `run_tests` in MATLAB and run `python scripts/validate_repository.py`.
5. Run the affected example with a configured MATLAB/CVX installation and record solver status.

Do not add generated plots, solver logs, machine-specific paths, or external credentials to commits. Do not claim solver validation unless the corresponding MATLAB/CVX run was actually executed.
