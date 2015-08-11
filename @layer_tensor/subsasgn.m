function lt=subsasgn(lt,s,b)
%SUBSASGN¡¡subs assignment of lt
%
%  Example:
%    lt.dat=B;
%    lt(i,j)=B;
%
%  see also layer_tensor, subsref

%  JSong,31-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 


%% lt2cell
r=lt.size;
scale=lt.scale;scale=scale(:);
l=numel(scale);


%%
switch s(1).type
    case '.'
        switch s(1).subs
            case {'r','size'}
                 disp('  erorr:: Invalid Type!')
                 return
            case {'scale'}
                  disp('  erorr:: Invalid Type!')
                  return  
            case 'dat'
                lt.dat=b;             
        end
        
    case '()'
        
        if numel(b)~=prod(scale) 
           disp('    error::Invalid Input!');
           return
        end
        pp=s(1).subs;
        lt=reshape(lt.dat,[r(1),prod(scale),r(2)]);
        lt(pp{1},:,pp{2})=(b(:))';
        lt=layer_tensor(lt(:),r,scale);
end











