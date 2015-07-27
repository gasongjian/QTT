function d=length(lt,pos)

if nargin==1
    pos='outer';
end

r=lt.size;
switch pos
    case {'outer','o',0}
        d=prod(r(:));
    case {'inner','i',1}
        d=length(lt.core);
end