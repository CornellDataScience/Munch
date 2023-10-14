#!/usr/bin/env python
# coding: utf-8

# In[30]:

from PIL import Image
import sys


im = Image.open(sys.argv[1])

im1 = im.crop((int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5])))
im1.show()
