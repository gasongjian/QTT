function lt1=ctranspose(lt)
lt1=lt;
r=lt.size;
scale=lt.scale;
lt=reshape(lt.dat,[r(1),prod(scale(:)),r(2)]);
lt=permute(lt,[3,2,1]);
lt1.dat=lt(:);
lt1.size=[r(2);r(1)];
