function tto=qtt(A,varargin)
% FUNCTION  tto=QTT(A,scale,cut_value,exmethod)
% 带延拓的多维数组 qtt_svd 算法,A是一个多维数组, 支持向量、矩阵等
%
% 输入参数：
% A     :需要处理的多维数组，数组维数为l
%
% scale : QTT核子张量的大小(如果比原数组会自动延拓)
%     ----------------------------
%         1      2   ...    l
%     1   n^1_1  .   ...   n^1_l
%     2   n^2_1  .   ...   n^2_l
%     .   ...
%     .   ...
%     d   n^d_1  .   ...   n^d_l
%     ----------------------------
%     简单点可直接令scale=q,则除下第一个核，其他核的子张量大小都是q*q*q...
%
% cut_value:截断秩/截断范数
%       如果按秩截断，则 cut_value=r,r的长度等于d+1
%       如果按范数截断，则cut_value=epss
%
% exmethod:延拓方法
%       目前只支持对称延拓，及exmethod='sym'; 
%
% 输出参数：函数输出一个结构体，记录所有相关信息,不排除后续会转化成专门的一个类
%  tto.core: 记录所有的QTT核
%
%
%
%   example:
%         A=mat2gray(imread(I));
%         t=qtt(A);%其他参数都缺省
%
%  @J.Song @2015.07.12 @1.1
%
%  see also core_qtt iqtt

if nargin==1
    scale=2;
    cut_value=1e-14;
    exmethod='sym';
elseif nargin==2
    scale=varargin{1};
    cut_value=1e-14;
    exmethod='sym';
elseif nargin==3
    scale=varargin{1};
    cut_value=varargin{2};
    exmethod='sym';
end

% 获取数组基本信息
ndim=ndims(A);
oldsize=size(A);
if isvector(A)
    A=A(:);
    ndim=1;
    oldsize=size(A,1);
end

if any(oldsize==1)
    error('Please check the array.');
end

% 处理尺度问题
if length(scale)<=1
    if isempty(scale)
        q=2;
    else
    q=scale;
    end
    
    d=min(floor(log(oldsize)*(1+eps)/log(q)));
    last_size=fix(oldsize*(1-eps)/q^(d-1))+1;last_size=last_size(:);
    scale=[last_size';q*ones(d-1,ndim)];
elseif (size(scale,2)==ndim)&&(size(scale,1)>1)&&(all(prod(scale)>=oldsize))
    d=size(scale,1);
    %last_size=scale(1,:);
else   
    error('scale');
end


% 处理截断问题
if (length(cut_value)==1)&&(cut_value<1)
    cut_method='epss';
    epss=cut_value;
    ep=epss/sqrt(d-1);
elseif (length(cut_value)==d+1)
    cut_method='r';
    cut_r=cut_value;
elseif isempty(vut_value)
     cut_method='epss';
    epss=1e-14;
    ep=epss/sqrt(d-1);
else
    error('cut_value');
end

    


%% 延拓
newsize=prod(scale);
extension=0;
if ~isequal(oldsize,newsize)
    extension=1;
    switch exmethod
        case 'sym'
            index=cell(ndim,1);
            for j=1:ndim
                temp=1:oldsize(j);
                temp=[temp temp(end:-1:2*end-newsize(j)+1)];
                index{j}=temp;
            end
            temp=sprintf('index{%d},',[1:ndim]);
            temp(end)=[];
            temp=['A=A(',temp,');'];
            eval(temp)
            
    end
end
    
    
%% 对数组预处理
scale=scale(end:-1:1,:);
A = reshape(A, (scale(:))'); % 转化为ndim*d 的张量
if ndim>1 
prm=1:ndim*d; prm=reshape(prm,[d,ndim]); prm=prm';
prm=prm(:); % Transposed permutation
A=permute(A,prm);
n=prod(scale,2); %新的张量大小,列向量
A=reshape(A,n');
end
     


%% SVD折叠

% tt_svd 算法, 相对于原版的作了一些修正
% A 是待分解的张量
% n 是张量的模数
% core 是所有的TT核, 存储为单个列向量，通过ps来索引
% ps 索引第k个TT核用的

d = numel(n);
r = ones(d+1,1);
core=[];
c=A;clear A
%%==============【 modification】======================================

for i=1:d-1
    % m=n(i)*r(i); c=reshape(c,[m,numel(c)/m]);
    % ===============【part one】=====================
    m=n(i)*r(i); c=reshape(c,[r(i),n(i),numel(c)/m]);
    c=permute(c,[2 1 3]);
    c=reshape(c,[m,numel(c)/m]);
    %=================================================
    [u,s,v]=svd(c,'econ');
    %[u,s,v]=psvd(c);
    s=diag(s); 
    switch cut_method
        case {'epss'}
          r1=my_chop2(s,ep*norm(s));
        case {'r'}
          r1=min(length(s),cut_r(i+1));
    end
    u=u(:,1:r1); s=s(1:r1);
    r(i+1)=r1;
    
    u=reshape(u,[n(i),r(i),r1]);
    u=permute(u,[3,1,2]);
    core=[u(:);core];
    % ================================================
    %core(pos:pos+r(i)*n(i)*r(i+1)-1)=u(:);
    v=v(:,1:r1);
    v=v*diag(s); c=v';
    %pos=pos+r(i)*n(i)*r(i+1);
end
%%==================【end  modification】================================
c=reshape(c,[r(d),n(d),1]);
c=permute(c,[3,2,1]);
core=[c(:);core];
r=r(end:-1:1);n=n(end:-1:1);
ps=cumsum([1;n.*r(1:d).*r(2:d+1)]);
tto=struct; % 记录 QTT格式
tto.d=d;
tto.n=n;
tto.r=r;
tto.ps=ps;
tto.core=core;
tto.oldsize=oldsize;
tto.scale=scale(end:-1:1,:);
tto.ndim=ndim;
tto.isextension=extension;
tto.ex_method=exmethod;


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









