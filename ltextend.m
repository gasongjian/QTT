function lt1=ltextend(lt,newscale,type)
%LTEXTEND  extend for layer_tensor
%
%  lt1=LTEXTEND(lt,newscale,type)
%  lt: layer_tensor
%  newscale: prod(newscale,1) > lt.scale
%  type: extend method
%    -'sym': [a1,a2,a3,a4]-->[a1,a2,a3,a4,a4,a3,a2,...];
%    -'zpd': fulfill zero

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com  

newscale=newscale(:);
if isa(lt,'double')
    oldscale=size(lt);oldscale=oldscale(:);
    l=numel(oldscale);
    r=[1;1];
    lt=layer_tensor(lt,r,oldscale);
    
elseif isa(lt,'layer_tensor')
    oldscale=lt.scale;
    r=lt.size;
    l=numel(oldscale);
end

if numel(newscale)~=l
    disp('  length(newscale)~=length(oldscale)');
    return
end



if isequal(oldscale,newscale)
    lt1=lt;
    if isequal(r,[1;1])
        lt1=lt(1,1);
    end
    return
end

lt1=layer_tensor(zeros(prod(newscale)*prod(r),1),r,newscale);

switch type
    case 'sym'
        index=cell(l,1);
        for j=1:l
            temp=1:oldscale(j);
            temp=[temp temp(end:-1:2*end-newscale(j)+1)];
            index{j}=temp;
        end
        temp=sprintf('index{%d},',[1:l]);
        temp(end)=[];
        temp=['@(x) x(',temp,')'];
        temp=['lt1=ltfun(lt,',temp,',[',num2str(newscale'),']);'];
        eval(temp);
        
        
    case  {'zpd','0'}
        for ii=1:r(1)
            for jj=1:r(2)
                %A=lt(ii,jj);
                if l==1
                    newscale=[newscale;1];
                end
                A=zeros(newscale');
                s=sprintf('1:%d,',oldscale);s(end)=[];
                s=['A(',s,')=lt(',num2str(ii),',',num2str(jj),');'];
                eval(s);
                lt1(ii,jj)=A;
            end
        end
end

