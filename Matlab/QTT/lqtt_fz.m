function [ltcore]=lqtt_fz(lts,subsizes,ltchop,varargin)
% 分治算法策略，还有一些细节问题待修复. 图像处理慎用!!
%
% LQTT::The QTT Decomposition Function of Layer Tensor 
%
%  -----------------------------------------------------------------------
%  ltcore=lqtt(lt,subsizes,ltchop);
%  lts: layer_tensor or tensor array
%  subsizes: subsize matrix, the subsize of all QTT core. Please make sure 
%          prod(subsizes(:,2))=lts.subsize. 
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
if isa(lts,'double')
    if isvector(lts)
        lts=layer_tensor(lts(:));
    else
        lts=layer_tensor(lts);
    end
end

%% Get basic info
r0=size(lts);
subr=subsize(lts);
%subsize=lts.subsize;
l=ndims(lts);
d=size(subsizes,1);

% record the state of function,'l' represent left node,'r' represent right node
if nargin==3
    state=''; 
else
    state=varargin{1};
end

%% stop condition
if d==1
    ltcore{1}=lts;
    return
end

%%  one step decomposition

fprintf('=====开始节点为%s 的分解:=======\n',state);
subsizes1=subsizes(1:round(d/2),:);
subsizes2=subsizes(round(d/2)+1:end,:);
ltscale1=[prod(subsizes1,1);prod(subsizes2,1)];
index=ltscale1([2,1],:);index=(index(:))';
lts=reshape(lts.dat,[r0(1),index,r0(2)]);
lts=permute(lts,[1:2:2*l+1,2:2:2*l+2]);
lts=reshape(lts,[prod(ltscale1(1,:),2)*r0(1),prod(ltscale1(2,:),2)*r0(2)]);
fprintf('1、将[%d,%d,%d,%d]的分成张量折叠成%d *%d 的矩阵\n',[r0(1),subr,r0(2),size(lts,1),size(lts,2)]);

 % svd
if ~isempty(state) && state(1)=='r'
    figure
    imagesc(lts'*lts);
end
[lts,s,lt2]=svd(lts,'econ');s=diag(s);

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
fprintf('SVD分解：第二个核大小为%d *%d.\n',size(lt2,1),size(lt2,2))
lt2=layer_tensor(lt2(:),[r1;r0(2)],(ltscale1(2,:))');

s=s(1:r1); lts=lts(:,1:r1)*diag(s);
lts=permute(lts,[3,1,2]);
fprintf('SVD分解：第一个核大小为%d *%d.\n',size(lts,1),size(lts,2))
fprintf('对应的能量为：\n')
lts=layer_tensor(lts(:),[r0(1);r1],(ltscale1(1,:))');
nlp=ltfold(lts,'l');
nlp=sum(nlp.^2,1);
%nlp=nlp/sum(nlp);
disp(nlp(1:min(6,length(nlp))));
state1=[state,'l'];
state2=[state,'r'];
ltcore=lqtt_fz(lts,subsizes1,ltchop1,state1);
ltcore2=lqtt_fz(lt2,subsizes2,ltchop2,state2);
ltcore=[ltcore;ltcore2];
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




