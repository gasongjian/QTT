function lt=lktimes(lt1,lt2,type)
%LKTIMES  layer general product of layer_tensor
%   outer layer use kronecker produce
%   inner layer produce use general product
%
%  Example:
%       a=layer_tensor(floor(10*rand(2,2,2,2)));
%       b=layer_tensor(floor(10*rand(2,2,2,2)));
%       c=layer_tensor(floor(10*rand(2,2,2,2)));
%       d=layer_tensor(floor(10*rand(2,2,2,2)));
%       e1=lktimes(lkron(a,b),lkron(c,d),[2;1]);
%       e2=lkron(lktimes(a,c,[2;1]),lktimes(b,d,[2;1]));
%       isequal(e1,e2)
%
%  see also lkron

%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 

r1=lt1.size;s1=lt1.subsize;s1=s1(:);lt1=lt1.dat;
r2=lt2.size;s2=lt2.subsize;s2=s2(:);lt2=lt2.dat;
if (nargin==2)&&(s1(end)==s2(1))
    type=[numel(s1);1];
end

if ~isequal(s1(type(1,:)),s2(type(2,:)))
    disp('Invalid type ');
    return
end

%% get new subsize
s11=s1;s11(type(1,:))=[];s22=s2;s22(type(2,:))=[];
s=[s11;s22];
if isempty(s),s=1;end
%% get new size
r=r1.*r2;

%% 
lt1=reshape(lt1,[r1(1),prod(s1),r1(2)]);
lt2=reshape(lt2,[r2(1),prod(s2),r2(2)]);


%% 
dat=zeros(r(1),r(2)*prod(s));
for i=1:r(1)
    for j=1:r(2)
        % ii and jj are kron index dec
        ii=[floor((i-1)/r2(1))+1,mod((i-1),r2(1))+1];
        jj=[floor((j-1)/r2(2))+1,mod((j-1),r2(2))+1];
        
        % get the subtensor of lt1 and lt2
        tmp1=lt1(ii(1),:,jj(1));
        if numel(s1)==1
            tmp1=tmp1(:);
        else
            tmp1=reshape(tmp1,s1');
        end
        
        tmp2=lt2(ii(2),:,jj(2));
        if numel(s2)==1
            tmp2=tmp2(:);
        else
            tmp2=reshape(tmp2,s2');
        end
        % gtimes,storage in matrix as a row vector 
        tmp=gtimes(tmp1,tmp2,type);
        tmp=tmp(:);
        ind=[prod(s)*(j-1)+1:prod(s)*j];
        dat(i,ind)=tmp';
    end
end
lt=layer_tensor;
lt.dat=dat(:);
lt.size=r;
lt.subsize=s;


end

function B=gtimes(A1,A2,type)
% general tensor product


if isequal(type,[2;1])&&ismatrix(A1)&& ismatrix(A2) && size(A1,2)==size(A2,1)
    B=A1*A2;
    return
end

s1=size(A1);s2=size(A2);s11=s1;s22=s2;
s11(type(1,:))=[];s22(type(2,:))=[];
s=[s11(:);s22(:)];
if isempty(s)
    s=1;
end


ind1=[1:numel(s1)];ind1(type(1,:))=[];
ind1=[ind1,type(1,:)];
A1=permute(A1,ind1);
A1=reshape(A1,[prod(s11),numel(A1)/prod(s11)]);

ind2=[1:numel(s2)];ind2(type(2,:))=[];
ind2=[type(2,:),ind2];
A2=permute(A2,ind2);
A2=reshape(A2,[numel(A2)/prod(s22),prod(s22)]);
B=A1*A2;
if numel(s)>1
B=reshape(B,s');
else
    B=B(:);
end
end





    


