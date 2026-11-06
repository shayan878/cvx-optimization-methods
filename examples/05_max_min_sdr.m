%% Example 5: Max-min quadratic optimization with an SDP relaxation
% Maximize the minimum response trace(H_k*X) subject to trace(X)=1 and
% X >= 0. A normalized dominant-eigenvector candidate yields a feasible
% rank-one matrix with unit trace.

clearvars;
close all;
clc;

cvxexamples.require_cvx();
rng(202605, "twister");

M = 4;
K = 4;
numTrials = 100;

relaxedObjective = nan(1, numTrials);
rankOneObjective = nan(1, numTrials);

for trial = 1:numTrials
    channels = randn(M, K);
    H = zeros(M, M, K);
    for user = 1:K
        channel = channels(:, user);
        H(:, :, user) = channel * channel';
    end

    cvx_begin quiet
        variable X(M, M) symmetric
        variable t
        maximize(t)
        subject to
            trace(X) == 1;
            X == semidefinite(M);
            for user = 1:K
                trace(X * H(:, :, user)) >= t;
            end
    cvx_end

    cvxexamples.assert_solved(cvx_status, ...
        sprintf("Max-min SDP trial %d", trial));
    relaxedObjective(trial) = cvx_optval;

    [vectors, values] = eig((X + X') / 2);
    [~, dominantIndex] = max(real(diag(values)));
    dominantVector = real(vectors(:, dominantIndex));
    dominantVector = dominantVector / norm(dominantVector);
    rankOneMatrix = dominantVector * dominantVector';

    responses = zeros(K, 1);
    for user = 1:K
        responses(user) = real(trace(rankOneMatrix * H(:, :, user)));
    end
    rankOneObjective(trial) = min(responses);
end

figure("Name", "Max-min SDP");
plot(1:numTrials, relaxedObjective, "-", "LineWidth", 1.4, ...
    "DisplayName", "SDP relaxation");
hold on;
plot(1:numTrials, rankOneObjective, ":", "LineWidth", 1.6, ...
    "DisplayName", "Feasible rank-one candidate");
grid on;
xlabel("Random problem instance");
ylabel("Worst-case quadratic response");
title("Max-min quadratic optimization: relaxation and rank-one extraction");
legend("Location", "best");
hold off;
