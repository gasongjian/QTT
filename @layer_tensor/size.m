function d=size(lt,pos)
% FUNCTION d=size(lt[,pos])
% size(lt)=lt.size;
% size(lt,'i')=lt.scale;
% 
%
%  @J.Song @2015.07.20 @1.0


if nargin==1
    pos='outer';
end

switch pos
    case {'outer','o',0}
        d=(lt.size)';
    case {'inner','i','I',1}
        d=(lt.scale)';
end