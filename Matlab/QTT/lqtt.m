function [ltcore,arg]=lqtt(lt,subsizes,ltchop)
%lqtt_old::General QTT decomposition function(see also lqtt_old2)
%
%  -----------------------------------------------------------------------
%  [ltcore,arg]=lqtt_old(lt,subsizes,ltchop,extype);
%  lt: layer_tensor or array
%  subsizes: subsize matrix, the subsize of all QTT core. If it dose not match
%  the size of lt,lt will be extended by extype.
%                ----------------------------
%                    1      2   ...    l
%                1   n^1_1  .   ...   n^1_l
%                2   n^2_1  .   ...   n^2_l
%    subsizes =   .   ...
%                .   ...
%                d   n^d_1  .   ...   n^d_l
%               ----------------------------
%
%  ltchop: chop calue.
%   If chop by QTT-rank,then  ltchop = r, and length(r)=d+1
%   If chop by norm, then ltchop=epss,and ||lt-ltcore||\leq epss*||lt||.
%
%  extype: extend method
%   run ltextend function ,support 'sym' and 'zpd'.
%
%  ltcore: cell,ltcore{i}:= the ith QTT core
%  arg:  record some related parameters
%  -----------------------------------------------------------------------
%  [ltcore]=lqtt_old(lt,subsizes);
%   subsizes: layer_tensor,the second QTT core. Meet
%             lt=lkron(ltcore{1},subsizes).
%
%   ltcore: ltcore{2}=subsizes;
%
%
%  -----------------------------------------------------------------------
%  Example:
%    x=rand(6^5,1);y=2*x+rand(6^5,1)*0.1;
%    A=[x';y'];
%    A=layer_tensor(A(:),[2;1],[6^5]);
%    lt=lqtt_old(A,[6;6;6;6;6],1e-8,'sym');
%    lt1=lqtt_old(A,lkron(lt{3},lt{4},lt{5}));
%
%  see alse lqtt_old2,qtt

%  JSong,3-Aug-2015
%  Last Revision: 15-Mar-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com




%% convert to layer_tensor
if isa(lt,'double')
    if isvector(lt)
        lt=layer_tensor(lt(:));
    else
        lt=layer_tensor(lt);
    end
end

if nargin==2
    ltchop=1e-14;
end

%% get basic info
r0=size(lt);
l=ndims(lt);
d=size(subsizes,1);

%% chop type and chop value
if (length(ltchop)==1)&&(ltchop<1)
    chop_type='epss';
    ltchop=ltchop/sqrt(d-1);
elseif (length(ltchop)==d+1)
    chop_type='r';
else
    error('ltchop');
end

%% 
ltcore=cell(d,1);
r=zeros(d+1,1);r(1)=r0(1);r(d+1)=r0(2);
elems=0;%记录核中元素的总个数

%% main
for i=1:d-1
    r0=size(lt);
    ltscale1=[prod(subsizes(1:d-i,:),1);subsizes(d-i+1,:)];
    index=ltscale1([2,1],:);index=(index(:))';
    lt=reshape(lt.dat,[r(1),index,r(d-i+2)]);
    index=[3:2:2*l+1,1,2:2:2*l+2];
    lt=permute(lt,index);
    lt=reshape(lt,[prod(ltscale1(1,:),2)*r(1),prod(ltscale1(2,:),2)*r(d-i+2)]);
    
    % svd
    [lt,s,v]=svd(lt,'econ');
    s=diag(s);
    switch chop_type
        case {'epss'}
            r1=my_chop2(s,ltchop*norm(s));
        case {'r'}
            r1=min(length(s),ltchop(i+1));
    end
    r(d-i+1)=r1;
    v=v(:,1:r1);v=v';
    elems=elems+numel(v);
    v=layer_tensor(v(:),[r1;r0(2)],(ltscale1(2,:))');
    ltcore{d-i+1}=v;
    
    
    s=s(1:r1); lt=lt(:,1:r1)*diag(s);
    lt=reshape(lt,[prod(ltscale1(1,:),2),r(1),r1]);
    lt=permute(lt,[2,1,3]);
    lt=layer_tensor(lt(:),[r0(1);r1],(ltscale1(1,:))');
end
ltcore{1}=lt;
elems=elems+length(lt.dat);
if nargout>1
    s=prod(subsizes,2);
    a=sum(s(2:d-1));
    b=s(1)+s(d);
    erank=(sqrt(b^2+4*a*elems)-b)/2/a;
    arg=struct;
    arg.elems=elems;
    arg.erank=erank;
    arg.d=d;
    arg.r=r;
end
end





function [r] = my_chop2(sv,eps)
% from TT-toolbox

if (norm(sv)==0)
    r = 1;
    return;
end;
% Check for zero tolerance
if ( eps <= 0 )
    r = numel(sv);
    return
end

sv0=cumsum(sv(end:-1:1).^2);
ff=find(sv0<eps.^2);
if (isempty(ff) )
    r=numel(sv);
else
    r=numel(sv)-ff(end);
end
return
end

