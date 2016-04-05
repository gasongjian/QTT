function lt1=ctranspose(lt)
%CTRANSPOSE  
%  lt1=lt1';
%  lt1.size=(lt.size)(2:1);
%  lt1.subsize=lt.subsize;
%  lt1(i,j)=lt(j,i);
%  

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com
lt1=lt;
r=lt.size;
subsize=lt.subsize;
lt=reshape(lt.dat,[r(1),prod(subsize(:)),r(2)]);
lt=permute(lt,[3,2,1]);
lt1.dat=lt(:);
lt1.size=[r(2);r(1)];
