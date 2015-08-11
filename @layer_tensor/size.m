function d=size(lt,pos)
%SIZE  get the size or scale of lt
%
% size(lt):=lt.size;
% size(lt,'i'):=lt.scale;
%
%  see also layer_tensor,

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 

if nargin==1
    pos='outer';
end

switch pos
    case {'outer','o',0}
        d=(lt.size)';
    case {'inner','i','I',1}
        d=(lt.scale)';
end