function lt=lt2cell(lt)
% LT2CELL  convert lt into cell array
%  return lt,it satisfied: lt{i,j}=lt(i,j)
%
%

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 

r=lt.size;
scale=lt.scale;scale=scale(:);
lt=lt.dat;
l=numel(scale);

lt=reshape(lt,[r(1),numel(lt)/r(1)]);
ind1=ones(1,r(1));
ind2=prod(scale)*ones(1,r(2));
lt=mat2cell(lt,ind1,ind2);
if l>1
lt=cellfun(@(x)reshape(x,scale'),lt,'UniformOutput',false);
else
    lt=cellfun(@(x)x',lt,'UniformOutput',false);
end
