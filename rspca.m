X=rand(20,20); %    X: the given data matrix ( d x n ), 
               %    where d is the number of variables and n is the number of observations.
[d, n] = size(X); 
eps = 0.000001; %  a small positive number for the convergence check.
k = d/2; % the desired number of sparse principal components. 
w0 = ones(d, 1); % the preset initial direction.
%% outputs:
%    w: the first sparse principal component direction of X.
%    iter: the iteration times for computing W.
%% 
if k > d - 1
  warning('The sparsity should be specified as a number smaller than the data dimensionality.');
end

% Initialization (Step I)
w0 = w0 / norm(w0);
flag = 1;
iter = 0;
p = zeros(1,n);
tic
while flag==1
    iter = iter + 1;

% Step II
    w0_X = w0'*X;
    p(w0_X<0) = -1;
    p(w0_X>=0) = 1;
    w = X*p';

% Step III
    [ms, mi] = sort(abs(w), 'descend');
    ms(d+1) = 0;
    
    w_new = zeros(d,1);
    w_new(1:k) = ms(1:k) - ms(k+1);
    
    [~,mii] = sort(mi, 'ascend');
    w_new = w_new(mii);
    w_new = w_new.*sign(w);
    
    w = w_new / norm(w_new);

% Convergence check step (Step IV)
    if abs(w'*w0) <= 1-eps
        w0 = w;
    elseif sum(w'*X==0)>0
        if sum(sign(w')*X(:,w'*X==0)==0)>0
            dw = (rand(d, 1)-0.5)*eps;
            w0 = (w + dw) / norm(w + dw);
            flag = 1;
        else
            flag = 0;
        end
    else
        flag = 0;
    end
end
toc
 
iter