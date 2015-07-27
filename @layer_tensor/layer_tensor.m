 function lt=layer_tensor(varargin)
% �Զ����ࣺ�ֲ�����
% �洢��ʽ�����ֲ���������һ������������洢������2*5��������СΪ3*4�ķֲ����������ǾͰ�������2*3*4*5������.
% ��������:
%          .size  ���������е�[2;5]
%          .scale ���������е�[3;4] 
%          .dat   ������,���������д洢����
%
% ����֧�ֲַ�kronecker�����Ӽ�����()��{}����,udiag,',uת�ã��ֲ�������������
%
%
%      @J.Song @2015.07.20 @1.0
%

%% from empty input
if (nargin == 0)
    lt.size = [];
    lt.scale=[];
    lt.dat=[];
    lt = class(lt,'layer_tensor');
    return;
end


%% from a layer_tensor
if (nargin==1)&&(isa(varargin{1},'layer_tensor'))
    lt=layer_tensor;
    lt.size=varargin{1}.size;
    lt.dat=varargin{1}.dat;
    lt.scale=varargin{1}.scale;
    return    
end


%% from a multi-dimensional array
if (nargin==1)&&(~ismatrix(varargin{1}))
    A=varargin{1};
    lt=layer_tensor;
    s=size(A);
    r=[s(1);s(end)];
    lt.size=r;
    lt.dat=A(:);
    lt.scale=s(2:end-1)';
    return
end

%% from  matrix
if (nargin==1)&&(ismatrix(varargin{1}))
    A=varargin{1};
    lt=layer_tensor;
    if isvector(A)
        scale=numel(A);
    else
        scale=size(A);
    end
    lt.size=[1;1];
    lt.dat=A(:);
    lt.scale=scale(:);
    return
end





%% from a vector and other parameters
if (nargin==3)&&(isvector(varargin{1}))&&(length(varargin{2})==2)
    lt=layer_tensor;
    dat=varargin{1};
    r=varargin{2};
    scale=varargin{3};
    lt.dat=dat(:);
    lt.size=r(:);
    lt.scale=scale(:);
    return
end

%% from a qtt format(not recommended)
if (nargin==1)&&(isa(varargin{1},'struct'))    
    t0=varargin{1};  
    d=t0.d;ps=t0.ps;r=t0.r;scale=t0.scale;
    lt=cell(d,1);
    for i=1:d
        lt{i}=layer_tensor(t0.core(ps(i):ps(i+1)-1),r(i:i+1),scale(i,:));        
    end
    return
end


%% from a cell
if (nargin==1)&&(iscell(varargin{1}))
    lt=varargin{1};
    r=size(lt);
    scale=size(lt{1});
    dat=cellfun(@(x)(x(:))',lt0,'UniformOutput',false);
    dat=cell2mat(dat);
    lt=layer_tensor;
    lt.dat=dat(:);
    lt.size=r(:);
    lt.scale=scale(:);  
end






