function [elem]=subsref(lt,s)
%SUBSREF subs reference of lt
% 
%  ---------------------
%  Arribute subsref:
%    lt.scale;
%    lt.dat;
%    lt.size
%  ---------------------
%  subtensor reference: 
%    A=lt(i,j); 
%    A=lt(1:2,:);
%    A=lt(:);
%  ---------------------
%  element reference:
%    A=lt{i1,i2,i3,...};
%
%
%  see also layer_tensor, subsasgn

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 


r=lt.size;
scale=lt.scale;scale=scale(:);
l=numel(scale);

switch s(1).type
    case '.'
        switch s(1).subs
            case {'r','size'}
                elem=lt.size;
            case {'scale'}
                elem=lt.scale;
            case 'dat'
                elem=lt.dat;
        end
        
    case '()'
        pp=s.subs;pp1=pp;
        mn=numel(pp);
        lt=reshape(lt.dat,[r(1),prod(scale),r(2)]);
        elem=layer_tensor;
        elem.scale=scale(:);
        
        if (mn==1)&&(pp1{1}==':')
            lt=permute(lt,[1,3,2]);
            elem.dat=lt(:);
            elem.size=[r(1)*r(2);1];
            return
        end
        
        
        if (mn==1)
           pp1={mod(pp{1}-1,r(1))+1;floor((pp{1}-1)/r(1))+1};
        elseif pp{1}==':'
            pp1{1}=1:r(1);
        elseif pp{2}==':'
            pp1{2}=1:r(2);
        end
        r_new=[numel(pp1{1}),numel(pp1{2})];
        elem.size=r_new(:);
        lt=lt(pp1{1},:,pp1{2});lt=lt(:);
        if  prod(r_new(:))==1
            if l>1
            elem=reshape(lt,(scale(:)'));
            else
             elem=lt;
            end
        else            
            elem.dat=lt;
        end
        
    case '{}'       
        pp=s.subs;
        pp=cell2mat(pp);
        mn=numel(pp);        
        if mn~=numel(scale)
            error('Invalid number of index asked')
        end
        lt=reshape(lt.dat,[r(1) scale' r(2)]);
        strind=sprintf('%d,',pp);
        strind=[':,',strind,':'];
        eval(['elem=lt(',strind,');']);
        elem=squeeze(elem);
end






