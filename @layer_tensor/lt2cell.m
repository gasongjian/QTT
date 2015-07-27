function lt=lt2cell(lt)

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
