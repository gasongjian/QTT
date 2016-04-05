function [ltr,ltq]=ltqr(lt)
%  The QR decomposition of lt, and it makes
%             lt=ltr \bowtie ltq
%  which 
%             ltr.subsize=1,
%             ltq.subsize=1t.subsize,
%             ltq is a right orthogonal layer_tensor
%
%
%
%  JSong,17-Mar-2016
%  Last Revision: 17-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

r=lt.size;
subsize=lt.subsize;
l=numel(subsize);
lt=lt.dat;
lt=reshape(lt,[r(1),numel(lt)/r(1)]);
lt=lt';
[ltq,ltr]=qr(lt,0);
ltq=ltq';ltr=ltr';
newr=size(ltq,1);
ltq=layer_tensor(ltq(:),[newr;r(2)],subsize);
ltr=layer_tensor(ltr(:),[r(1);newr],ones(l,1));