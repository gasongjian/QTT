function B=gtimes(A1,A2,type)
%GTIMES  general times of two tensor
%  B=gtimes(A1,A2,type)
%  A1;n1*n2*...*nd1
%  A2:m1*m2*...*md2
%  type: times matrix
%      |a1,a2,...,ad|
%      |b1,b2,...,bd|
%
%  Example:
%    A1=rand(3,4);
%    A2=rand(4,5);
%    A3=rand(4,5,6);
%    B1=gtimes(A1,A2,[2;1]);
%    isequal(B1,A1*A2)
%    B2=gtimes(A2,A3,[1,2;1,2]);
%
%  see also nkron,outer


%  JSong,3-Aug-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com





if isequal(type,[2;1])&&ismatrix(A1)&& ismatrix(A2)
    B=A1*A2;
    return
end

s1=size(A1);s2=size(A2);s11=s1;s22=s2;
s11(type(1,:))=[];s22(type(2,:))=[];
s=[s11(:);s22(:)];
if isempty(s)
    s=1;
end


ind1=[1:numel(s1)];ind1(type(1,:))=[];
ind1=[ind1,type(1,:)];
A1=permute(A1,ind1);
A1=reshape(A1,[prod(s11),numel(A1)/prod(s11)]);

ind2=[1:numel(s2)];ind2(type(2,:))=[];
ind2=[type(2,:),ind2];
A2=permute(A2,ind2);
A2=reshape(A2,[numel(A2)/prod(s22),prod(s22)]);
B=A1*A2;
if numel(s)>1
B=reshape(B,s');
else
    B=B(:);
end
end