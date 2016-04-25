function c1=plus(c1,c2)
% 两组QTT分解的加法
%       c1=U_1 \bowtie U_2 \bowtie \cdots \bowtie U_d
%       c2=V_1 \bowtie V_2 \bowtie \cdots \bowtie V_d
% 则 c=c1+c2 满足
%                        | U_2     0 |                        | U_d |
%   c=[U_1,V_1] \bowtie  |           | \bowtie \cdots \bostie |     |
%                        |  0     V_2|                        | V_d |
%
%
% see also gtimes_qtt


%  JSong,17-Mar-2016
%  Last Revision: 17-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

if isa(c1,'double')&&(length(c1)==1)
    s=c2.subsizes;
    c1=ones_qtt(s,c1);
    c1=plus(c1,c2);
    return
end

if  isa(c2,'double')&&(length(c2)==1)
    s=c1.subsizes;
    c2=ones_qtt(s,c2);
    c1=plus(c1,c2);
    return
end





if isa(c1,'qttarray')&&(isa(c2,'qttarray'))
    d1=c1.d;
    d2=c2.d;
    if d1==d2
        d=d1;
    else
        warning('the length of c1 and c2 don''t equal.')
        return
    end
    
    subsizes=c1.subsizes;
    qr1=c1.r;
    qr2=c2.r;
    c1=c1.core;
    c2=c2.core;
    for i=1:d
        lt1=c1{i}.dat;r1=qr1(i:i+1);
        lt2=c2{i}.dat;r2=qr2(i:i+1);
        subsize=subsizes(i,:);
        lt1=reshape(lt1,r1(1),[]);
        lt2=reshape(lt2,r2(1),[]);
        if (i==1)&&(r1(1)==r2(1))
            lt=[lt1,lt2];
            r=[r1(1);r1(2)+r2(2)];
            c1{i}=layer_tensor(lt(:),r,subsize);
        elseif (i==d)&&(r1(2)==r2(2))
            lt=[lt1;lt2];
            r=[r1(1)+r2(1);r1(2)];
            c1{i}=layer_tensor(lt(:),r,subsize);
        elseif (i>1)&&(i<d)
            lt=[lt1,zeros(r1(1),size(lt2,2));zeros(r2(1),size(lt1,2)),lt2];
            c1{i}=layer_tensor(lt(:),r1+r2,subsize);
        else
            warning('Please Check the size of c1{1} and c2{1}.')
            return
        end
    end
    c1=qttarray(c1);
    return
end

end




function c=ones_qtt(s,a)
d=size(s,1);
L=size(s,2);
c=cell(d,1);
for i=1:d
    if L==1
        core=ones(s(i,1));
    else
        core=ones(s(i,:));
    end
    c{i}=layer_tensor(core);
end
c{1}=a*c{1};
c=qttarray(c);
end
