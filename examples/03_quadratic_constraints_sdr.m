%% Example 3: Quadratic constraints, semidefinite relaxation, and randomization
% Relax the rank-one matrix xx' to X >= 0, solve the SDP, then generate
% feasible vector candidates by Gaussian randomization and scaling.

clearvars;
close all;
clc;

cvxexamples.require_cvx();
rng(202603, "twister");

M = 4;
K = 4;
numTrials = 100;
numSamples = 50;

relaxedObjective = nan(1, numTrials);
randomizedObjective = nan(1, numTrials);
C = gallery("lehmer", M);    % Symmetric positive-definite cost matrix

for trial = 1:numTrials
    A = zeros(M, M, K);
    for constraint = 1:K
        G = randn(M, M);
        A(:, :, constraint) = G' * G;
    end

    cvx_begin quiet
        variable X(M, M) symmetric
        minimize(trace(C * X))
        subject to
            X == semidefinite(M);
            for constraint = 1:K
                trace(A(:, :, constraint) * X) >= 1;
            end
    cvx_end

    cvxexamples.assert_solved(cvx_status, ...
        sprintf("Quadratic-constraint SDP trial %d", trial));
    relaxedObjective(trial) = cvx_optval;

    samples = cvxexamples.sample_psd_gaussian(X, numSamples);
    candidateValues = inf(numSamples, 1);

    for sample = 1:numSamples
        candidate = samples(:, sample);
        quadraticValues = zeros(K, 1);
        for constraint = 1:K
            quadraticValues(constraint) = ...
                real(candidate' * A(:, :, constraint) * candidate);
        end

        minimumValue = min(quadraticValues);
        if minimumValue > eps
            candidate = candidate / sqrt(minimumValue);
            candidateValues(sample) = real(candidate' * C * candidate);
        end
    end

    randomizedObjective(trial) = min(candidateValues);
end

figure("Name", "Quadratic constraints SDR");
plot(1:numTrials, relaxedObjective, "-", "LineWidth", 1.4, ...
    "DisplayName", "SDP relaxation");
hold on;
plot(1:numTrials, randomizedObjective, "--", "LineWidth", 1.4, ...
    "DisplayName", "Feasible randomized candidate");
grid on;
xlabel("Random problem instance");
ylabel("Objective value");
title("Quadratic constraints: SDP relaxation and Gaussian randomization");
legend("Location", "best");
hold off;
