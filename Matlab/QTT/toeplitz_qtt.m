function y=toeplitz_qtt(c)
% ��ʱ������ֻʵ��������Toeplitz����.
% c�ĳ������Ծ�����Ϊ 2^d 

n=length(c);
d=log2(n);

%% ������ķֲ�����
G=cell(2,2);
a=zeros(2,2,2);
a(1,1,1)=1;a(2,2,1)=1;a(2,1,2)=1;
G{1,1}=a;
a=zeros(2,2,2);a(2,1,1)=1;
G{1,2}=a;
a=zeros(2,2,2);a(1,2,2)=1;
G{2,1}=a;
a=zeros(2,2,2);
a(1,2,1)=1;a(1,1,2)=1;a(2,2,2)=1;
G{2,2}=a;
G=layer_tensor(G);

%% QTT of x 
x=lqtt(c,ones(d,1)*2,1e-6); 

%%
types=[3;1];
y=cell(d,1);
y{1}=lktimes(G(1,:),x{1},types);
for i=2:d-1
    y{i}=lktimes(G,x{i},types);
end
y{d}=lktimes(G(:,1),x{d},types);
y=round_qtt(y);






