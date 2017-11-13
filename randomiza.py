#!/usr/bin/env python
#! -*- coding: utf-8 -*-

import numpy as np
import random as rn
import sys

fileread=open(sys.argv[1], 'r')


x1=[]
y1=[]

for line in fileread:
 x,y=line.split()
 y1.append(float(y))
 x1.append(float(x))

for t in xrange(2,8):
 spread=0
 for i in xrange(1,7):
  filewrite=open(str(t)+'.'+str(i)+'.dat', 'w')
  spread=0.05*i
  for ii in xrange(0,len(y1)):
   y=float(y1[ii])+((-1)**rn.randint(0,10000)*float(y1[ii])*spread*rn.randint(0,10000)/10000)
   filewrite.write(str(x1[ii]) + '    ' + str(y) + '\n')
