function lt1=ltfun(lt,func,newscale)
%LTFUN  apply func to every subtensor, see also cellfun
%
%  Example:
%    lt1=ltfun(lt,@(x)sum(x(:)),1);
%    
%

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 

r=lt.size;
scale=lt.scale;scale=scale(:);
l=numel(scale);
lt=lt.dat;
lt=reshape(lt,[r(1),numel(lt)/r(1)]);
ind1=ones(1,r(1));ind2=prod(scale)*ones(1,r(2));
lt=mat2cell(lt,ind1,ind2);
if l==1
   lt=cellfun(@(x)x(:),lt,'UniformOutput',false);
else
    lt=cellfun(@(x)reshape(x,scale'),lt,'UniformOutput',false);
end

lt=cellfun(func,lt,'UniformOutput',false);
lt=cellfun(@(x)(x(:))',lt,'UniformOutput',false);
lt=cell2mat(lt);
lt1=layer_tensor;
lt1.size=r;
lt1.dat=lt(:);
lt1.scale=newscale;
