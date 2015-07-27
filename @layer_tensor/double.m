function A=double(lt)
r=lt.size;
scale=lt.scale;
A=reshape(lt.dat,[r(1) scale' r(2)]);
A=squeeze(A);
