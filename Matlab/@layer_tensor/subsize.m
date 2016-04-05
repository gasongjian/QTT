function s=subsize(lt,pos)
%SIZE  get the size of layer tensor lt
%
% r=subsize(lt);
% r=subsize(lt,1);
% 
%
%  see also layer_tensor,

%  JSong,20-Jul-2015
%  Last Revision: 5-April-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 

if nargin==1
s=(lt.subsize)';
else 
    s=(lt.subsize)';
    if pos<=length(s)
        s=s(pos);
    else
        error(message('wrong pos!'));
    end
end