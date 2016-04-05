% test

filename='test1.jpg';
A=double(imread(filename));
[m,n,k]=size(A);%3376*3376
m=floor(m/2)*2;
n=floor(n/2)*2;
A=A(1:m,1:n,:);
A1=cell(3,1);
A1{1}=A(:,:,1);
A1{2}=A(:,:,2);
A1{3}=A(:,:,3);
A1=layer_tensor(A1);

subsizes=[m/2,n/2;2,2];
%A1=ltextend(A1,subsizes);
c=lqtt(A1,subsizes,1e-8);
ca1=c{1}(1,1);
if mean(ca1(:))<0
    c{1}=-1*c{1};
    c{2}=-1*c{2};
end
d=cell(4,1);
for i=1:4
    d{i}(:,:,1)=c{1}(1,i);
    d{i}(:,:,2)=c{1}(2,i);
    d{i}(:,:,3)=c{1}(3,i);
end  
d{1}=mat2gray(d{1});
%imwrite(mat2gray(d{1}),'test1_main.jpg')
for i=1:3
tmp=abs(d{i+1});
t=mean(tmp(:))+3*std(tmp(:));
tmp=1-mat2gray(tmp,[0,t]);
d{i+1}=tmp;
%imwrite(tmp,['test1_edge',num2str(i),'.jpg']);
end

w=30;
D=ones(m+w,n+w,3);

for i=1:2
    for j=1:2
        ii=m/2*(i-1)+w*(i-1)+1:m/2*i+w*(i-1);
        jj=n/2*(j-1)+w*(j-1)+1:n/2*j+w*(j-1);
        D(ii,jj,:)=d{2*j+i-2};
    end
end
imwrite(D,'test1_qtt1.jpg');


%% Á½²ã·Ö½â

subsizes=[m/4,n/4;2,2;2,2];
%A1=ltextend(A1,subsizes);
c=lqtt(A1,subsizes,1e-8);
ca1=c{1}(1,1);
if mean(ca1(:))<0
    c{1}=-1*c{1};
end
r1=c{1}.size;
d=cell(r1(2),1);
for i=1:r1(2)
    d{i}(:,:,1)=c{1}(1,i);
    d{i}(:,:,2)=c{1}(2,i);
    d{i}(:,:,3)=c{1}(3,i);
end
d{1}=mat2gray(d{1});
%imwrite(mat2gray(d{1}),'test1_qtt2_main.jpg')
for i=1:r1(2)-1
tmp=abs(d{i+1});
t=mean(tmp(:))+3*std(tmp(:));
tmp=1-mat2gray(tmp,[0,t]);
d{i+1}=tmp;
%imwrite(tmp,['test1_qtt2_edge',num2str(i),'.jpg']);
end

w=25;
D=ones(3376+3*w,3376+3*w,3);

for i=1:4
    for j=1:4
        ii=844*(i-1)+w*(i-1)+1:844*i+w*(i-1);
        jj=844*(j-1)+w*(j-1)+1:844*j+w*(j-1);
        D(ii,jj,:)=d{4*j+i-4};
    end
end
imwrite(D,'test1_qtt2.jpg');
        









