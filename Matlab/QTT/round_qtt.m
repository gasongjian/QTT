function c=round_qtt(c,varargin)
% 
if nargin==1
    epss=1e-14;
else
    epss=varargin{1};
end   
d=length(c);

%% from right to left
[ltr,ltq]=ltqr(c{d});
c{d}=ltq;
for i=d-1:-1:2        
    lt=lkron(c{i},ltr);
    [ltr,ltq]=ltqr(lt);
    c{i}=ltq;
end
c{1}=lkron(c{1},ltr);
%% from left to right
for i=1:d-1
    subsize1=c{i}.subsize;subsize1=subsize1(:);
    subsize2=c{i+1}.subsize;subsize2=subsize2(:);
    subsizes=[subsize1';subsize2'];
    c1=lqtt(lkron(c{i},c{i+1}),subsizes,epss);
    c{i}=c1{1};c{i+1}=c1{2};
end

