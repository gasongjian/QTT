# -*- coding: utf-8 -*-
import numpy as np
import math
import matplotlib.pyplot as plt

'''python 操作符
Method        	Overloads        	Call for
__init__        构造函数        	X=Class()
__del__        	析构函数        	对象销毁
__add__  radd,iadd     	+                	X+Y,X+=Y
__or__        	|                	X|Y,X|=Y
__repr__        打印转换        	print X，repr(X)
__str__        	打印转换        	print X，str(X)
__call__        调用函数        	X()
__getattr_   	限制            	X.undefine
__setattr__    	取值            	X.any=value
__getitem__    	索引            	X[key]，
                            
__len__        	长度            	len(X)
__cmp__        	比较            	X==Y,X<Y
__lt__        	小于            	X<Y
__eq__        	等于            	X=Y
__radd__        Right-Side +        	+X
__iadd__        +=                	X+=Y
__iter__        迭代            	For In 
'''



class ltensor:
    '''构造函数
    分层张量类,含有三个属性
    .dat		:  分层张量的数据,按列存储的一维numpy数组
    .shape		:  分层张量的模数
    .subshape	:  分层张量的子模数
    '''
    def __init__(self,a=None,shape=None,subshape=None,order='F'):
        if a is None:
            self.dat=np.array([])
            self.shape=(0L,)
            self.subshape=(0L,)
            self.order=order
            self.size=0
            return
        # 只给定数组a
        if (shape is None ) and (subshape is None):
            # a 是一个numpy生成的数组，转换成1*1的分层张量, 且子模数为a的shape
            if isinstance(a,np.ndarray):
                #self.dat=a.ravel(order=order)               
                self.dat=a.reshape((1,)+a.shape+(1,),order=order)
                shape=(1L,1L)
                subshape=a.shape
            # a 是一个类matlab元胞的列表，列表中包含相应位置的子张量
            elif isinstance(a,list):
                if isinstance(a[0],list):
                    subshape=a[0][0].shape
                    shape=(long(len(a)),long(len(a[0])))
                    len_subshape=len(subshape)
                    self.dat=np.asarray(a).transpose([0,]\
                    +range(2,len_subshape+2)+[1,])
                else:
                    shape=(1L,long(len(a)))
                    subshape=a[0].shape
                    len_subshape=len(subshape)
                    self.dat=np.asarray(a).transpose(range(1,len_subshape+1)\
                    +[0,]).reshape((1,)+subshape+(len(a),))
            else:
                print '参数错误'
                return
        # 给定了模数和子模数，此时a 按照相应顺序展平用
        else:
            newshape=(shape[0],)+subshape+(shape[1],)
            if newshape==a.shape:
                self.dat=a
            else:
                self.dat=a.reshape(newshape,order=order)
        self.dat=np.float64(self.dat)
        self.shape=shape
        self.subshape=subshape
        self.size=self.dat.size
        self.order=order

    def __len__(self):
        return len(self.shape)

    def tolist(self):
        if self.shape[0]==1:
            lt=[]
            for i in range(self.shape[1]):
                lt.extend([self[0,i]])
        else:
            lt=[]
            for i in range(self.shape[0]):
                lt.extend([list(self[i,:])])
        return lt

    
    # 分层张量的索引
    def __getitem__(self,index):
        # index 如果长度大于1，则是一个tuple. index元素若为2:4,则为slice对象，否则就是整数                     
        if type(index) is not tuple:
            if self.shape[0]==1:
                index=(0,index)
            else:    
                index=(index,slice(self.shape[-1]))
        si=':,'*len(self.subshape)        
        exec('dat=self.dat[index[0],'+si+'index[1]]')
        # 索引的是子张量
        if isinstance(index[0],int) and isinstance(index[1],int):
            return dat
        elif isinstance(index[0],int) and type(index[1]) is slice:           
            newshape=(1,)+self.subshape+dat.shape[-1:]
            dat=dat.reshape(newshape,order=self.order)
            return ltensor(dat,(dat.shape[0],dat.shape[-1]),self.subshape,self.order)
        elif isinstance(index[1],int) and type(index[0]) is slice:
            newshape=dat.shape[0:1]+self.subshape+(1,)          
            dat=dat.reshape(newshape,order=self.order)
            return ltensor(dat,(dat.shape[0],dat.shape[-1]),self.subshape,self.order)
        else:
            newshape=dat.shape[0:1]+dat.shape[-1:]
            return ltensor(dat,newshape,self.subshape,self.order)

    def __setitem__(self,index,value):
        # 赋值运算
        if type(index) is not tuple:
            if self.shape[0]==1:
                index=(0,index)
            else:    
                index=(index,slice(self.shape[-1]))
        si=':,'*len(self.subshape)
        data=self.dat
        if (type(index[0]) is slice) or (type(index[1]) is slice):
            value=value.dat
        exec('data[index[0],'+si+'index[1]]=value')
        self.dat=data
        return self

    #Print statement
    def __repr__(self):
        res = "This is a %d * %d layer tensor." % (self.shape[0],self.shape[1])
        return res
    # 一些基本的运算
    def __add__(self,lt2):
        if isinstance(lt2,ltensor):
            dat=self.dat+lt2.dat
            return ltensor(dat,self.shape,self.subshape)
        else:
            return ltensor(self.dat+lt2,self.shape,self.subshape)            
    
    def __radd__(self,lt2):
        return self+lt2
    
    def __mul__(self,lt2):
        return ltensor(self.dat*lt2,self.shape,self.subshape)
    
    def __rmul__(self,lt2):
        return ltensor(self.dat*lt2,self.shape,self.subshape)
        
    def __sub__(self,lt2):
        return self+(-1)*lt2

    def __rsub__(self,lt2):
        return (-1)*(self-lt2)
        
    def __neg__(self):
        return (-1)*self
    # 外层的转置    
    def T(self):
        print '外层的转置，待写'        
        return self
        
    # 内层的装置
    def uT(self):
        print '内层转置，待些'
        return self
        

def lkron(lt1,lt2):
    if not isinstance(lt1,ltensor):
        lt1=ltensor(lt1)
    if not isinstance(lt2,ltensor):
        lt2=ltensor(lt2)
    l=len(lt1.subshape)
    s=tuple(np.array(lt1.subshape)*np.array(lt2.subshape))
    r=(lt1.shape[0],lt2.shape[1])
    c=np.tensordot(lt1.dat,lt2.dat,(-1,0))
    index=np.vstack((np.arange(l+1,2*l+1),np.arange(1,l+1))).ravel(order='F')
    index=[0,]+list(index)+[2*l+1,]
    c=c.transpose(index).reshape(r[0:1]+s+r[-1:],order='F')
    lt=ltensor()
    lt.dat=c
    lt.shape=r
    lt.subshape=s
    return lt

def lqtt(lt,subshapes,eps=1e-14,state=''):

#    def my_chop2(sv,eps):
#        # from TT-toolbox
#        if np.linalg.norm(sv)==0:
#            return 1
#        sv0=np.cumsum(sv[::-1]**2)
#        r=sv.shape[0]-np.sum(sv0<eps**2)
#        return r

    # to ltensor
    if not isinstance(lt,ltensor):
        lt=ltensor(lt)

    # Get basic inf
    if not isinstance(subshapes,np.ndarray):
        subshapes=np.asarray(subshapes)
    if subshapes.ndim==1:
        subshapes=subshapes.reshape(subshapes.shape+(1L,))
    r0=lt.shape
    l=len(lt.subshape)
    d=int(subshapes.shape[0])


    # stop condition
    if d==1:
        return [lt]

    #  one step decomposition
    subshapes1=subshapes[0:(int((d+1)/2)),:]
    subshapes2=subshapes[(int((d+1)/2)):,:]
    ltscale1=np.vstack((np.prod(subshapes1,0),np.prod(subshapes2,0)))
    index=tuple(ltscale1[::-1,:].ravel(order='F'))
    lt=lt.dat.reshape(r0[0:1]+index+r0[-1:],order='F')
    index2=tuple(range(2,2*l+1,2)+[0L,]+range(1,2*l+2,2))
    lt=lt.transpose(index2)

    lt=lt.reshape((np.prod(ltscale1[0,:])*r0[0],np.prod(ltscale1[1,:])*r0[1]))
     # svd
    (u,s,v)=np.linalg.svd(lt,full_matrices=False)

    #-----------------------------------------------------------------------
    #%r1=my_chop2(s,eps*norm(s))
    normofs=np.linalg.norm(s)
    if state is '':
        eps1=eps*normofs/math.ceil(math.log(d,2))
        sv0=np.cumsum(s[::-1]**2)
        r1=s.shape[0]-np.sum(sv0<eps1**2)
        #r1=my_chop2(s,eps1)
        eps2=eps

    elif 'r' not in state:
        sv0=np.cumsum(s[::-1]**2)
        r1=s.shape[0]-np.sum(sv0<eps**2)
        #r1=my_chop2(s,eps)
        eps1=eps
        eps2=eps*5/normofs
    else:
        # maybe need modification
        #r1=np.linalg.rank(diag(s));
        sv0=np.cumsum(s[::-1]**2)
        r1=s.shape[0]-np.sum(sv0<(eps*normofs)**2)
        #r1=my_chop2(s,eps*normofs)
        eps1=eps
        eps2=eps
    #-----------------------------------------------------------------------
    v=v[0:r1,:]
    v=v.reshape((r1,)+tuple(ltscale1[1,:])+(r0[1],))
    v=ltensor(v,(r1,r0[1]),tuple(ltscale1[1,:]),order='F')

    u=np.dot(u[:,0:r1],np.diag(s[0:r1]))
    u=u.reshape((np.prod(ltscale1[0,:]),r0[0],r1))
    u=u.transpose((1,0,2))
    u=u.reshape((r0[0],)+tuple(ltscale1[0,:])+(r1,))
    u=ltensor(u,(r0[0],r1),tuple(ltscale1[0,:]),order='F')
    state1=state+'l'
    state2=state+'r'
    ltcore=lqtt(u,subshapes1,eps1,state1)+lqtt(v,subshapes2,eps2,state2)
    return ltcore
    
#class qttarray:
#    '''
#    QTT数组
#    张量数据结构
#    待写,有一堆东西    
#    '''
#
#    def __init__(self,a=None,subshapes=2L,eps=1e-14):
#        if a is None:
#            self.core=[]
#            self.r=(0L,)
#            self.d=0
#            self.subshapes=(0L,)
#            self.size=0L
#            return
#        if type(a)==list and len(a)>1:
#            self.core=a
#            d=len(a)
#            r=[a[0].shape[0]]
#            subshapes=[]
#            for i in range(d):
#                r=r+[a[i].shape[1]]
#                subshapes=subshapes+[a[i].subshape]
#            subshape=np.array(subshapes)
#            self.d=d
#            self.r=r
#            self.subshapes=subshapes
#            return
#        shape=a.shape
        
                
                
            








    
    
    
    
       