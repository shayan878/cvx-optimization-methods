"""Static repository checks; these checks do not execute MATLAB or CVX."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXAMPLES = (
    "01_single_user_beamforming_socp.m",
    "02_multiuser_beamforming_sdp.m",
    "03_quadratic_constraints_sdr.m",
    "04_binary_quadratic_sdr.m",
    "05_max_min_sdr.m",
    "06_minimum_norm_sdr.m",
)


def main() -> int:
    errors: list[str] = []

    required_files = (
        "README.md",
        "docs/model-formulations.md",
        "docs/reproducibility.md",
        "+cvxexamples/assert_solved.m",
        "+cvxexamples/sample_psd_gaussian.m",
        "run_tests.m",
    )
    for relative in required_files:
        if not (ROOT / relative).is_file():
            errors.append(f"Missing required project file: {relative}")

    for name in EXAMPLES:
        path = ROOT / "examples" / name
        if not path.is_file():
            errors.append(f"Missing example: examples/{name}")
            continue
        source = path.read_text(encoding="utf-8")
        code = "\n".join(line.split("%", 1)[0] for line in source.splitlines())
        begin_count = len(re.findall(r"^\s*cvx_begin\b", code, re.MULTILINE))
        end_count = len(re.findall(r"^\s*cvx_end\b", code, re.MULTILINE))
        if begin_count != 1 or end_count != 1:
            errors.append(f"{name}: expected one cvx_begin and one cvx_end block")
        if "cvxexamples.assert_solved" not in source:
            errors.append(f"{name}: missing CVX status validation")
        if 'rng(' not in source:
            errors.append(f"{name}: missing explicit random seed")

    all_matlab = "\n".join(
        path.read_text(encoding="utf-8")
        for folder in ("examples", "+cvxexamples")
        for path in (ROOT / folder).glob("*.m")
    )
    if "mvnrnd(" in all_matlab:
        errors.append("Remove mvnrnd dependency; use the base-MATLAB sampler.")
    if "display(samples)" in all_matlab:
        errors.append("Remove unconditional sample-array display from examples.")

    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        return 1

    print(f"Repository structure checks passed ({len(EXAMPLES)} MATLAB examples).")
    print("Note: these checks do not execute MATLAB, CVX, or a numerical solver.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
