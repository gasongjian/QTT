 function lt=layer_tensor(varargin)
%Layer_tensor  constructor
% 。。。。。。
%
%  layer_tensor have three inner attributes, and it is stored as a vector with
%  size and subsize. It can be regarded as multi-dimensional array of [size(1),
%  subsize',size(2)]; For example, a layer_tensor A, A.size=[2;5],A.subsize=[3;4],
%  then A can be regarded as a  tensor of 2*3*4*5.
%       .size  see [2;5]
%       .subsize  see [3;4]
%       .dat    see A(:)
%
% ------------------------------------------------------------------------
%  LT=LAYER_TENSOR(ARRAY) Converts from multi-dimensional array,
%  ndims(array)>2;
%
%  LT=LAYER_TENSOR(MATRIX)  Converts from matrix, the size of lt is [1;1].
%
%  LT=LAYER_TENSOR(VECTOR,SIZE,SUBSIZE)  Converts form vector, lt.size=size
%  lt.subsize=subsize;lt.dat=vector.
%
%  LT=LAYER_TENSOR(CELL_ARRAY)  Converts form vector,the size of CELL_ARRAY is
%  equal to lt.size,the size of CELL_ARRAY{i} is equal to lt.subsize.
%
% ------------------------------------------------------------------------
%  Now layer_tensor class have support many operations: plus,minus,
%  layer Kronecker product,layer outer product,layer general
%  times,subsref,subsasgn,udiag,transpose,ltcun etc.
%
%
%  JSong,20-Jul-2015
%  Last Revision: 17-Nov-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com


%% from empty input
if (nargin == 0)
    lt.size = 0;
    lt.subsize=0;
    lt.dat=[];
    lt = class(lt,'layer_tensor');
    return;
end


%% from a layer_tensor
if (nargin==1)&&(isa(varargin{1},'layer_tensor'))
    lt=varargin{1};
    return
end

%% from a cell
if (nargin==1)&&(iscell(varargin{1}))
    lt=varargin{1};
    r=size(lt);
    subsize=size(lt{1});
    subsize=subsize(:);
    dat=cellfun(@(x)(x(:))',lt,'UniformOutput',false);
    dat=cell2mat(dat);
    lt=layer_tensor;
    lt.dat=dat(:);
    lt.size=r(:);
    lt.subsize=subsize(:);
    return
end

%% from  array
if (nargin==1)&&(isa(varargin{1},'double'))
    A=varargin{1};
    lt=layer_tensor;
    if isvector(A)
        subsize=numel(A);
        A=A(:);
    else
        subsize=size(A);
    end
    lt.size=[1;1];
    lt.dat=A(:);
    lt.subsize=subsize(:);
    return
end



%% from a multi-dimensional array
if (nargin==3)&&(isa(varargin{1},'double'))&&(length(varargin{2})==2)
    lt=layer_tensor;
    dat=varargin{1};
    r=varargin{2};
    subsize=varargin{3};
    if numel(dat)~=prod(r(:))*prod(subsize(:))
        disp('please check the arguments!')
        return
    end
    lt.dat=dat(:);
    lt.size=r(:);
    lt.subsize=subsize(:);
    return
end
