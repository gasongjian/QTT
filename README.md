# QTT-Toolbox  Version 0.1



-----

 - **QTT分解介绍**

 QTT（Quantum TensorTrain）分解是一种适用于多维数组的张量化分解方法，是SVD分解的一种推广。通过对数组的多次折叠该分解可以达到提取数组局部特征的目的，而且基于SVD的分解算法已经有论文阐述了其与小波变换之间的关系。

**定义：**给定一个多维数组(向量、矩阵或者三维数组等)A，如果其有如下表示，则称之为A的QTT分解

   ![](http://latex.codecogs.com/gif.latex?\\qquad A=U_1 \\bowtie U_2 \\bowtie \\cdots \\bowtie U_d)

- **工具箱介绍**

暂时只提供基本的qtt分解函数，使用方法为：

```MATLAB
    t=qtt(A,2,1e-14,'sym');
	core=t.core;
```
