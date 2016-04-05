function c=hadamard_qtt(c1,c2,varargin)
%  QTT分解数组的Hadamard 积(即点乘),若有
%           c1=U_1 \bowtie \cdots \bowtie U_d;
%           c2=V_1 \bowtie \cdots \bowtie V_d;
% 则有
%           c=c1.*c2=(U_1 \otimes -\odot V_1) \bowtie \otimes -\odot;
%


%  JSong,17-Mar-2016
%  Last Revision: 17-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

if nargin>2
    epss=varargin{1};
else
    epss=1e-10;
end

d1=length(c1);d2=length(c2);
if d1~=d2
    error('error::length(c1)~=length(c2).');
end
d=d1;
c=cell(d,1);
for i=1:d
        c{i}=lkdtimes(c1{i},c2{i});
end
c=round_qtt(c,epss);