function ltcore=qtt2ltcore(tt)
%QTT2LTCORE  convert struct from qtt into ltcore
% 
%  Example:
%    lt1=gqtt(A,ltscale,ltchop,extype);
%    tto=qtt(A,ltscale,ltchop,extype);
%    lt2=qtt2ltcore(tto);
%    % test lt1==lt2 

%  JSong,3-Aug-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

r=tt.r;
ps=tt.ps;
scale=tt.scale;
d=tt.d;
ltcore=cell(d,1);
for i=1:d
ltcore{i}=layer_tensor(tt.core(ps(i):ps(i+1)-1),r(i:i+1),scale(i,:));
end
