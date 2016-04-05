function n=ltnumel(lt)
%numel  get the num or subsize of lt
%
% size(lt):=lt.size;
% size(lt,'i'):=lt.subsize;
%
%  see also layer_tensor,

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 

r=lt.size;
subsize=lt.subsize;
n=prod(r(:))*prod(subsize(:));
