function tto=qtt2tt(c)

d=c.d;
r=c.r;
l=c.ndims;
subsizes=c.subsizes;
nn=sum(prod([subsizes,r([(1:d)',(2:d+1)'])],2));
%nn=info_qtt(c,'numel');
c=c.core;
core=zeros(nn);
tt=tt_tensor;
r=r(end:-1:1);
n=prod(subsizes,2);
n=n(end:-1:1);
ps=cumsum([1;n.*r(1:d).*r(2:d+1)]);

for i=1:d
    tmp=c{d+1-i};
    tmp=tmp';
    core(ps(i):ps(i+1)-1)=tmp.dat;
end
tt.d=d;
tt.r=r;
tt.ps=ps;
tt.core=core;
tt.n=n;

if l==1
    tto=tt;
elseif l==2
    tto=tt_matrix(tt,subsizes(end:-1:1,1),subsizes(end:-1:1,2));
else
    tto=tt;
    disp('function only support vector and matrix.');
end