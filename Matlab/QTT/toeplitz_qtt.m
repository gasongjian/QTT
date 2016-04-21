function y=toeplitz_qtt(X,epss1,epss2)
% Toeplitz �����Ŀ���QTT�ֽ�,�����ڹ���Toeplitz�����k��Toeplitz����.
% ����X��һ������,�����Ľ��������˹��������.
% ��Ϊ��������X��QTT�ֽ�͹�����round_qtt,���Ժ��������Զ����ṩ���ضϲ���
%                 y=toeplitz_qtt(X,L,epss1,epss2);
% ����epss1 ����X��QTT�ֽ⣬epss2����round_qtt��ȱʡ����1e-14
%
%  >- Toeplitz�����죺
%     % X: 2^d*2 ������
%     X=[1:32]';
%     y=toeplitz_qtt(X,L);
%   ------------------
%  >- k��toeplitz�������죺
%     % X: k���������Ҵ�СΪ��[L*2^{d_k}, ..., L*2^{d_2},L*2^{d_1}]
%     % X����ע��һ����������
%     X=[[1:32]',[2:33]',[3:34]',[4:35]'];
%     y=toeplitz_qtt(X,2);
%     y1=full_qtt(y);
%
%
%   ����ϸ����ο����ģ�
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
%% ������������
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

%% Toeplitz������
if isvector(X)
    X=X(:);
    n=length(X)/2;
    d=log2(n);
    X=lqtt(X,ones(d+1,1)*2,epss1);
    types=[3;1];
    y=cell(d,1);
    % ���ｫǰ�����˺ϲ��ˣ�����Ϊ��һ���˵���ģ���Ѿ��˻���1.
    y{1}=lkron(lktimes(J,X{1},types),lktimes(G,X{2},types));
    for i=2:d-1
        y{i}=lktimes(G,X{i+1},types);
    end
    y{d}=lktimes(G(:,2),X{d+1},types);
    y=round_qtt(y,epss2);
    return
end


%% ��״����k�ع���
L=2;
s=size(X);s=s(:);s=s(end:-1:1);
k=length(s);
n=s./L;
d=log2(n);
subsizes=ones(sum(d)+k,1)*2;
ind=cumsum([0;d(1:k-1)]+1);% ind=[1,d_1+2,d_1+d_2+3
subsizes(ind)=L;
X=lqtt(X(:),subsizes,epss1); %��d_1+d_2+...+d_k+k����
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

%���ҵ���ϲ�����QTT��.
ind1=ind(end-1:-1:1);
for i=1:k
    ii=ind1(i);
    y{ii}=lkron(y{ii},y{ii+1});
    y(ii+1)=[];
end
y=round_qtt(y,epss2);
end






