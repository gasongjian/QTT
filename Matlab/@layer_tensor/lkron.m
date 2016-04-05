function lt=lkron(lt1,varargin)
%LTKRON  layer Kronecker operation of N layer_tensor.
%  
%
%  lkron(lt1[,lt2,...,ltN]);
%  lt1 and ltN are layer_tensor. 
%
%
%  Example:
%    lt1=layer_tensor(rand(2,3,4,5));
%    lt2=layer_tensor(rand(5,4,3,2));
%    lt=lkron(lt1,lt2);
%    lt.size
%    lt.subsize
%
%  see also layer_tensor, louter

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 


%% one layer_tensor
if (nargin==1)&&isa(lt1,'layer_tensor')
    lt=lt1;
    return
end


%%  two layer_tensors
if nargin==2
    %lt1=varargin{1};
    lt2=varargin{1};
    l=length(lt1.subsize);
    r1=lt1.size; c1=lt1.dat; s1=lt1.subsize;clear lt1
    r2=lt2.size; c2=lt2.dat; s2=lt2.subsize;clear lt2   
    c1=reshape(c1,[numel(c1)/r1(2),r1(2)]);
    c2=reshape(c2,[r1(2),numel(c2)/r1(2)]);
    c=c1*c2;
    c=reshape(c,[r1(1),s1',s2',r2(2)]);
    
    if l>1
        index=[l+2:2*l+1;2:l+1];
        index=[1;index(:);2*l+2];
        c=permute(c,index');
    else
        c=permute(c,[1,3,2,4]);
    end
    lt=layer_tensor;
    lt.dat=c(:);
    lt.size=[r1(1);r2(2)];
    lt.subsize=s1.*s2;
    
    return
end



%% more than two layer_tensors
if (nargin>2)
    d=nargin;
    lt=lt1;
    for i=1:d-1
        lt=lkron(lt,varargin{i});
    end
    return
end



end





