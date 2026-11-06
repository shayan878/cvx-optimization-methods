function tests = test_helpers()
%TEST_HELPERS Unit tests for shared MATLAB utilities.
tests = functiontests(localfunctions);
end

function testSamplerShape(testCase)
rng(11, "twister");
covariance = [2, 0.4; 0.4, 1];
samples = cvxexamples.sample_psd_gaussian(covariance, 25);
verifySize(testCase, samples, [2, 25]);
end

function testSamplerEmpiricalCovariance(testCase)
rng(12, "twister");
covariance = [2, 0.4; 0.4, 1];
samples = cvxexamples.sample_psd_gaussian(covariance, 20000);
empirical = cov(samples');
verifyLessThan(testCase, norm(empirical - covariance, "fro"), 0.06);
end

function testSamplerSupportsSingularCovariance(testCase)
rng(13, "twister");
covariance = [1, 1; 1, 1];
samples = cvxexamples.sample_psd_gaussian(covariance, 100);
verifyLessThan(testCase, max(abs(samples(1, :) - samples(2, :))), 1e-10);
end

function testSamplerRejectsIndefiniteInput(testCase)
covariance = [1, 2; 2, 1];
verifyError(testCase, ...
    @() cvxexamples.sample_psd_gaussian(covariance, 10), ...
    "cvxexamples:CovarianceNotPSD");
end

function testSamplerRejectsInvalidSampleCount(testCase)
didThrow = false;
try
    cvxexamples.sample_psd_gaussian(eye(2), 0);
catch
    didThrow = true;
end
verifyTrue(testCase, didThrow);
end

function testSolvedStatusAccepted(testCase)
verifyWarningFree(testCase, ...
    @() cvxexamples.assert_solved("Solved", "unit test"));
end

function testUnsuccessfulStatusRejected(testCase)
verifyError(testCase, ...
    @() cvxexamples.assert_solved("Infeasible", "unit test"), ...
    "cvxexamples:UnsuccessfulSolve");
end
