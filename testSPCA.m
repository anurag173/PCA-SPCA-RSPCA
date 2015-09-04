% Objective: to maximize the variance of the vectors of X 
% Anurag Prabhakar, Kamlesh Bharodiya - EE609A
clc
clear all
X = randn(20,20);
[U,Sigma,V] = svd(X); % A is symmetric and a covariance matrix
d = 20;
e = ones(d,1);

if ~exist('cvx_setup.m','file'),
    cd ~/matlab_tools/cvx/
    cvx_setup
end

lambda = 0.5;
k = 10;
tic
cvx_begin
    variable X(d,d) symmetric;
    X == semidefinite(d);
    minimize(trace(Sigma*X)+lambda*(e'*abs(X)*e));
    subject to 
        trace(X)==1;
cvx_end
toc
sprintf('Optimal variance of X is:')
strtrim(sprintf('%d ',var(X)))