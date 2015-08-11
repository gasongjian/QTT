# QTT-Toolbox  Version 1.0



-----

## **QTT分解介绍**

   QTT（Quantics Tensor Train）分解是一种适用于任意分层张量(包含多维数组)的张量分解方法, 通过对数组的反复折叠该分解可以达到降维和特征提取的作用。QTT已被证明是一种基于流形学习的降维工具和多尺度的特征提取工具。

   **定义：**给定一个分层张量(包含向量、矩阵等多维数组)A，如果其有如下表示，

   ![](http://latex.codecogs.com/gif.latex?\\qquad A=U_1 \\bowtie U_2 \\bowtie \\cdots \\bowtie U_d)
   
其中后面d-1个QTT核满足右正交条件, 则称之为A的QTT分解。

## **工具箱介绍**
 
 这是一个用MATLAB语言写的QTT-Toolbox，免费提供大家使用,使用后请注明引用,谢谢。工具箱将分层张量新定义成了一个类，分层张量之间的大部分运算都已实现。通过这个模块化编程，我们能更加简单的扩展编程。如果读者发现函数有bug或者实现算法能加速，请邮件告之作者，谢谢。

=============================================

JSong,20-Jul-2015

Last Revision: 11-Aug-2015.

Github:http://github.com/gasongjian/QTT/

citition: *基于量子化张量列(QTT)模型的特征提取*

=============================================
 
 1. 自定义类 **layer_tensor**(分层张量)
   不同于TT-Toolbox, QTT-Toolbox中每一个QTT核以分层张量的形式存储, QTT分解相当于将以一个多维数组分解成多个分层张量的某种乘积。
   
   目前分层张量已经实现如下功能：l打头的代表外层用矩阵乘法,lk打头代表外层用kronecker乘积，u打头代表算子作用于子张量。
   
   - **初始化**
   
   ```MATLAB
      A=rand(2,3,4,5);%一个大小为2*5，子模数为3*4的分层张量
      lt=layer_tensor(A);
	  lt=layer_tensor(A(:),[2;5],[3;4]); %给定大小和子模数
   ```
   
   - **元素引用和赋值**
     用圆括号引用子张量, 用大括号引用元素(见论文).
   
   ```MATLAB
      r=lt.size;
      scale=lt.scale;
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
   
      利用该运算，可以简单实现两个QTT格式下的矩阵之间的乘法。
   
   ```MATLAB
      lktimes(lt1,lt2,types);
	  % 可验证下面两个表达式相等
	  L1=lktimes(lkron(lt1,lt2),lkron(lt3,lt4),types);
	  L2=lkron(lktimes(lt1,lt3,types),lktimes(lt2,lt4,types));
	  isequal(L1,L2)
   ```
   
   - **其他**
   
     >* `double`：转换成多维数组, 如果大小为1, 则转化为子张量
	 >* `size`：  默认返回分层张量的大小,如上例中的[2;5]
     >* `ctranspose`: 外转置, lt1=lt'; 则lt1大小为5*3*4*2；	 
	 >* `utranspose`： 内转置, 如果子张量是矩阵，则转置所有子张量
	 >* `udiag`：    内对角化, 子张量是向量或者矩阵
     >* `lt2cell`：  将分层张量转化为2*5的cell, 每一个cell内都是一个子张量
	 >* `ltfun` ：   类似于cellfun,非常实用的函数。 矩阵情形中ltfun(lt,@(x)x',[4;3])等价于utranspose
     >* `minus`,`plus`： 加法和减法

   =============================================
 2.**QTT分解**

   张量的基本运算：
   >* `nkron`: 张量的Kronecker乘法，要求两个张量的维数相同
   >* `outer`：张量的外积
   >* `gtimes`:张量的广义乘法
   
   QTT分解函数：
     >* `qtt`：适用于多维数组的QTT分解
	 >* `gqtt`： 适用于任意分层张量的QTT分解，同时也支持多维数组.采用方法：循环
   
   其他函数：
   >* `qtt2ltcore`:将qtt返回的结构体转化成gqtt函数的输出格式
   >* `ltsplit`:获取QTT分解的QTT分量
   >* `clkron`: 适用于元胞的lkron函数，可用于QTT格式的还原
   >* `ltextend`:适用于分层张量的延拓函数
   >* `demo_feature_detection` :一个简单的例子
   
   
   
   
   使用方法：
  ```MATLAB
     x=rand(6^5,1);y=2*x+rand(6^5,1)*0.1;
     A=[x';y'];
     A=layer_tensor(A(:),[2;1],[6^5]);
     ltcore=gqtt(A,[6;6;6;6;6],1e-4,'sym');
     
     A1=clkron(ltcore);
     X=ltsplit(clkron(ltcore(1:3)),clkron(ltcore(4:5)),'kron');
  ```
 
 
 
 
 
 
 





