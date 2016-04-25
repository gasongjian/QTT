function c=uminus(c)
core=c.core;
core{1}=(-1)*core{1};
c.core=core;