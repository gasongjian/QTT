 function lt=layer_tensor(varargin)
%Layer_tensor  constructor
%
%  layer_tensor have three inner attributes, and it is stored as a vector with
%  size and scale. It can be regarded as multi-dimensional array of [size(1),
%  scale',size(2)]; For example, a layer_tensor A, A.size=[2;5],A.scale=[3;4],
%  then A can be regarded as a  tensor of 2*3*4*5.
%       .size  see [2;5]
%       .scale  see [3;4]
%       .dat    see A(:)
%
% ------------------------------------------------------------------------
%  LT=LAYER_TENSOR(ARRAY) Converts from multi-dimensional array,
%  ndims(array)>2;
%
%  LT=LAYER_TENSOR(MATRIX)  Converts from matrix, the size of lt is [1;1].
%
%  LT=LAYER_TENSOR(VECTOR,SIZE,SCALE)  Convert form vector, lt.size=size
%  lt.scale=scale;lt.dat=vector.
%
%  LT=LAYER_TENSOR(CELL_ARRAY)  the size of CELL_ARRAY is equal to lt.size,
%  the size of CELL_ARRAY{i} is equal to lt.scale.
%
% ------------------------------------------------------------------------
%  Now layer_tensor class have support many operations: plus,minus,
%  layer Kronecker product,layer outer product,layer general
%  times,subsref,subsasgn,udiag,transpose,ltcun etc.
%
%
%  JSong,20-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

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






