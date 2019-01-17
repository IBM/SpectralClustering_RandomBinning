function K = kernel(X,x,sigma)
% K=kernel(X,x)
%
% computes the pairwise squared kernel matrix between any column vectors 
% in X and in x
%
% INPUT:
%
% X     dxN matrix consisting of N column vectors
% x     dxn matrix consisting of n column vectors
%
% OUTPUT:
%
% K  Nxn matrix 
%
% Example:
% K=kernel(X,X);
% is equivalent to
% K=kernel(X);
%
% Authur: Lingfei Wu
% Data: 08/23/2017

[D,N] = size(X);
if(nargin>=2)
    [d,n] = size(x);
    if(D~=d)
        error('Both sets of vectors must have same dimensionality!\n');
    end;
    X2 = sum(X.^2,1);
    x2 = sum(x.^2,1);
    dist = bsxfun(@plus,X2.',bsxfun(@plus,x2,-2*X.'*x));
else
    s=sum(X.^2,1);
    dist=bsxfun(@plus,s',bsxfun(@plus,s,-2*X.'*X));
end;
K = exp(-dist/(2*sigma^2));
