function y=toeplitz_qtt(X,epss1,epss2)
% Toeplitz 张量的快速QTT分解,可用于构造Toeplitz矩阵和k重Toeplitz矩阵.
% 参数X是一个张量,张量的阶数决定了构造的重数.
% 因为程序里有X的QTT分解和构造后的round_qtt,所以函数可以自定义提供两截断参数
%                 y=toeplitz_qtt(X,L,epss1,epss2);
% 而且epss1 用于X的QTT分解，epss2用于round_qtt，缺省都是1e-14
%
%  >- Toeplitz矩阵构造：
%     % X: 2^d*2 的向量
%     X=[1:32]';
%     y=toeplitz_qtt(X,L);
%   ------------------
%  >- k重toeplitz张量构造：
%     % X: k阶张量，且大小为：[L*2^{d_k}, ..., L*2^{d_2},L*2^{d_1}]
%     % X里面注意一下填充的问题
%     X=[[1:32]',[2:33]',[3:34]',[4:35]'];
%     y=toeplitz_qtt(X,2);
%     y1=full_qtt(y);
%
%
%   更多细节请参考论文：
%  see also hankel_qtt

%  JSong,16-Mar-2016; Hong-ming Lin
%  Last Revision: 21-Apr-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com


if nargin==1
    epss1=1e-14;
    epss2=1e-14;
elseif nargin==2
    epss2=epss1;
end
%% 核心张量构造
G=cell(2,2);
a=zeros(2,2,2);a([3;5;8])=1;
G{1,1}=a;
a=zeros(2,2,2);a(7)=1;
G{1,2}=a;
a=zeros(2,2,2);a(2)=1;
G{2,1}=a;
a=zeros(2,2,2);a([1;6;4])=1;
G{2,2}=a;
G=layer_tensor(G);

J=cell(1,2);
for i=1:2
    a=zeros([1,1,2]);
    a(i)=1;
    J{1,i}=a;
end
J=layer_tensor(J);

%% Toeplitz矩阵构造
if isvector(X)
    X=X(:);
    n=length(X)/2;
    d=log2(n);
    X=lqtt(X,ones(d+1,1)*2,epss1);
    types=[3;1];
    y=cell(d,1);
    % 这里将前两个核合并了，是因为第一个核的子模数已经退化成1.
    y{1}=lkron(lktimes(J,X{1},types),lktimes(G,X{2},types));
    for i=2:d-1
        y{i}=lktimes(G,X{i+1},types);
    end
    y{d}=lktimes(G(:,2),X{d+1},types);
    y=round_qtt(y,epss2);
    return
end


%% 块状或者k重构造
L=2;
s=size(X);s=s(:);s=s(end:-1:1);
k=length(s);
n=s./L;
d=log2(n);
subsizes=ones(sum(d)+k,1)*2;
ind=cumsum([0;d(1:k-1)]+1);% ind=[1,d_1+2,d_1+d_2+3
subsizes(ind)=L;
X=lqtt(X(:),subsizes,epss1); %共d_1+d_2+...+d_k+k个核
types=[L+1;1];
y=cell(sum(d)+k,1);
ind=[ind;sum(d)+k+1];
for i=1:sum(d)+k
    if ismember(i,ind)
        y{i}=lktimes(J,X{i},types);
    elseif ismember(i,ind-1)
        y{i}=lktimes(G(:,1),X{i},types);
    else
        y{i}=lktimes(G,X{i},types);
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






