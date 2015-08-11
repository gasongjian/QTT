function lt=louter(varargin)
%LOUTER  layer outer product of N layer_tensor.
%
%  louter(lt1,lt2[,ltN]);
%  lt1 and ltN are layer_tensor. 
%
%
%  Example:
%    lt1=layer_tensor(rand(2,3,4,5));
%    lt2=layer_tensor(rand(5,4,3,2));
%    lt=louter(lt1,lt2);
%    lt.size
%    lt.scale
%
%  see also layer_tensor, lkron

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 


%% one argument
if (nargin==1)&&isa(varargin{1},'layer_tensor')
    lt=varargin{1};
    return
end

%% normal
if nargin==2
    lt1=varargin{1};
    lt2=varargin{2};
    r1=lt1.size; c1=lt1.dat; s1=lt1.scale;clear lt1
    r2=lt2.size; c2=lt2.dat; s2=lt2.scale;clear lt2
    c1=reshape(c1,[numel(c1)/r1(2),r1(2)]);
    c2=reshape(c2,[r1(2),numel(c2)/r1(2)]);
    c=c1*c2;
    lt=layer_tensor;
    lt.dat=c(:);
    lt.size=[r1(1);r2(2)];
    lt.scale=[s1;s2];
    return
end


%% 
if (nargin>2)
    d=nargin;
    lt=varargin{1};
    for i=2:d
        lt=lkron(lt,varargin{i});
    end
    return
end












