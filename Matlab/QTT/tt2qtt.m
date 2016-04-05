function c=tt2qtt(tt)
% 工具箱之间的转化函数
% tt2qtt 将tt_tensor 类或tt_matrix类转化成本工具箱的QTT
%
%  example:
%         a=rand(128,128);
%         t=tt_matrix(reshape(a,ones(1,14)*2));
%         c=tt2qtt(t);
%         a1=double(full_qtt(c));
%         disp(norm(a1-full(t),'fro'));
%

%  JSong,5-Apr-2016
%  Last Revision: 5-Apr-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

if isa(tt,'tt_tensor')
    d=tt.d;
    r=tt.r;
    core=tt.core;
    ps=tt.ps;
    n=tt.n;
    c=cell(d,1);
    for i=1:d
        j=d+1-i;
        tmp=reshape(core(ps(j):(ps(j+1)-1)), r(j), n(j), r(j+1));
        tmp=permute(tmp,[3,2,1]);
        c{i}=layer_tensor(tmp(:),[r(j+1);r(j)],n(j));
    end
elseif isa(tt,'tt_matrix')
    n=tt.n;
    m=tt.m;
    c=tt2qtt(tt.tt);
    d=length(c);
    for i=1:d
        tmp=c{i};
        tmp.subsize=[n(d+1-i);m(d+1-i)];
        c{i}=tmp;
    end
else
    disp('invalid class: tt');
    return
end
    

