function tto=qtt2tt(c)
% 工具箱之间的转化函数
% qtt2tt 将本工具箱的QTT转化成TT工具箱的tt_tensor 类或tt_matrix类
%
%  example:
%         a=rand(128,128);
%         c=lqtt(a,ones(7,2)*2,1e-14);
%         tto=qtt2tt(c);
%         a1=full(tto);
%         disp(norm(a1-a,'fro'));
%

%  JSong,5-Apr-2016
%  Last Revision: 5-Apr-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com



d=length(c);
r=info_qtt(c,'r');
l=numel(c{1}.subsize);
subsizes=info_qtt(c,'subsizes');
nn=info_qtt(c,'numel');
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
