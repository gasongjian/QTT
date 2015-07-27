function B=gtimes(A1,A2,type)

if isequal(type,[2;1])&&ismatrix(A1)&& ismatrix(A2) && size(A1,2)==size(A2,1)
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