function A=full(c)
% ��ԭ������

%  JSong,11-Aug-2015
%  Last Revision: 15-Mar-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

d=c.d;
c=c.core;
A=c{1};
for i=2:d
    A=lkron(A,c{i});
end

if sum(size(A))==2
    A=A(1,1);
end




