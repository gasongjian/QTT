function c1=kron(c1,c2)
r1=c1.r;r1=r1(:);
r2=c2.r;r2=r2(:);
if r1(end)~=r2(1)
    error('r1(end)~=r2(1)')
end 
    
core=[c1.core,c2.core];
d=c1.d+c2.d;
r=[r1;r2(2:end)];
subsizes=[c1.subsizes;c2.subsizes];
c1.core=core;
c1.d=d;
c1.r=r;
c1.subsizes=subsizes;
