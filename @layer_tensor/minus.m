function lt=minus(lt,lt1)
% FUNCTION lt=MINUS(lt1,lt2,[,lt3,..,ltN])
% 分层张量的减法?lt1-lt2
%
% @J.Song @2015.07.20 @1.0
if isequal(lt.size,lt1.size)&&isequal(lt.scale,lt1.scale)
    lt.dat=lt.dat-lt1.dat;
else
    error('error:: the size of lt1 is not equal to the size of lt2!')
end
