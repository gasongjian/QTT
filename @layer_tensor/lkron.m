function lt=lkron(varargin)
% FUNCTION　lt=LKRON(lt1,lt2,[,lt3,..,ltN])
% 分层张量的分层kronecker 乘法,即\bowtie 运算
% 牵涉比较复杂的置换，具体操作方式可参见论文
%
%
%      @J.Song @2015.07.20 @1.0
%  


%% one argument
if (nargin==1)&&isa(varargin{1},'layer_tensor')
    lt=varargin{1};
    return
end


%%  normal 
if nargin==2
    lt1=varargin{1};
    lt2=varargin{2};
    l=length(lt1.scale);
    r1=lt1.size; c1=lt1.dat; s1=lt1.scale;clear lt1
    r2=lt2.size; c2=lt2.dat; s2=lt2.scale;clear lt2
    c1=reshape(c1,[r1(1),prod(s1),r1(2)]);
    c1=permute(c1,[2,1,3]);
    c1=reshape(c1,[numel(c1)/r1(2),r1(2)]);
    c2=reshape(c2,[r1(2),numel(c2)/r1(2)]);
    c=c1*c2;
    
    c=reshape(c,[s1',r1(1),s2',r2(2)]);
    if l>1
        index=[l+2:2*l+1;1:l];
        index=[l+1;index(:);2*l+2];
        c=permute(c,index);
    else
        c=permute(c,[2,3,1,4]);
    end
    lt=layer_tensor;
    lt.dat=c(:);
    lt.size=[r1(1);r2(2)];
    lt.scale=s1.*s2;
    
    return
end




if (nargin>2)
    d=nargin;
    lt=varargin{1};
    for i=2:d
        lt=lkron(lt,varargin{i});
    end
    return
end



end





