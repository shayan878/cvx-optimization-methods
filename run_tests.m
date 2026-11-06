function results = run_tests()
%RUN_TESTS Execute MATLAB unit tests for the shared project utilities.
% These tests do not solve the example optimization models.

root = fileparts(mfilename("fullpath"));
addpath(root);
testFolder = fullfile(root, "tests");
results = runtests(testFolder);
assert(all([results.Passed]), "One or more MATLAB utility tests failed.");
end
