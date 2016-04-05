function c1=plus_qtt(c1,c2,varargin)
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

d1=length(c1);
d2=length(c2);
if d1==d2
    d=d1;
else
    warning('the length of c1 and c2 don''t equal.')
    return
end


for i=1:d
    lt1=c1{i};r1=lt1.size;subsize=lt1.subsize;lt1=lt1.dat;
    lt2=c2{i};r2=lt2.size;lt2=lt2.dat;
    lt1=reshape(lt1,[r1(1),numel(lt1)/r1(1)]);
    lt2=reshape(lt2,[r2(1),numel(lt2)/r2(1)]);
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
c1=round_qtt(c1);



if nargin>2
    n=nargin;
    c1=plus_qtt(c1,c2);
    for i=1:n-2
        c1=plus_qtt(c1,varargin{i});
    end    
end




