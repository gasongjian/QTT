function c=qttarray(varargin)
%  QTT数组构造函数
%  c: qttarray class
%  
%  -----------------from full array------------------------------------------------------
%  c=qttarray(a,subsizes,eps);
%  c=qttarray(a);
%  c=qttarray(a,subsizes);
% 
%  a: layer_tensor or l dimension array
%  subsizes: subsize matrix, the subsize of all QTT cores. 缺省n_i^j=2
%                ----------------------------
%                    1      2   ...    l
%                1   n^1_1  .   ...   n^1_l
%                2   n^2_1  .   ...   n^2_l
%    subsizes =   .   ...
%                .   ...
%                d   n^d_1  .   ...   n^d_l
%               ----------------------------
%  eps: 截断误差，缺省为1e-14.
%
%  ----------------from cell----------------------------------------
%  c=qttarray(core[,'orth',eps]);
%  core为存储着d个QTT核的cell，函数将之转化成qttarray类
%  'orth'：代表将该QTT数组右正交化或者重新截断
%  
%  ----------------from cell----------------------------------------
%  c=qttarray(tt);
%  tt: tt_tensor类 或者 tt_matrix类
%  
%  ----------------from cell----------------------------------------
%  c=qttarray(c[,'orth',eps])
%  将QTT数组重新回炉右正交化
%
%
%  -----------------------------------------------------------------------

%  JSong,25-Apr-2016
%  Last Revision: 25-Apr-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com




%% empty input
if (nargin == 0)
    c.r =[];
    c.d=[];
    c.core=[];
    c.orth=[];
    c.subsizes=[];
    c.ndims=[];
    c = class(c,'qttarray');
    return;
end

%% from cell
if (iscell(varargin{1}))&&(isa(varargin{1}{1},'layer_tensor'))
    
    core=varargin{1};
    d=length(core);
    if (nargin>2)&&(strcmp(varargin{2},'orth'))
        if (nargin>3)&&(varargin{3}<1)&&(varargin{3}>0)
            eps=varargin{3};
        else
            eps=1e-14;
        end
        c=round_qtt(core,eps);
        return
    end  
    c=qttarray;
    L=numel(core{1}.subsize);
    subsizes=zeros(d,L);
    r=zeros(d+1,1);
    r0=core{1}.size;
    r(1)=r0(1);
    for i=1:d
        subsizes(i,:)=(core{i}.subsize)';
        r0=core{i}.size;
        r(i+1)=r0(2);
    end
    c.core=core;
    c.r=r;
    c.d=d;
    c.subsizes=subsizes;
    c.ndims=L;
    c.orth=0;
    return
end

%% from tt_tensor class
if (isa(varargin{1},'tt_tensor'))
    tt=varargin{1};
    d=tt.d;
    r=tt.r;
    ttcore=tt.core;
    ps=tt.ps;
    n=tt.n;
    core=cell(d,1);
    for i=1:d
        j=d+1-i;
        tmp=reshape(ttcore(ps(j):(ps(j+1)-1)), r(j), n(j), r(j+1));
        tmp=permute(tmp,[3,2,1]);
        core{i}=layer_tensor(tmp(:),[r(j+1);r(j)],n(j));
    end
    c=qttarray;
    c.core=core;
    c.r=r(end:-1:1);
    c.d=d;
    n=n(:);
    c.subsizes=n(end:-1:1);
    c.orth=1;
    c.ndims=1;
    return
end

%% from tt_matrix class
if (isa(varargin{1},'tt_matrix'))
    tt=varargin{1};
    n=tt.n;
    m=tt.m;
    c=qttarray(tt.tt);
    d=c.d;
    ttcore=c.core;
    for i=1:d
        tmp=ttcore{i};
        tmp.subsize=[n(d+1-i);m(d+1-i)];
        ttcore{i}=tmp;
    end
    c.core=ttcore;
    c.subsizes=[n(:),m(:)];
    c.ndims=2;
    return
end

%% 正交化QTT数组
if (isa(varargin{1},'qttarray'))
    c=varargin{1};
    if nargin>1
        method=varargin{2};
        arg=varargin(3:end);
    else
        method='';
        arg={};
    end
    % 正交化
    if (c.over==0)||(strcmp(method,'orth'))
        % 待修改
        if isempty(arg)
            c=round_qtt(c);
        else
            eps=arg{1};
            c=round_qtt(c,eps);
        end
    end
    return
end



%% from full array
a=varargin{1};
if nargin==1
    if isa(a,'double')
        if isvector(a)
            s=length(a);
            a=layer_tensor(a(:));
        else
            s=size(a);
            a=layer_tensor(a);
        end
        L=length(s);
    elseif isa(a,'layer_tensor')
        s=a.subsize;
        L=length(s);
    end
    % 要求size都一样，若有错误有lqtt引发
    d=log2(max(s));
    subsizes=ones(d,L)*2;
    eps=1e-14;
elseif nargin==2
    subsizes=varargin{2};
    eps=1e-14;
else
    subsizes=varargin{2};
    eps=varargin{3};
end


%% main
%[core,arg]=lqtt(a,subsizes,eps);

% get basic info
r0=size(a);
L=ndims(a);
d=size(subsizes,1);
eps=eps/sqrt(d-1);
core=cell(d,1);
r=zeros(d+1,1);r(1)=r0(1);r(d+1)=r0(2);

% get all cores
for i=1:d-1
    r0=size(a);
    ltscale1=[prod(subsizes(1:d-i,:),1);subsizes(d-i+1,:)];
    index=ltscale1([2,1],:);index=(index(:))';
    a=reshape(a.dat,[r(1),index,r(d-i+2)]);
    index=[3:2:2*L+1,1,2:2:2*L+2];
    a=permute(a,index);
    a=reshape(a,[prod(ltscale1(1,:),2)*r(1),prod(ltscale1(2,:),2)*r(d-i+2)]);
    
    % svd
    [a,s,v]=svd(a,'econ');
    s=diag(s);
    sv=cumsum(s(end:-1:1).^2);
    r1=numel(sv)-sum(sv<eps^2*(s'*s));
    %r1=my_chop2(s,eps*norm(s));
    r(d-i+1)=r1;
    v=v(:,1:r1);v=v';
    v=layer_tensor(v(:),[r1;r0(2)],(ltscale1(2,:))');
    core{d-i+1}=v;
    
    s=s(1:r1); a=a(:,1:r1)*diag(s);
    a=reshape(a,[prod(ltscale1(1,:),2),r(1),r1]);
    a=permute(a,[2,1,3]);
    a=layer_tensor(a(:),[r0(1);r1],(ltscale1(1,:))');
end
core{1}=a;
% 返回类
c=qttarray;
c.core=core;
c.r=r;
c.orth=1;
c.subsizes=subsizes;
c.d=d;
c.ndims=size(subsizes,2);

end


function c1=round_qtt(c,varargin)
% 截断部分可能还需要修改
if nargin==1
    eps=1e-14;
else
    eps=varargin{1};
end
if isa(c,'qttarray')
    c=c.core;
end
d=length(c);
eps=eps/sqrt(d-1);
% from right to left
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
    subsize1=c{i}.subsize;
    subsize2=c{i+1}.subsize;
    subsizes=[subsize1';subsize2'];
    c1=lqtt(lkron(c{i},c{i+1}),subsizes,eps);
    c{i}=c1{1};c{i+1}=c1{2};
end

c1=qttarray;
L=numel(c{1}.subsize);
subsizes=zeros(d,L);
r=zeros(d+1,1);
r0=c{1}.size;
r(1)=r0(1);
for i=1:d
    subsizes(i,:)=(c{i}.subsize)';
    r0=c{i}.size;
    r(i+1)=r0(2);
end
c1.core=c;
c1.r=r;
c1.d=d;
c1.subsizes=subsizes;
c1.ndims=L;
c1.orth=1;
end


