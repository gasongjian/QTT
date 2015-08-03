# QTT-Toolbox  Version 0.1



-----

 - **QTT分解介绍**

   QTT（Quantized Tensor Train）分解是一种适用于多维数组的张量化分解方法，是SVD分解的一种推广。通过对数组的多次折叠该分解可以达到提取数组局部特征的目的，而且基于SVD的分解算法已经有论文阐述了其与小波变换之间的关系。

   **定义：**给定一个多维数组(向量、矩阵或者三维数组等)A，如果其有如下表示，则称之为A的QTT分解

   ![](http://latex.codecogs.com/gif.latex?\\qquad A=U_1 \\bowtie U_2 \\bowtie \\cdots \\bowtie U_d)
   
   注：现已更新，对任意一个子模数合适的分层张量，都存在这样一种QTT分解.

 - **工具箱介绍**
 
 1. 自定义类 layer_tensor(分层张量)
   不同于TT-Toolbox, QTT-Toolbox中每一个QTT核以分层张量的形式存储, QTT分解相当于将以一个多维数组分解成多个分层张量的某种乘积, 这种模块化操作后, 扩展编程变得简单得多。
   
   目前分层张量已经实现如下功能：l打都的代表外层用矩阵乘法,lk打头代表外层用kronecker乘积，u打头代表算子作用于子张量。
   
   - **初始化**
   
   ```MATLAB
      A=rand(2,3,4,5);%一个大小为2*5，子模数为3*4的分层张量
      lt=layer_tensor(A);
	  lt=layer_tensor(A(:),[2;5],[3;4]); %给定大小和子模数
   ```
   
   - **元素引用和赋值**
     用圆括号引用子张量, 用大括号引用矩阵元素(见论文).
   
   ```MATLAB
      A=lt(1,2);
	  A=lt(1:2,5);
	  A=lt{3,4};
	  lt(1,1)=A;
   ```
   
   - **分层kronecker乘积**
   
      为加快速度，本工具箱将该运算转化成了矩阵乘法，再经过一定的置换得到新的分层张量，具体可参见论文。
   
   ```MATLAB
      lt=lkron(lt1,lt2);
      % lt(1,1)=\sum kron(lt1(1,i),lt2(i,1))
   ```
   
   - **分层外积**
   
      为加快速度，该运算的实现利用了矩阵乘法和一定的置换, 具体可参见论文。
   
   ```MATLAB
      louter(lt1,lt2);
   ```
   
   
   - **广义张量积**
   
      利用该运算，可以简单实现两个QTT格式的矩阵之间的乘法。
   
   ```MATLAB
      lktimes(lt1,lt2,types);
	  % 可验证下面两个表达式相等
	  L1=lktimes(lkron(lt1,lt2),lkron(lt3,lt4),types);
	  L2=lkron(lktimes(lt1,lt3,types),lktimes(lt2,lt4,types));
	  isequal(L1,L2)
   ```
   
   - **其他**
   
     >* `double`：转换成double数组, 如果秩为1, 则转化为子张量
	 >* `size`：  默认返回分层张量的大小,如上例中的[2;5]
     >* `ctranspose`: 外转置, lt1=lt'; 则lt1大小为5*3*4*2；	 
	 >* `utranspose`： 内转置, 如果子张量是矩阵，则转置所有子张量
	 >* `udiag`：    内对角化, 子张量是向量或者矩阵
     >* `lt2cell`：  将分层张量转化为2*5的cell, 每一个cell内都是一个子张量
	 >* `ltfun` ：   类似于cellfun, 矩阵情形中ltfun(lt,@(x)x',[4;3])等价于utranspose

 2.**QTT分解**
 
   暂时只提供基本的QTT分解函数(`qtt`,`gqtt1`,`gqtt2`).
   
     >* `qtt`：适用于多维数组的QTT分解
	 >* `gqtt1`：  适用于分层张量的QTT分解，同时也支持多维数.采用方法：循环
     >* `gqtt2`：  适用于分层张量的QTT分解，同时也支持多维数.采用方法：递归
   
   使用方法：
  ```MATLAB
    t=qtt(A,2,1e-6,'sym');
	core=t.core;
	
     x=rand(6^5,1);y=2*x+rand(6^5,1)*0.1;
     A=[x';y'];
     A=layer_tensor(A(:),[2;1],[6^5]);
     lt=gqtt2(A,[6;6;6;6;6],1e-4,'sym');
  ```
 
 
 
 
 
 
 





