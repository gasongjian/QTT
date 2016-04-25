function elem=subsref(c,s)

d=c.d;
subsizes=c.subsizes;
L=c.ndims;
r=c.r;

switch s(1).type
    case '.'
        switch s.subs
            case {'r',}
                elem=r;
            case {'subsizes'}
                elem=subsizes;
            case {'core'}
                elem=c.core;
            case {'d'}
                elem=d;
            case {'ndims'}
                elem=L;
        end     
        
    case '()'
        %pp=s.subs;
        disp('to be continue...')

        
    case '{}'
        pp=s.subs;
        elem=c.core{pp{1}};
end
