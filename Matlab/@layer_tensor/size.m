function r=size(lt,pos)
%SIZE  get the size of layer tensor lt
%
% r=size(lt);
% r=size(lt,1);
% 
%
%  see also layer_tensor,

%  JSong,20-Jul-2015
%  Last Revision: 5-April-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 

if nargin==1
r=(lt.size)';
else 
    r=(lt.size)';
    if pos<=length(r)
        r=r(pos);
    else
        error(message('wrong pos!'));
    end
end

