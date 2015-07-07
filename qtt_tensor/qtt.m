function tto=qtt(A,q,max_level,epss,method)
% FUNCTION  [tto,oldsize,ttscale]=QTT(A,q,max_level,epss,method)
%     tto.oldsize :
%     tto.scale: 
%      1  2   ...  l
%  1   q  q        q
%  2   q  q        q
%  .
%  .
%  d   s1 s2       sl
%
%   example:
%          A=floor(10*rand(9,16,17));
%         tto=qtt(A);
%
%  @J.Song @2015.05.24 @1.0
%
%  see also wpt_qtt iwpt_qtt



if nargin==1
     q=2;
    epss=1e-14;
    max_level=[];
    method='sym';   
elseif nargin==4
    method='sym';
end


ndim=ndims(A);
oldsize=size(A);
if isvector(A)
    A=A(:);
    ndim=1;
    oldsize=size(A,1);
end

if any(oldsize==1)
    error('Please check the array.');
end

    
d=min(floor(log(oldsize)*(1+eps)/log(q))); 
if ~isempty(max_level)
d=min(d,max_level);
end



switch method
    case 'sym'
        last_size=fix(oldsize*(1-eps)/q^(d-1))+1;last_size=last_size(:);
        newsize=q^(d-1)*last_size;
        extension=0;
        if ~isequal(oldsize,newsize)
        index=cell(ndim,1);
        for j=1:ndim
            temp=[1:oldsize(j)];
            temp=[temp temp(end:-1:2*end-newsize(j)+1)];
            index{j}=temp;
        end
        temp=sprintf('index{%d},',[1:ndim]);
        temp(end)=[];
        temp=['A=A(',temp,');'];
        eval(temp)
        extension=1;
        end
end

ttscale=[q*ones(d-1,ndim);last_size'];
A = reshape(A, (ttscale(:))'); 
if ndim>1 
prm=1:ndim*d; prm=reshape(prm,[d,ndim]); prm=prm';
prm=prm(:); % Transposed permutation
A=permute(A,prm);
A=reshape(A,(prod(ttscale,2))');
end
tto=tt_svd(A,epss);
tto.oldsize=oldsize;
tto.scale=ttscale;
tto.ndim=ndim;
tto.isextension=extension;
tto.exten_method=method;


end


function t=tt_svd(A,epss)

t=struct;
n=size(A);n=n(:);
d = numel(n);
r = ones(d+1,1);
core=[];
pos=1;
ep=epss/sqrt(d-1);
c=A;
%%==============[modification]======================================

for i=1:d-1
    % m=n(i)*r(i); c=reshape(c,[m,numel(c)/m]);
    % ===============[part one]=====================
    m=n(i)*r(i); c=reshape(c,[r(i),n(i),numel(c)/m]);
    c=permute(c,[2 1 3]);
    c=reshape(c,[m,numel(c)/m]);
    %=================================================
    [u,s,v]=svd(c,'econ');
    %[u,s,v]=psvd(c);
    s=diag(s); r1=my_chop2(s,ep*norm(s));
    u=u(:,1:r1); s=s(1:r1);
    r(i+1)=r1;
    % ===============[part two]====================
    u=reshape(u,[n(i),r(i),r1]);
    u=permute(u,[2,1,3]);
    % ================================================
    core(pos:pos+r(i)*n(i)*r(i+1)-1)=u(:);
    v=v(:,1:r1);
    v=v*diag(s); c=v';
    pos=pos+r(i)*n(i)*r(i+1);
end
%%==================[end  modification]================================
core(pos:pos+r(d)*n(d)*r(d+1)-1)=c(:);
core=core(:);
ps=cumsum([1;n.*r(1:d).*r(2:d+1)]);
t.d=d;
t.n=n;
t.r=r;
t.ps=ps;
t.core=core;
end









