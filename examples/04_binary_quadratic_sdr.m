%% Example 4: Binary quadratic optimization using an SDP relaxation
% The binary problem min x'*Q*x, x in {-1,+1}^M is relaxed with
% X = x*x', X >= 0, and diag(X)=1. Gaussian and spectral rounding produce
% feasible binary vectors; their objective values are upper bounds for
% the original minimization problem.

clearvars;
close all;
clc;

cvxexamples.require_cvx();
rng(202604, "twister");

M = 5;
numTrials = 100;
numSamples = 150;

relaxedObjective = nan(1, numTrials);
randomizedObjective = nan(1, numTrials);
spectralObjective = nan(1, numTrials);

for trial = 1:numTrials
    rawQ = randn(M, M);
    Q = (rawQ + rawQ') / 2;  % Enforce a real symmetric objective matrix

    cvx_begin quiet
        variable X(M, M) symmetric
        minimize(trace(Q * X))
        subject to
            diag(X) == ones(M, 1);
            X == semidefinite(M);
    cvx_end

    cvxexamples.assert_solved(cvx_status, ...
        sprintf("Binary quadratic SDP trial %d", trial));
    relaxedObjective(trial) = cvx_optval;

    samples = cvxexamples.sample_psd_gaussian(X, numSamples);
    sampleValues = nan(numSamples, 1);
    for sample = 1:numSamples
        binaryVector = sign(samples(:, sample));
        binaryVector(binaryVector == 0) = 1;
        sampleValues(sample) = binaryVector' * Q * binaryVector;
    end
    randomizedObjective(trial) = min(sampleValues);

    [vectors, values] = eig((X + X') / 2);
    [~, dominantIndex] = max(real(diag(values)));
    spectralVector = sign(real(vectors(:, dominantIndex)));
    spectralVector(spectralVector == 0) = 1;
    spectralObjective(trial) = spectralVector' * Q * spectralVector;
end

figure("Name", "Binary quadratic SDR");
plot(1:numTrials, relaxedObjective, "-", "LineWidth", 1.4, ...
    "DisplayName", "SDP lower bound");
hold on;
plot(1:numTrials, randomizedObjective, "--", "LineWidth", 1.4, ...
    "DisplayName", "Best Gaussian-rounded candidate");
plot(1:numTrials, spectralObjective, ":", "LineWidth", 1.6, ...
    "DisplayName", "Spectral-rounded candidate");
grid on;
xlabel("Random problem instance");
ylabel("Objective value");
title("Binary quadratic problem: SDP relaxation and rounding");
legend("Location", "best");
hold off;
