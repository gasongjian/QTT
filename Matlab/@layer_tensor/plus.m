function lt=plus(lt,lt1)
%PLUS  plus of lt and lt1.
%
%  Example:
%    lt1=layer_tensor(rand(2,3,4,5));
%    lt2=layer_tensor(rand(2,3,4,5));
%    lt=lt1+lt2;
%
%  see also layer_tensor, minus

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 
if ~isa(lt,'layer_tensor')
    lt=lt1+lt;
    return
end

if isa(lt1,'layer_tensor')&&isequal(lt.size,lt1.size)&&isequal(lt.subsize,lt1.subsize)
    lt.dat=lt.dat+lt1.dat;
elseif isa(lt1,'double')&&(length(lt1)==1)
    lt.dat=lt.dat+lt1;
else
    error('error:: the size of lt1 is not equal to the size of lt2!')
end   



    
