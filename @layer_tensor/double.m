function A=double(lt)
%DOUBLE Convert lt into multi-dimensional array
%  

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

r=lt.size;
scale=lt.scale;
A=reshape(lt.dat,[r(1) scale' r(2)]);
A=squeeze(A);
