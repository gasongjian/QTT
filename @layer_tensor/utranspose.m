function lt1=utranspose(lt)
lt1=lt;
r=lt.size;
scale=lt.scale;scale=scale(:);
ind=[numel(scale)+2:-1:1];ind(end)=ind(1);ind(1)=1;
lt=reshape(lt.dat,[r(1),scale',r(2)]);
lt=permute(lt,ind);
lt1.dat=lt(:);
lt1.scale=scale(end:-1:1);