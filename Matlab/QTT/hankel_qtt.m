function y=hankel_qtt(X,L,varargin)
% Hankel 张量的快速QTT分解,可用于构造任意L阶Hankel张量和k重Hankel张量.
% 参数X是一个张量,张量的阶数决定了构造的重数,参数L时构造的Hankel的阶数.
% 因为程序里有X的QTT分解和构造后的round_qtt,所以函数可以自定义提供两截断参数
%                 y=hankel_qtt(X,L,[epss1;epss2]);
% 而且epss1 用于X的QTT分解，epss2用于round_qtt，缺省都是1e-14
%
%  >- Hankel 张量构造：
%     % X: 2^d*L 的向量
%     X=[1:32]';
%     y=hankel_qtt(X,L);
%   ------------------
%  >- k重Hankel张量构造：
%     % X: k阶张量，且大小为：[L*2^{d_k}, ..., L*2^{d_2},L*2^{d_1}]
%     % X里面注意一下填充的问题
%     X=[[1:32]',[2:33]',[3:34]',[4:35]'];
%     y=hankel_qtt(X,2);
%     y1=double(full_qtt(y));
%
%  
%   更多细节请参考论文：
%  see also toeplitz_qtt

%  JSong,16-Mar-2016; Lianyue-Zhang
%  Last Revision: 24-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com



%% 初始化
% epss1 用于X的QTT分解.epss2用于round_qtt的参数
if nargin==2
    epss1=1e-14;
    epss2=1e-14;
else
    epss=varargin{1};
    epss1=epss(1);
    epss2=epss(2);
end

%% 生成L阶Hankel张量
% 虽然该段程序可以合并在块状hankel里,但考虑到性能和可读性还是单独列出来.
if isvector(X)
    X=X(:);
    n=length(X)/L;
    d=log2(n);
    [J,T]=hankel_core(L);
    X=lqtt(X,[L;ones(d,1)*2],epss1); 
    types=[L+1;1];
    y=cell(d,1);
    % 这里将前两个核合并了，是因为第一个核的子模数已经退化成1.
    y{1}=lkron(lktimes(J,X{1},types),lktimes(T,X{2},types));
    for i=2:d-1
        y{i}=lktimes(T,X{i+1},types);
    end
    y{d}=lktimes(T(:,1),X{d+1},types);
    y=round_qtt(y,epss2); 
    return
end

%% 生成L阶k重Hankel张量(k=2时即块状Hankel矩阵).
s=size(X);s=s(:);s=s(end:-1:1);
k=length(s);
n=s./L;
d=log2(n);
subsizes=ones(sum(d)+k,1)*2;
ind=cumsum([0;d(1:k-1)]+1);% ind=[1,d_1+2,d_1+d_2+3
subsizes(ind)=L;
X=lqtt(X(:),subsizes,epss1); %共d_1+d_2+...+d_k+k个核
[J,T]=hankel_core(L);
types=[L+1;1];
y=cell(sum(d)+k,1);
ind=[ind;sum(d)+k+1];
for i=1:sum(d)+k
    if ismember(i,ind)
        y{i}=lktimes(J,X{i},types);
    elseif ismember(i,ind-1)
        y{i}=lktimes(T(:,1),X{i},types);
    else
        y{i}=lktimes(T,X{i},types);
    end
end

%从右到左合并部分QTT核.
ind1=ind(end-1:-1:1);
for i=1:k
    ii=ind1(i); 
    y{ii}=lkron(y{ii},y{ii+1});
    y(ii+1)=[];
end
y=round_qtt(y,epss2);   
end



%% ==============================================================
function [J,T]=hankel_core(L)
% 该函数用于生成高维构造张量G的QTT核.
% G=J \bowtie T \bowtie ...\bowtie T(:,1);

T=cell(L,L);
for i=1:L
    for j=1:L
        T{i,j}=core_h(L,1,i-j/2+1/2);
    end
end
T=layer_tensor(T);

J=cell(1,L);
for i=1:L
    a=zeros([ones(1,L),L]);
    a(i)=1;
    J{1,i}=a;
end
J=layer_tensor(J);
end




%% ===============================================================
function a=core_h(L,d,k)
% 生成基本l阶 Hankel张量构造子 H^d_k的子函数
%                            |  1, i_1+\ldots+i_l-j=(k-1)*2^d +l-1
%    H^d_k(i_1,\ldots,i_l,j)=|
%                            |_ 0, 其它
% 检测a是否是零张量: ~any(a(:))

a=zeros(ones(1,L+1)*2^d);
idx=[];
for j=1:2^d
    y=traverse(L,2^d,j+(k-1)*2^d+L-1);
    m=size(y,1);
    idx=[idx;y,ones(m,1)*j];
end
if isempty(idx)
    return
end
s=zeros(L+1,1);
for i=1:L+1
    s(i)=2^(i-1);
end
idx=idx*s-2^(L+1)+2;
a(idx)=ones(length(idx),1);
end




%% ================================================================
function y=traverse(L,n,k)
% 遍历所有可能：x_1+x_2+...+x_l=k,其中每个指标x_k的取值范围为1到n.
% 返回的y是一个矩阵，且每一行都是一种可能.
if (L==2)
    y=[];
    for i=1:n
        for j=1:n
            if i+j==k
                y=[y;i,j];
            end
        end
    end
elseif (L>2) 
    y=[];
    for i=1:n
        y1=traverse(L-1,n,k-i);
        m=size(y1,1);
        if m>0          
        y=[y;ones(m,1)*i,y1];
        end
    end
end
end





