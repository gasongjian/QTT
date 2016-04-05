function y=info_qtt(ltcore,arg)
d=size(ltcore,1);
l=numel(ltcore{1}.subsize);
subsizes=zeros(d,l);
elems=0;
for i=1:d
    temp=ltcore{i}.subsize;
    subsizes(i,:)=temp';
    elems=elems+numel(ltcore{i}.dat);
end

arg=lower(arg);
switch arg
    case {'r','rank'}
        r=zeros(d+1,1);
        r0=ltcore{1}.size;
        r(1)=r0(1);
        for i=1:d
            r0=ltcore{i}.size;
            r(i+1)=r0(2);
        end
        y=r;
    case {'erank'}
        s=prod(subsizes,2);
        a=sum(s(2:d-1));
        b=s(1)+s(d);
        c=elems;
        y=(sqrt(b^2+4*a*c)-b)/2/a;
    case {'subsizes'}
        y=subsizes;
    case {'elems','numel'}
        y=elems;
    case {'ndim'}
        y=l;
end
            
        
