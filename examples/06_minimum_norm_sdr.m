%% Example 6: Minimum-norm quadratic optimization with SDR and randomization
% Relax the rank-one matrix xx' to X >= 0 and minimize trace(X) subject
% to trace(Q_k*X)>=1. Gaussian candidates are scaled until every original
% quadratic lower-bound constraint is satisfied.

clearvars;
close all;
clc;

cvxexamples.require_cvx();
rng(202606, "twister");

M = 4;
K = 4;
numTrials = 100;
numSamples = 50;

relaxedObjective = nan(1, numTrials);
randomizedObjective = nan(1, numTrials);

for trial = 1:numTrials
    Q = zeros(M, M, K);
    for constraint = 1:K
        G = randn(M, M);
        Q(:, :, constraint) = G' * G;
    end

    cvx_begin quiet
        variable X(M, M) symmetric
        minimize(trace(X))
        subject to
            X == semidefinite(M);
            for constraint = 1:K
                trace(Q(:, :, constraint) * X) >= 1;
            end
    cvx_end

    cvxexamples.assert_solved(cvx_status, ...
        sprintf("Minimum-norm SDP trial %d", trial));
    relaxedObjective(trial) = cvx_optval;

    samples = cvxexamples.sample_psd_gaussian(X, numSamples);
    candidateValues = inf(numSamples, 1);

    for sample = 1:numSamples
        candidate = samples(:, sample);
        quadraticValues = zeros(K, 1);
        for constraint = 1:K
            quadraticValues(constraint) = ...
                real(candidate' * Q(:, :, constraint) * candidate);
        end

        minimumValue = min(quadraticValues);
        if minimumValue > eps
            candidate = candidate / sqrt(minimumValue);
            candidateValues(sample) = real(candidate' * candidate);
        end
    end

    randomizedObjective(trial) = min(candidateValues);
end

figure("Name", "Minimum-norm SDR");
plot(1:numTrials, relaxedObjective, "-", "LineWidth", 1.4, ...
    "DisplayName", "SDP relaxation");
hold on;
plot(1:numTrials, randomizedObjective, "--", "LineWidth", 1.4, ...
    "DisplayName", "Feasible randomized candidate");
grid on;
xlabel("Random problem instance");
ylabel("Squared vector norm");
title("Minimum-norm quadratic problem: SDP relaxation and randomization");
legend("Location", "best");
hold off;
