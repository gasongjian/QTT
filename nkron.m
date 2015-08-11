function  C=nkron(A,B,varargin)
%NKRON  Kronecker product of two or more tensor
%  C=NKRON(A,B[,AN]);
%  There must be an equal ndims of A and B.
%
%  Example:
%    a=rand(5,5,5);
%    b=rand(6,6,6);
%    c=nkron(a,b);
%
%  see alse nkron,gtimes

%  JSong,3-Aug-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com


ndim=ndims(A);
d=nargin;

if d==2
    if ndim<=2
        C=kron(A,B);
    else
        size_a=size(A);
        size_b=size(B);
        C = kron(A(:),B(:));
        C = reshape(C,[size_b size_a]);
        C = permute(C,reshape([1:ndim;ndim+1:2*ndim],1,2*ndim));
        C = reshape(C, size_b.*size_a);
    end
    return
end


if d>2
    C=nkron(A,B);
    for i=1:d-2
        C=nkron(C,varargin{i});
    end
    return
end

