function [elem]=subsref(lts,s)
%SUBSREF subs reference of lt
%
%  ---------------------
%  Arribute subsref:
%    lts.subsize;
%    lts.dat;
%    lts.size
%  ---------------------
%  subtensor reference:
%    A=lts(i,j);
%    A=lts(1:2,:);
%    A=lts(:);
%  ---------------------
%  element tensor reference:
%    A=lts{i1,i2,i3,...};
%
%
%  see also layer_tensor, subsasgn

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com


r=lts.size;
subsize=lts.subsize;
l=numel(subsize);

switch s(1).type
    case '.'
        switch s.subs
            case {'r','size'}
                elem=lts.size;
            case {'subsize'}
                elem=lts.subsize;
            case {'dat'}
                elem=lts.dat;
        end       
        
    case '()'
        pp=s.subs;pp1=pp;
        mn=numel(pp);
        lts=reshape(lts.dat,[r(1),prod(subsize),r(2)]);
        elem=layer_tensor;
        elem.subsize=subsize(:);
        
        if (mn==1)&&ischar(pp{1})&&(pp{1}==':')
            lts=permute(lts,[1,3,2]);
            elem.dat=lts(:);
            elem.size=[r(1)*r(2);1];
            return
        end
        if (mn==1)
            pp1={mod(pp{1}-1,r(1))+1;floor((pp{1}-1)/r(1))+1};
        elseif ischar(pp{1})&&(pp{1}==':')
            pp1{1}=1:r(1);
        elseif ischar(pp{2})&&(pp{2}==':')
            pp1{2}=1:r(2);
        end
        
        r_new=[numel(pp1{1}),numel(pp1{2})];
        elem.size=r_new(:);
        lts=lts(pp1{1},:,pp1{2});lts=lts(:);
        if  prod(r_new(:))==1
            if l>1
                elem=reshape(lts,(subsize(:)'));
            else
                elem=lts;
            end
        else
            elem.dat=lts;
        end
        
    case '{}'
        pp=s.subs;
        pp=cell2mat(pp);
        mn=numel(pp);
        if mn~=numel(subsize)
            error('Invalid number of index asked')
        end
        lts=reshape(lts.dat,[r(1) subsize' r(2)]);
        strind=sprintf('%d,',pp);
        strind=[':,',strind,':'];
        eval(['elem=lts(',strind,');']);
        elem=reshape(elem,[r(1),r(2)]);
end
