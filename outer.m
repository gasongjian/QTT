function B=outer(varargin)
%OUTER  outer product of two or more tensor
%  B=outer(A1,A2[,AN]);
%
%  Example:
%    a=rand(10,1);
%    b=rand(20,1);
%    c=rand(5,6);
%    B1=outer(a,b);
%    isequal(B1,a*b');
%    B2=outer(a,b,c);
%
%  see alse nkron,gtimes

%  JSong,3-Aug-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com


%%
if (nargin==1)
    B=varargin{1};
    return
end


%%
if nargin==2
    A1=varargin{1};
    A2=varargin{2};
    s1=size(A1);if s1(2)==1,s1=s1(1);end
    s2=size(A2);if s2(2)==1,s2=s2(1);end
    B=kron(A2(:),A1(:));
    B=reshape(B,[s1,s2]);
    return
end
%%
if (nargin>2)
    d=nargin;
    B=varargin{1};
    for i=2:d
        B=outer(B,varargin{i});
    end
    return
end

