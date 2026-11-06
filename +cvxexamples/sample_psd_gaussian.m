function samples = sample_psd_gaussian(covariance, sampleCount)
%SAMPLE_PSD_GAUSSIAN Draw real Gaussian vectors with the given covariance.
% The covariance may be positive semidefinite and singular. Tiny negative
% eigenvalues caused by numerical solver tolerances are clipped to zero.

validateattributes(covariance, {"numeric"}, ...
    {"real", "2d", "square", "finite", "nonempty"});
validateattributes(sampleCount, {"numeric"}, ...
    {"real", "scalar", "integer", "positive", "finite"});

covariance = double((covariance + covariance') / 2);
[eigenvectors, eigenvalues] = eig(covariance);
lambda = real(diag(eigenvalues));
tolerance = 1e-10 * max(1, norm(covariance, "fro"));

if any(lambda < -tolerance)
    error("cvxexamples:CovarianceNotPSD", ...
        "The supplied covariance matrix is not positive semidefinite.");
end

lambda = max(lambda, 0);
factor = real(eigenvectors) * diag(sqrt(lambda));
samples = factor * randn(size(covariance, 1), sampleCount);
end
