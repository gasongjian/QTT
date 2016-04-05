function lt=lkdtimes(lt1,lt2)
%LKTIMES  layer general product of layer_tensor
%   outer layer use kronecker product
%   inner layer produce use hadamard product
%
%  Example:
%       a=layer_tensor(floor(10*rand(2,2,2,2)));
%       b=layer_tensor(floor(10*rand(2,2,2,2)));
%       c=layer_tensor(floor(10*rand(2,2,2,2)));
%       d=layer_tensor(floor(10*rand(2,2,2,2)));
%       e1=lktimes(lkron(a,b),lkron(c,d),[2;1]);
%       e2=lkron(lkdtimes(a,c),lkdtimes(b,d));
%       isequal(e1,e2)
%
%  see also lkron

%  JSong,17-Mar-2016
%  Last Revision: 17-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com 

r1=lt1.size;s1=lt1.subsize;s1=s1(:);lt1=lt1.dat;
r2=lt2.size;s2=lt2.subsize;s2=s2(:);lt2=lt2.dat;

%% get new subsize
if ~isequal(s1,s2)
    disp('Invalid type ');
    return
else
    s=s1;
end

%% get new size
r=r1.*r2;

%% 
lt1=reshape(lt1,[r1(1),prod(s),r1(2)]);
lt2=reshape(lt2,[r2(1),prod(s),r2(2)]);

%% 
dat=zeros(r(1),prod(s),r(2));
for i=1:r(1)
    for j=1:r(2)
        % ii and jj are kron index dec
        ii=[floor((i-1)/r2(1))+1,mod((i-1),r2(1))+1];
        jj=[floor((j-1)/r2(2))+1,mod((j-1),r2(2))+1];
        dat(i,:,j)=lt1(ii(1),:,jj(1)).*lt2(ii(2),:,jj(2));        
    end
end
lt=layer_tensor;
lt.dat=dat(:);
lt.size=r;
lt.subsize=s;


end