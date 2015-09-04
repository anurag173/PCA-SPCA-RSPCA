% Anurag Prabhakar, Kamlesh Bharodiya - EE609A
% 
R=randn(20,20); % initializating with random data matrix
[U,S,V]=svds(R,3); %SVD decomposition
A = U(:,1)*V(:,1)'; 

E0 = rand(20);
E = 1*abs(E0>0.9);

X = A + E;
lambda = 1;
tic
lambda = 0.25;
% CVX program
cvx_begin
    variable L(20,20);
    variable S(20,20);
    variable W1(20,20);
    variable W2(20,20);
    variable Y(40,40) symmetric;
    Y == semidefinite(40);
    minimize(.5*trace(W1)+0.5*trace(W2)+lambda*sum(sum(abs(S))));
    subject to 
        L + S >= X-1e-5;
        L + S <= X + 1e-5;
        Y == [W1, L';L W2];
cvx_end
toc
disp('$\|S-E\|_\infty$:')
norm(S-E,'inf')
disp('\|A-L\|')
norm(A-L)