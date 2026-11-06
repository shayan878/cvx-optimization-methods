function setup_project()
%SETUP_PROJECT Add the repository root to the MATLAB search path.
% Run this function from any working directory after cloning the project.

root = fileparts(mfilename("fullpath"));
addpath(root);
fprintf("CVX optimization examples added to the MATLAB path:\n%s\n", root);
fprintf("Run run_tests to execute the MATLAB utility tests.\n");
end
