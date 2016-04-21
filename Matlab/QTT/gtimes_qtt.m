function c1=gtimes_qtt(c1,c2,types,varargin)
%  QTT�ֽ�����Ĺ���˷�,����
%           c1=U_1 \bowtie \cdots \bowtie U_d;
%           c2=V_1 \bowtie \cdots \bowtie V_d;
% ����
%           c=gtimes(c1,c2)=(U_1 \bullet V_1) \bowtie \cdots;
%


%  JSong,17-Mar-2016
%  Last Revision: 17-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com



d1=length(c1);d2=length(c2);
if d1~=d2
    error('error::length(c1)~=length(c2).');
end
l1=ndims(c1);
if nargin==2
    types=[l1;1];
    epss=1e-14;
elseif nargin==3
    epss=1e-14;
else
    epss=varargin{1};
end

for i=1:d1
        c1{i}=lktimes(c1{i},c2{i},types);
end
c1=round_qtt(c1,epss);