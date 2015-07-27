function B=outer(varargin)




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

