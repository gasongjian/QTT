function t=layer_tensor(varargin);

if (nargin == 0)
    t.size = [];
    t.scale=[];
    t.dat=[];
    t = class(t,'layer_tensor');
    return;
end

if (nargin==1)&&(ndims(varargin{1})>=3)
    A=varargin{1};
    t=layer_tensor;   
    s=size(A);
    r=[s(1);s(end)];
    t.size=r;
    t.dat=A(:);
    t.scale=s(2:end-1)';
    return
end

if (nargin==3)&&(isvector(varargin{1}))&&(length(varargin{2})==2)
    t=layer_tensor;
    dat=varargin{1};   
    r=varargin{2}; 
    scale=varargin{3};
     t.dat=dat(:);
     t.size=r(:);
    t.scale=scale(:);
    return
end
    