function y=hankel_qtt(X,L,varargin)
% Hankel �����Ŀ���QTT�ֽ�,�����ڹ�������L��Hankel������k��Hankel����.
% ����X��һ������,�����Ľ��������˹��������,����Lʱ�����Hankel�Ľ���.
% ��Ϊ��������X��QTT�ֽ�͹�����round_qtt,���Ժ��������Զ����ṩ���ضϲ���
%                 y=hankel_qtt(X,L,[epss1;epss2]);
% ����epss1 ����X��QTT�ֽ⣬epss2����round_qtt��ȱʡ����1e-14
%
%  >- Hankel �������죺
%     % X: 2^d*L ������
%     X=[1:32]';
%     y=hankel_qtt(X,L);
%   ------------------
%  >- k��Hankel�������죺
%     % X: k���������Ҵ�СΪ��[L*2^{d_k}, ..., L*2^{d_2},L*2^{d_1}]
%     % X����ע��һ����������
%     X=[[1:32]',[2:33]',[3:34]',[4:35]'];
%     y=hankel_qtt(X,2);
%     y1=double(full_qtt(y));
%
%  
%   ����ϸ����ο����ģ�
%  see also toeplitz_qtt

%  JSong,16-Mar-2016; Lianyue-Zhang
%  Last Revision: 24-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com



%% ��ʼ��
% epss1 ����X��QTT�ֽ�.epss2����round_qtt�Ĳ���
if nargin==2
    epss1=1e-14;
    epss2=1e-14;
else
    epss=varargin{1};
    epss1=epss(1);
    epss2=epss(2);
end

%% ����L��Hankel����
% ��Ȼ�öγ�����Ժϲ��ڿ�״hankel��,�����ǵ����ܺͿɶ��Ի��ǵ����г���.
if isvector(X)
    X=X(:);
    n=length(X)/L;
    d=log2(n);
    [J,T]=hankel_core(L);
    X=lqtt(X,[L;ones(d,1)*2],epss1); 
    types=[L+1;1];
    y=cell(d,1);
    % ���ｫǰ�����˺ϲ��ˣ�����Ϊ��һ���˵���ģ���Ѿ��˻���1.
    y{1}=lkron(lktimes(J,X{1},types),lktimes(T,X{2},types));
    for i=2:d-1
        y{i}=lktimes(T,X{i+1},types);
    end
    y{d}=lktimes(T(:,1),X{d+1},types);
    y=round_qtt(y,epss2); 
    return
end

%% ����L��k��Hankel����(k=2ʱ����״Hankel����).
s=size(X);s=s(:);s=s(end:-1:1);
k=length(s);
n=s./L;
d=log2(n);
subsizes=ones(sum(d)+k,1)*2;
ind=cumsum([0;d(1:k-1)]+1);% ind=[1,d_1+2,d_1+d_2+3
subsizes(ind)=L;
X=lqtt(X(:),subsizes,epss1); %��d_1+d_2+...+d_k+k����
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

%���ҵ���ϲ�����QTT��.
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
% �ú����������ɸ�ά��������G��QTT��.
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
% ���ɻ���l�� Hankel���������� H^d_k���Ӻ���
%                            |  1, i_1+\ldots+i_l-j=(k-1)*2^d +l-1
%    H^d_k(i_1,\ldots,i_l,j)=|
%                            |_ 0, ����
% ���a�Ƿ���������: ~any(a(:))

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
% �������п��ܣ�x_1+x_2+...+x_l=k,����ÿ��ָ��x_k��ȡֵ��ΧΪ1��n.
% ���ص�y��һ��������ÿһ�ж���һ�ֿ���.
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





