#!/usr/bin/env python
#! -*- coding: utf-8 -*-

import numpy as np
import sys

fileread=open(sys.argv[1], 'r')

x=[]
y=[]
for line in fileread:
 x1,y1=line.split()
 x.append(float(x1))
 y.append(float(y1))
xmed=0
ymed=0
for i in xrange(0,len(x)):
 xmed=xmed+x[i]/len(x)
 ymed=ymed+y[i]/len(x)

filewrite=open(sys.argv[2],'w')
filewrite.write(str(xmed) + '   ' + str(ymed) + '\n')
