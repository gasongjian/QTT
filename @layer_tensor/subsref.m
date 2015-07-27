function [elem]=subsref(lt,s)
% FUNCTION　[elem]=SUBSREF(lt,s)
% 分层张量元素索引
%   lt(i,j)返回的是第i行第j列的子张量,支持lt(1:2,:)这类索引
%   (前者返回一个子张量，后者返回一个子分层张量)
%   lt{i1,i2,i3,...}返回的是一个矩阵，取子张量在上述位置的元素
% 
% 由于MATLAB某些方面的限制，上面的()和{}不能调换
%
% @J.Song @2015.07.20 @1.0



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






