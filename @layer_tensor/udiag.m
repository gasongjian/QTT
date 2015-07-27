function lt1=udiag(lt)
r=lt.size;
scale=lt.scale;scale=scale(:);
l=numel(scale);
lt=lt.dat;
lt=reshape(lt,[r(1),numel(lt)/r(1)]);
ind1=ones(1,r(1));ind2=prod(scale)*ones(1,r(2));
lt=mat2cell(lt,ind1,ind2);
if l==1
   lt=cellfun(@(x)diag(x),lt,'UniformOutput',false);
   lt=cellfun(@(x)(x(:))',lt,'UniformOutput',false);
   lt=cell2mat(lt);
   scale=[scale;scale];
elseif l==2
    lt=cellfun(@(x)reshape(x,scale'),lt,'UniformOutput',false);
   lt=cellfun(@(x)(diag(x))',lt,'UniformOutput',false);
   lt=cell2mat(lt);
   scale=min(scale);
else
    disp('numel(scale)>2')
end
lt1=layer_tensor;
lt1.size=r;
lt1.dat=lt(:);
lt1.scale=scale;

    

    