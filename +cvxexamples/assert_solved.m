function assert_solved(status, context)
%ASSERT_SOLVED Reject optimization runs that did not return a usable solution.
if nargin < 2
    context = "CVX optimization";
end

status = char(string(status));
accepted = ["Solved", "Inaccurate/Solved"];
if ~any(strcmp(status, accepted))
    error("cvxexamples:UnsuccessfulSolve", ...
        "%s returned CVX status '%s'. Inspect the model and solver output.", ...
        context, status);
end

if strcmp(status, "Inaccurate/Solved")
    warning("cvxexamples:InaccurateSolution", ...
        "%s returned Inaccurate/Solved. Interpret the result with care.", context);
end
end
