function [ltcore,arg]=gqtt1(lt,ltscale,ltchop,extype)
%  分层张量的分解函数--循环方法(gqtt2用递归模式)
%
%  输入参数:
%  -------------------------------------------------
%  lt：输入的分层张量，同时也支持多元数组；
%  ltscale: 分解的尺度矩阵
%           QTT核子张量的大小(如果比原数组大会自动延拓)
%     ----------------------------
%         1      2   ...    l
%     1   n^1_1  .   ...   n^1_l
%     2   n^2_1  .   ...   n^2_l
%     .   ...
%     .   ...
%     d   n^d_1  .   ...   n^d_l
%     ----------------------------
%
%  ltchop： 截断值
%       如果按秩截断，则 ltchop=r,r的长度等于d+1
%       如果按范数截断，则ltchop=epss
%
%  extype：延拓方法
%        调用ltextend函数,目前支持'sym'和'zpd'
%
%  返回值:
%  ------------------------------------------------
%  ltcore：元胞数组，lt{i}代表第i个QTT核，每个核都以分层张量的形式存储
%     arg: 记录一些其他参数
%
%       example:
%       --------------------------------------------
%                x=rand(6^5,1);y=2*x+rand(6^5,1)*0.1;
%                A=[x';y'];
%                A=layer_tensor(A(:),[2;1],[6^5]);
%                lt=gqtt2(A,[6;6;6;6;6],1e-4,'sym');
%
%
%  @JSong @2015.08.03 @1.0
%  see also qtt,gqtt2
%




% convert to layer_tensor
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

% 处理截断问题
if (length(ltchop)==1)&&(ltchop<1)
    chop_type='epss';
    ltchop=ltchop/sqrt(d-1);
elseif (length(ltchop)==d+1)
    chop_type='r';
else
    error('ltchop');
end





%% 延拓
newscale=prod(ltscale,1);
if prod(newscale(:))~=prod(oldscale(:))
    lt=ltextend(lt,newscale,extype);
end


%% 分解
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

%% svd

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
% 来源于TT-toolbox

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

