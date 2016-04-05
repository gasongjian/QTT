function [X]=split_qtt(lt1,lt2,varargin)
%split_qtt get the component of a  array in qtt format
%  spit_qtt function split a group layer_tensors.
%  
%  split_qtt(lt1,lt2[,ltN],'kron');
%  lt1 and ltN are layer_tensor. If one is double array, it will be convent
%  to layer_tensor. Function return cell array.
%
%  split_qtt(lt1,lt2[,ltN],'outer');
%
%  Example:
%    A=mat2gray(imread('circuit.tif'));%280*272   
%    ltcore=lqtt(A,[140,136;2,2],1e-8);
%    X=split_qtt(ltcore{1},ltcore{2},'kron'); 
%    imshow(mat2gray(X{2}))
%
%  see also lqtt

%  JSong,11-Aug-2015
%  Last Revision: 17-Mar-2016.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com



if ~isa(lt1,'layer_tensor')
    lt1=layer_tensor(lt1(:),[1;1],size(lt1));
end

if (nargin>3)&&(ischar(varargin{end}))
    times_type=varargin{end};
    lt=[{lt1,lt2},varargin(1:end-1)];
else
    times_type='kron';
    lt=[{lt1,lt2},varargin];
end

l=numel(lt1.subsize);
r0=lt1.size;
clear lt1 lt2
d=length(lt);
r=zeros(d+1,1);
scale=zeros(d,l);
r(1)=r0(1);
for i=1:d
    if ~isa(lt{i},'layer_tensor')
        lt{i}=layer_tensor(lt{i}(:),[1;1],size(lt{i}));
    end
    r0=size(lt{i});
    if r0(1)~=r(i)
        disp('The size of input layer_tensor does not match!')
        return
    end
    scale(i,:)=(lt{i}.subsize)';
    r(i+1)=r0(2);
end

index_scale=r(2:end-1);
index=zeros(d+1,1);
n=prod(index_scale);
X=cell(n,1);


switch times_type
    case {'kron','lkron','KRON'}
        newscale=prod(scale,1);
        ltn=r(1)*r(d+1)*prod(newscale(:));
        ltt=layer_tensor(zeros(ltn,1),[r(1);r(d+1)],newscale');
        
        
        for i=1:n
            ii=i-1;
            index(d)=mod(ii,index_scale(d-1))+1;
            for j=d-1:-1:2
                ii=floor(ii/index_scale(j));
                index(j)=mod(ii,index_scale(j-1))+1;
            end
            
            for ri=1:r(1)
                for rj=1:r(d+1)
                    index(1)=ri;index(d+1)=rj;
                    tmp=nkron(lt{1}(index(1),index(2)),lt{2}(index(2),index(3)));
                    for k=3:d
                        tmp=nkron(tmp,lt{k}(index(k),index(k+1)));
                    end
                    ltt(ri,rj)=tmp;
                end
            end
            
            if r(1)*r(d+1)==1
                X{i}=double(ltt);
            else
                X{i}=ltt;
            end
        end
        
    case {'outer'}
        newscale=scale';newscale=newscale(:);
        ltn=r(1)*r(d+1)*prod(newscale(:));
        ltt=layer_tensor(zeros(ltn,1),[r(1);r(d+1)],newscale);
        
        
        for i=1:n
            ii=i-1;
            index(d)=mod(ii,index_scale(d-1))+1;
            for j=d-1:-1:2
                ii=floor(ii/index_scale(j));
                index(j)=mod(ii,index_scale(j-1))+1;
            end
            
            for ri=1:r(1)
                for rj=1:r(d+1)
                    index(1)=ri;index(d+1)=rj;
                    tmp=outer(lt{1}(index(1),index(2)),lt{2}(index(2),index(3)));
                    for k=3:d
                        tmp=outer(tmp,lt{k}(index(k),index(k+1)));
                    end
                    ltt(ri,rj)=tmp;
                end
            end
            
            if r(1)*r(d+1)==1
                X{i}=double(ltt);
            else
                X{i}=ltt;
            end
        end
        
end


end
