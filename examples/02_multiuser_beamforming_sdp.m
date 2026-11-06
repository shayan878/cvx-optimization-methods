%% Example 2: Multiuser downlink beamforming using an SDP relaxation
% X(:,:,k) is the transmit covariance assigned to user k. The channel
% matrices are generated as h_k*h_k', ensuring that each is PSD.

clearvars;
close all;
clc;

cvxexamples.require_cvx();
rng(202602, "twister");

M = 4;                       % Number of transmit antennas
K = 4;                       % Number of users
gamma = 1;                   % Target SINR (linear scale)
numTrials = 100;

totalPower = nan(1, numTrials);

for trial = 1:numTrials
    H = zeros(M, M, K);
    for user = 1:K
        channel = randn(M, 1);
        H(:, :, user) = channel * channel';
    end

    cvx_begin quiet
        variable X(M, M, K)
        expression total_power
        expression interference(K)
        total_power = 0;

        for user = 1:K
            total_power = total_power + trace(X(:, :, user));
            interference(user) = 0;
            for other = 1:K
                if other ~= user
                    interference(user) = interference(user) + ...
                        trace(H(:, :, user) * X(:, :, other));
                end
            end
            X(:, :, user) == semidefinite(M);
            trace(H(:, :, user) * X(:, :, user)) >= ...
                gamma * interference(user) + gamma;
        end
        minimize(total_power)
    cvx_end

    cvxexamples.assert_solved(cvx_status, ...
        sprintf("Multiuser SDP trial %d", trial));
    totalPower(trial) = cvx_optval;
end

figure("Name", "Multiuser beamforming SDP");
plot(1:numTrials, totalPower, "LineWidth", 1.4);
grid on;
xlabel("Random channel realization");
ylabel("Minimum total transmit power");
title(sprintf("Multiuser beamforming SDP: M=%d, K=%d, target SINR=%.2f", ...
    M, K, gamma));
