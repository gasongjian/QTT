% DEMO of Feature Detection

%  JSong,12-Jul-2015
%  Last Revision: 11-Aug-2015.
%  Github:http://github.com/gasongjian/QTT/
%  gasongjian@126.com

%% Image 

A=im2double(imread('circuit.tif'));%280*272
ltcore=gqtt(A,[70,68;2,2;2,2],1e-6,'sym');
% coef 
C=cell(2);
ltcore1=lkron(ltcore{1},ltcore{2});
for i=1:4
    C{i}=mat2gray(ltcore1(1,i));
end
C=cell2mat(C);
figure
imshow(C)

% wavelet 
W=cell(4);
ltcore1=lkron(ltcore{2},ltcore{3});
for i=1:16
    W{i}=mat2gray(ltcore1(i,1));
end
W=cell2mat(W);
figure
imshow(W)

% QTT Components
X=ltsplit(ltcore{1},ltcore{2},ltcore{3},'kron');
CC=cell(2);
for i=1:4
    CC{i}=mat2gray(X{i});
end
CC=cell2mat(CC);
figure
imshow(CC)

