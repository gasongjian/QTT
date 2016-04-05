function A=double(lt)
%DOUBLE Convert lt into multi-dimensional array
%  

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

r=lt.size;
subsize=lt.subsize;
A=reshape(lt.dat,[r(1),subsize',r(2)]);
A=squeeze(A);
if isvector(A)
    A=A(:);
end
