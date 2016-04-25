function c1=mtimes(c1,c2,types,varargin)


%  JSong,17-Mar-2016
%  Last Revision: 17-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

if isa(c1,'double')&&(length(c1)==1)
    core=c2.core;
    core{1}=c1*core{1};
    c2.core=core;
    c1=c2;
    return
end

if  isa(c2,'double')&&(length(c2)==1)
    core=c1.core;
    core{1}=c2*core{1};
    c1.core=core;
    return
end

c1=c1.core;
c2=c2.core;
d1=length(c1);d2=length(c2);
if d1~=d2
    error('error::length(c1)~=length(c2).');
end
L=ndims(c1);
if nargin==2
    types=[L;1];
    eps=1e-14;
elseif nargin==3
    eps=1e-14;
else
    eps=varargin{1};
end

for i=1:d1
        c1{i}=lktimes(c1{i},c2{i},types);
end
c1=qttarray(c1,'orth',eps);
