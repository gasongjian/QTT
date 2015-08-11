function [ltcore,arg]=gqtt(lt,ltscale,ltchop,extype)
%GQTT  General QTT decomposition function(see also gqtt2)
%
%  -----------------------------------------------------------------------
%  [ltcore,arg]=gqtt(lt,ltscale,ltchop,extype);
%  lt: layer_tensor or array
%  ltscale: scale matrix, the subscale of all QTT core. If it dose not match 
%  the scale of lt,lt will be extended by extype.  
%                ----------------------------
%                    1      2   ...    l
%                1   n^1_1  .   ...   n^1_l
%                2   n^2_1  .   ...   n^2_l
%                .   ...
%                .   ...
%                d   n^d_1  .   ...   n^d_l
%               ----------------------------
%
%  ltchop£º chop calue.
%   If chop by QTT-rank£¬then  ltchop = r, and length(r)=d+1
%   If chop by norm, then ltchop=epss,and ||lt-ltcore||\leq epss*||lt||.
%
%  extype£ºextend method
%   run ltextend function ,support 'sym' and 'zpd'.
%
%  ltcore: cell,ltcore{i}:= the ith QTT core
%  arg:  record some related parameters
%  -----------------------------------------------------------------------
%  [ltcore]=gqtt(lt,ltscale);
%   ltscale: layer_tensor,the second QTT core. Meet 
%             lt=lkron(ltcore{1},ltscale).
%
%   ltcore: ltcore{2}=ltscale; 
%
%
%  -----------------------------------------------------------------------
%  Example:    
%    x=rand(6^5,1);y=2*x+rand(6^5,1)*0.1;
%    A=[x';y'];
%    A=layer_tensor(A(:),[2;1],[6^5]);
%    lt=gqtt(A,[6;6;6;6;6],1e-8,'sym');
%    lt1=gqtt(A,lkron(lt{3},lt{4},lt{5}));
%
%  see alse gqtt2,qtt

%  JSong,3-Aug-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com




%% convert to layer_tensor
if isa(lt,'double')
    if isvector(lt)
        lt=layer_tensor(lt,[1;1],numel(lt));
    else
        lt=layer_tensor(lt(:),[1;1],(size(lt))');
    end
end

oldscale=lt.scale;
r0=lt.size;
l=numel(oldscale);
d=size(ltscale,1);


%% the second QTT core known
if (nargin==2)&&(isa(ltscale,'layer_tensor'))
    ltcore=cell(2,1);
    ltcore{2}=ltscale;
    scale2=ltscale.scale;
    r2=ltscale.size;
    if numel(scale2)~=l
        disp('Invalid lt2!');
        return
    end
    scale1=oldscale./scale2;
    if sum(rem(scale1,1))~=0
        disp('Invalid lt2!')
        return
    end
    index_r=[scale2';scale1'];
    lt=reshape(lt.dat,[r0(1),(index_r(:))',r0(2)]);
    index=reshape([1:2*l+2]',[2,l+1]);
    index=index';
    index=(index(:))';
    lt=permute(lt,index);
    lt=reshape(lt,[r0(1)*prod(scale1(:)),r0(2)*prod(scale2(:))]);
    ltscale=reshape(ltscale.dat,[r2(1),r2(2)*prod(scale2(:))]);
    core=lt/ltscale;
    core=layer_tensor(core(:),[r0(1);r2(1)],scale1);
    ltcore{1}=core;
    arg=[];
    return
end
    

if nargin==2
    ltchop=1e-14;
    extype='sym';
elseif nargin==3
    extype='sym';
end



%% chop type and chop value®é¢˜
if (length(ltchop)==1)&&(ltchop<1)
    chop_type='epss';
    ltchop=ltchop/sqrt(d-1);
elseif (length(ltchop)==d+1)
    chop_type='r';
else
    error('ltchop');
end





%% extend 
newscale=prod(ltscale,1);
if prod(newscale(:))~=prod(oldscale(:))
    lt=ltextend(lt,newscale,extype);
end


%% main
ltcore=cell(d,1);
r=zeros(d+1,1);r(1)=r0(1);r(d+1)=r0(2);
for i=1:d-1
r0=lt.size;    
ltscale1=[prod(ltscale(1:d-i,:),1);ltscale(d-i+1,:)];
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
v=layer_tensor(v(:),[r1;r0(2)],(ltscale1(2,:))');
ltcore{d-i+1}=v;

s=s(1:r1); lt=lt(:,1:r1)*diag(s);
lt=reshape(lt,[prod(ltscale1(1,:),2),r(1),r1]);
lt=permute(lt,[2,1,3]);
lt=layer_tensor(lt(:),[r0(1);r1],(ltscale1(1,:))');
end
ltcore{1}=lt;
arg=struct;
arg.d=d;
arg.r=r;
arg.oldscale=oldscale;
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

