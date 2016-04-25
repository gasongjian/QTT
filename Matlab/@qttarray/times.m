function c1=times(c1,c2,varargin)


%  JSong,17-Mar-2016
%  Last Revision: 17-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

if nargin>2
    eps=varargin{1};
else
    eps=1e-14;
end
c1=c1.core;
c2=c2.core;
d1=length(c1);d2=length(c2);
if d1~=d2
    error('error::length(c1)~=length(c2).');
end
d=d1;
for i=1:d
        c1{i}=lkdtimes(c1{i},c2{i});
end
c1=qttarray(c1,'orth',eps);