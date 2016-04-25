# QTT-Toolbox  Version 1.0

更新记录：

2016.04.25：

-----------------------------------------------------

1. 添加QTT数组类：qttarray

2. 仅依赖layer_tensor类，与QTT文件夹的函数相互独立. 由于时间关系，作者短时间内可能不会
花大精力维护该文件夹，因为其虽然使用起来很方面，但太高级，不太适合大家自定义。

3. 已重载
>* `+`： c+c,c+2,2+c
>* `*`： 数乘和张量乘法
>* `-`:  减法	 
>* `.*`： 点乘
>* `full`： 还原成数组
>* `qtt2tt`：转化成tt-toolbox中的类

2016.04.21：

-----------------------------------------------------

1. 优化了部分函数的逻辑和性能，如`layer_tensor`, `lktimes`

2. 完善了`toeplitz_qtt`函数

3. 分治策略的`lqtt`函数暂时撤下了，细节部分还待完善.

4. 新增函数`imagesc_qtt` :QTT分解在各个尺度下的能量谱

2016.04.05 ：

-----------------------------------------------------

1. 大更新，修复了一些小bug，增加了很多QTT函数.



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
      lt=layer_tensor(A); % 或者
	  lt=layer_tensor(A(:),[2;5],[3;4]); %给定大小和子模数
      % 方法二：
      A=cell(2,5);
      for i=1:2
          for j=1:5
              A{i,j}=zeros(3,4);
          end
      end
      lt=layer_tensor(A);
   ```

   - **元素引用和赋值**
     用圆括号引用子张量, 用大括号引用元素矩阵(见论文).

   ```MATLAB
      r=lt.size; %分层张量的大小
      subsize=lt.subsize; %分层张量的子模数
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
     >* `ltqr`： 分层张量的QR分解，[ltr,ltq]=ltqr(lt);使得ltq是一个右正交的分层张量.
     >* `ltextend`:适用于分层张量的延拓函数


   =============================================
 2.**QTT分解**

   张量的基本运算（见文件夹Tensor）：
   >* `nkron`: 张量的Kronecker乘法，要求两个张量的维数相同
   >* `outer`：张量的外积
   >* `gtimes`:张量的广义乘法

   QTT分解函数：
	 >* `lqtt`： 适用于任意分层张量的QTT分解，同时也支持多维数组.采用方法：分治策略

   QTT 还原函数：
   >* `full_qtt`:将一组QTT核还原成一个分层张量，配合double可以还原成多维数组.

   QTT round 函数：
   >* `round_qtt`:将一组不满足右正交化得QTT核 右正交化，且使得QTT秩变小.

   QTT 相关运算函数：
   >* `plus_qtt`:两组QTT核的加法.
   >* `gtimes_qtt`:两组QTT核的广义乘法
   >* `hadamard_qtt`:两组QTT核的点乘

   工具箱转化函数：

   TT-Toolbox 的两个类终于可以相互转化成本工具箱的QTT啦
   >* `qtt2tt`:
   >* `tt2qtt`:


   其他函数：
   >* `info_qtt`:获取QTT分解的相关信息，如QTT秩，等效秩erank，元素个数等.
   >* `split_qtt`:获取QTT分解的QTT分量
   >* `rand_qtt`: 根据给定的子模数subsizes和QTT秩，生成一组随机的QTT核
   >* `toeplitz_qtt`:生成QTT格式的Toeplitz矩阵
   >* `hankel_qtt` :生成QTT格式的Hankel张量
   >* `imagesc_qtt` : QTT分解在各个尺度下的能量谱




   使用方法：
  ```MATLAB
     x=rand(6^5,1);y=2*x+rand(6^5,1)*0.1;
     A={x;y};
     A=layer_tensor(A);
     ltcore=lqtt(A,ones(5,1)*6,1e-4);

     A1=full_qtt(ltcore);
     X=ltsplit(clkron(ltcore(1:3)),clkron(ltcore(4:5)),'kron');
  ```
