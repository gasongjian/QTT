function A=full_qtt(ltcore)
% FULL_QTT lkron function for cell
%
%  Example:
%    ltcore2={lt1,lt2,lt3};
%    %A1= lt1 \bowtie lt2 \bowtie lt3
%    A1=full_qtt(ltcore2);
%    A2=lkron(lt1,lt2,lt3);%A1==A2


%  JSong,11-Aug-2015
%  Last Revision: 15-Mar-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com


A=ltcore{1};
d=length(ltcore);
for i=2:d
    A=lkron(A,ltcore{i});
end
