function c=rand_qtt(subsizes,r)
% ����һ�������QTT����
d=size(subsizes,1);
c=cell(d,1);
for i=1:d
    n=subsizes(i,:);n=n';
    tmp=orth(rand(prod(n)*r(i+1),r(i)));
    tmp=tmp';
    c{i}=layer_tensor(tmp(:),[r(i);r(i+1)],n);
end

