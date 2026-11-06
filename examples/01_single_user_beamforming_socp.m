%% Example 1: Multiuser downlink beamforming as an SOCP
% Minimize total beamformer power while satisfying a target SINR for each
% single-antenna user. The phase constraint makes the SOC representation
% equivalent to the corresponding SINR inequality.

clearvars;
close all;
clc;

cvxexamples.require_cvx();
rng(202601, "twister");

M = 4;                       % Number of transmit antennas
K = 4;                       % Number of users
gamma = 1;                   % Target SINR (linear scale)
numTrials = 100;

totalPower = nan(1, numTrials);

for trial = 1:numTrials
    H = randn(K, M);         % Row k is the channel of user k

    cvx_begin quiet
        variable tau nonnegative
        variable W(M, K) complex
        minimize(tau)
        subject to
            for user = 1:K
                desired = H(user, :) * W(:, user);
                norm(H(user, :) * W, 2) <= ...
                    sqrt(1 + 1 / gamma) * real(desired);
                imag(desired) == 0;
            end
            sum_square_abs(W(:)) <= tau;
    cvx_end

    cvxexamples.assert_solved(cvx_status, ...
        sprintf("SOCP trial %d", trial));
    totalPower(trial) = cvx_optval;
end

figure("Name", "SOCP beamforming power");
plot(1:numTrials, totalPower, "LineWidth", 1.4);
grid on;
xlabel("Random channel realization");
ylabel("Minimum transmit power");
title(sprintf("SOCP beamforming: M=%d, K=%d, target SINR=%.2f", ...
    M, K, gamma));
