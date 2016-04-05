function [ltcore]=lqtt(lt,subsizes,ltchop,varargin)
% LQTT::The QTT Decomposition Function of Layer Tensor 
%
%  -----------------------------------------------------------------------
%  ltcore=lqtt(lt,subsizes,ltchop);
%  lt: layer_tensor or tensor array
%  subsizes: subsize matrix, the subsize of all QTT core. Please make sure 
%          prod(subsizes(:,2))=lt.subsize. 
%  Otherwise you can use function ltextend.  
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
%   %If chop by QTT-rank,then  ltchop = r, and length(r)=d+1
%   If chop by forbenius norm, then ltchop=epss,and ||lt-ltcore||\leq epss*||lt||.
%
%
%  ltcore: cell,ltcore{i}:= the ith QTT core
%  -----------------------------------------------------------------------
%  Example:    
%
%    %ex1:
%    x=rand(6^5,1);y=2*x+rand(6^5,1)*0.1;
%    A=[x';y'];
%    A=layer_tensor(A(:),[2;1],[6^5]);
%    %A=layer_tensor({x';y'});
%    lt=lqtt(A,[6;6;6;6;6],1e-8);
%    A1=full_qtt(lt);
%
%    %ex2
%    x=linspace(0,10,1024);x=x';
%    x=sin(x);
%    c=lqtt(x,ones(10,1)*2,1e-6);
%
%    %ex3
%    c=zeros(2^10,1);c(1)=2;c(2)=-1;
%    A=toeplitz(c,c);
%    B=lqtt(A,ones(10,2)*2,1e-6);
%    er=info_qtt(B,'erank');
%
%  see alse lqtt_old,full_qtt,info_qtt,

%  JSong,15-Mar-2016
%  Last Revision: 15-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com


%% In to layer_tensor
if isa(lt,'double')
    if isvector(lt)
        lt=layer_tensor(lt,[1;1],numel(lt));
    else
        lt=layer_tensor(lt(:),[1;1],(size(lt))');
    end
end


%% Get basic info
r0=lt.size;
l=numel(lt.subsize);
d=size(subsizes,1);

% record the state of function,'l' represent left node,'r' represent right node
if nargin==3
    state=''; 
else
    state=varargin{1};
end

%% stop condition
if d==1
    ltcore{1}=lt;
    return
end

%%  one step decomposition

subsizes1=subsizes(1:round(d/2),:);
subsizes2=subsizes(round(d/2)+1:end,:);
ltscale1=[prod(subsizes1,1);prod(subsizes2,1)];
index=ltscale1([2,1],:);index=(index(:))';
lt=reshape(lt.dat,[r0(1),index,r0(2)]);
index=[3:2:2*l+1,1,2:2:2*l+2];
lt=permute(lt,index);
lt=reshape(lt,[prod(ltscale1(1,:),2)*r0(1),prod(ltscale1(2,:),2)*r0(2)]);
 % svd
[lt,s,lt2]=svd(lt,'econ');s=diag(s);

%-----------------------------------------------------------------------
%r1=my_chop2(s,ltchop*norm(s));
if isempty(state)
    ltchop1=ltchop*norm(s)/ceil(log2(d));
    r1=my_chop2(s,ltchop1);
    ltchop2=ltchop;
    
elseif ~ismember('r',state)      
    r1=my_chop2(s,ltchop);
    ltchop1=ltchop;
    ltchop2=ltchop*5/norm(s);
else
    % maybe need modification
    %r1=rank(diag(s));
    r1=my_chop2(s,ltchop*norm(s));
    ltchop1=ltchop;
    ltchop2=ltchop;
end
%-----------------------------------------------------------------------


lt2=lt2(:,1:r1);lt2=lt2';
lt2=layer_tensor(lt2(:),[r1;r0(2)],(ltscale1(2,:))');

s=s(1:r1); lt=lt(:,1:r1)*diag(s);
lt=reshape(lt,[prod(ltscale1(1,:),2),r0(1),r1]);
lt=permute(lt,[2,1,3]);
lt=layer_tensor(lt(:),[r0(1);r1],(ltscale1(1,:))');
state1=[state,'l'];
state2=[state,'r'];
ltcore=[lqtt(lt,subsizes1,ltchop1,state1);lqtt(lt2,subsizes2,ltchop2,state2)];
end


%%
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




