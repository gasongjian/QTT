function e=imagesc_qtt(c)
d=length(c);
l=length(c{1}.subsize);
e=cell(d-1,4); %按列存储：尺度, 秩，最大秩，能量谱
subsizes=zeros(d,l);
for i=1:d-1
    if i==1
        cn=c{i};
    else
        cn=lkron(cn,c{i});
    end
    
    subsizes(i,:)=(c{i}.subsize)';
    r=cn.size;
    e{i,2}=r(2);
    nlp=ltfold(cn,'l');%能量谱
    nlp=sum(nlp.^2,1);
    nlp=nlp/sum(nlp);
    e{i,4}=(nlp(:))';
end
subsizes(d,:)=(c{d}.subsize)';

maxr=max(cell2mat(e(:,2)));
een=max(1024,maxr);
ee=zeros(d-1,een);
for i=1:d-1
    subsize1=prod(subsizes(1:i,:),1);
    subsize2=prod(subsizes(i+1:d,:),1);
    e{i,3}=min(prod(subsize1(:)),prod(subsize2(:)));
    e{i,1}=(subsize2(:))';
    t=e{i,4}(junfen(een,e{i,2}));
    %t=kron(e{i,4},ones(1,floor(maxr/e{i,2})));
    ee(i,:)=t;
end
e=e(end:-1:1,:);
ee=ee(end:-1:1,:);
%ee1=kron(ee,ones(floor(een/(d-1)),1));
%ee1=1./(1+exp(0.5-ee1));
imagesc(1:maxr,1:d-1,ee)
colorbar
ax=gca;
ytick=cell(1,d-1);
for i=1:d-1
    yticktmp=sprintf('%d\\times ',e{i,1});
    yticktmp(end-6:end)=[];
    ytick{i}=[yticktmp,'(',num2str(e{i,2}),',',num2str(e{i,3}),')'];
end
set(ax,'Layer','top','YTickLabel',ytick);
title('QTT分解各尺度下的能量谱');
end


function ind=junfen(nn,n)
% 在nn个数差不多均分为n类，返回索引指标
g=floor(nn/n);
sxd=nn-n*g;%剩下的
ind1=zeros(1,n);
ind1(randperm(n,sxd))=1;
ind1=ind1.*(1:n);
ind=[repmat(1:n,g,1);ind1];
ind=ind(:);
ind(ind==0)=[];
end   