function require_cvx()
%REQUIRE_CVX Ensure that the CVX modeling environment is available.
if exist("cvx_begin", "file") == 0
    error("cvxexamples:CVXNotFound", ...
        ["CVX was not found on the MATLAB path. Install CVX from " ...
         "https://cvxr.com/cvx/, add it to the path, and run cvx_setup."]);
end
end
