function [A]=ltfold(lt,type)



r=lt.size;
subsize=lt.subsize;
lt=lt.dat;

if ischar(type)
    type=upper(type);
    d=length(type);
end


switch type(1)
    case {'R'}
       A=reshape(lt,[r(1),numel(lt)/r(1)]);
    case {'L'}
        A=reshape(lt,[r(1),prod(subsize(:)),r(2)]);
        A=permute(A,[2,1,3]);
        A=reshape(A,[numel(A)/r(2),r(2)]);
end




end
