function lt=mtimes(lt1,lt2)

   if isa(lt1,'double')&& isa(lt2,'layer_tensor')
       lt=lt2;
       lt.dat=lt1*(lt2.dat);
       return
   elseif isa(lt1,'layer_tensor')&& isa(lt2,'double')
       lt=lt1;
       lt.dat=lt2*(lt1.dat);
       return
   end

    l=length(lt1.subsize);
    r1=lt1.size; c1=lt1.dat; s1=lt1.subsize;clear lt1
    r2=lt2.size; c2=lt2.dat; s2=lt2.subsize;clear lt2
    
    if (r1(2)~=r2(1))||(numel(s1)~=numel(s2))
        disp('r1(2)~=r2(1) or numel(s1)~=numel(s2)!')
        return
    end
    
    c1=reshape(c1,[r1(1),prod(s1),r1(2)]);
    c1=permute(c1,[2,1,3]);
    c1=reshape(c1,[numel(c1)/r1(2),r1(2)]);
    c2=reshape(c2,[r1(2),numel(c2)/r1(2)]);
    c=c1*c2;
    
    c=reshape(c,[s1',r1(1),s2',r2(2)]);
    if l>1
        index=[l+2:2*l+1;1:l];
        index=[l+1;index(:);2*l+2];
        c=permute(c,index);
    else
        c=permute(c,[2,3,1,4]);
    end
    lt=layer_tensor;
    lt.dat=c(:);
    lt.size=[r1(1);r2(2)];
    lt.subsize=s1.*s2;
