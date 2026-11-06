# Mathematical formulations

All six scripts generate synthetic real-valued problem data. The notation below describes the implemented models. The SDP examples use real symmetric positive-semidefinite matrices; the first SOCP example uses complex beamforming variables.

## 1. Multiuser beamforming SOCP

Let h_k be the channel row vector for user k and let W=[w_1,...,w_K] be the complex beamforming matrix. For a target SINR gamma>0, the script solves

[
egin{aligned}
min_{W,\tau}\quad & \tau \\
\text{s.t.}\quad &
\|h_k W\|_2 \le \sqrt{1+1/\gamma}\,\operatorname{Re}(h_k w_k),\\
&\operatorname{Im}(h_k w_k)=0,\quad k=1,\ldots,K,\\
&\|W\|_F^2\le\tau.
\end{aligned}
]

The phase constraint fixes the desired signal to the nonnegative real axis, giving a second-order-cone representation of the SINR condition. The objective is total transmit power.

## 2. Multiuser downlink covariance SDP

For each user, a real channel vector h_k induces H_k=h_k h_k^T. X_k is the positive-semidefinite transmit covariance assigned to user k. The script solves

[
\begin{aligned}
\min_{X_1,\ldots,X_K}\quad & \sum_{k=1}^K \operatorname{tr}(X_k)\\
\text{s.t.}\quad &
\operatorname{tr}(H_kX_k)\ge
\gamma\left(\sum_{j\ne k}\operatorname{tr}(H_kX_j)+1\right),\\
&X_k\succeq0,\quad k=1,\ldots,K.
\end{aligned}
]

The identity noise term is normalized to one. The covariance formulation is an SDP relaxation of rank-constrained beamforming; no rank-one restriction is imposed on X_k.

## 3. Quadratic constraints with SDR

Given a positive-definite cost matrix C and positive-semidefinite constraint matrices A_i, the lifted relaxation is

[
\begin{aligned}
\min_X\quad &\operatorname{tr}(CX)\\
\text{s.t.}\quad &\operatorname{tr}(A_iX)\ge1,\quad i=1,\ldots,K,\\
&X\succeq0.
\end{aligned}
]

This is the relaxation of a vector problem with X=xx^T and rank(X)=1. Gaussian randomization draws x from a zero-mean Gaussian with covariance X. Each draw is scaled by the square root of its smallest quadratic response, producing a candidate satisfying all lower-bound constraints when that response is positive. The best feasible candidate among the sampled draws is reported.

## 4. Binary quadratic optimization

The original binary problem is

[
\min_{x\in\{-1,+1\}^M} x^TQx,
]

where Q is real symmetric. Its standard lifted relaxation is

[
\begin{aligned}
\min_X\quad &\operatorname{tr}(QX)\\
\text{s.t.}\quad &\operatorname{diag}(X)=\mathbf{1},\\
&X\succeq0.
\end{aligned}
]

The script compares the SDP objective (a lower bound for this minimization problem) with feasible binary vectors obtained by sign-rounding Gaussian samples and the dominant eigenvector of X. Rounded candidates are feasible for the binary domain, so their objective values are upper bounds on the binary optimum.

## 5. Max-min quadratic optimization

For positive-semidefinite matrices H_k, the relaxation is

[
\begin{aligned}
\max_{X,t}\quad &t\\
\text{s.t.}\quad &\operatorname{tr}(H_kX)\ge t,\quad k=1,\ldots,K,\\
&\operatorname{tr}(X)=1,\quad X\succeq0.
\end{aligned}
]

The relaxed optimum is an upper bound on the rank-one constrained maximum. The script extracts a unit-norm dominant eigenvector v and evaluates vv^T, which preserves positive semidefiniteness and unit trace. Its worst-case response is a feasible rank-one candidate value.

## 6. Minimum-norm quadratic optimization

For positive-semidefinite matrices Q_i, the lifted relaxation is

[
\begin{aligned}
\min_X\quad &\operatorname{tr}(X)\\
\text{s.t.}\quad &\operatorname{tr}(Q_iX)\ge1,\quad i=1,\ldots,K,\\
&X\succeq0.
\end{aligned}
]

Gaussian samples with covariance X are scaled to satisfy every quadratic lower bound. The squared Euclidean norm of the best feasible sample is compared with the SDP relaxation objective.

## Interpretation and limitations

- SDR objectives are bounds only when the relaxation and original nonconvex problem have the stated relationship. Do not label every plotted curve as an achieved nonconvex optimum.
- A randomized candidate is only as good as the number of samples and the feasibility checks. Increase the sample count for a more extensive search.
- The scripts use independent synthetic random instances, not a fixed external benchmark dataset.
- An `Inaccurate/Solved` CVX result is retained with a warning; inspect solver tolerances and residuals before relying on it.
