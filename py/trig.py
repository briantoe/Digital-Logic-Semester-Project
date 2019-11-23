#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
from sys import argv

def binary_string(value):
    if value < 0:
        value += 2**16
    binary = bin(value)[2:]
    return '0'*(16 - len(binary)) + binary

np.seterr(divide='ignore')
theta = np.linspace(0, 2*np.pi, num=360)
csc = np.clip(100/np.sin(theta), -2**15, 2**15-1).astype(int)
sec = np.clip(100/np.cos(theta), -2**15, 2**15-1).astype(int)

if len(argv) < 2:
    print('missing filename')
    exit(1)

with open(argv[1], 'w') as output:
    for c,s in zip(csc,sec):
        output.write(binary_string(c) + '\n')
        output.write(binary_string(s) + '\n')
