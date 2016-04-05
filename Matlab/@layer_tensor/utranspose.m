function lt1=utranspose(lt)
%UTRANSPOSE  inner layer transpose operation of lt 
%
%  LT1=UTRANSPOSE(LT)  LT1(i,j)=(LT1(i,j))'
%
%  Example:
%    lt=layer_tensor(rand(2,3,4,5));
%    lt1=utranspose(lt);
%    
%
%  see also layer_tensor, 

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 
lt1=lt;
r=lt.size;
subsize=lt.subsize;subsize=subsize(:);
ind=[numel(subsize)+2:-1:1];ind(end)=ind(1);ind(1)=1;
lt=reshape(lt.dat,[r(1),subsize',r(2)]);
lt=permute(lt,ind);
lt1.dat=lt(:);
lt1.subsize=subsize(end:-1:1);
