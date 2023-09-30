# -*- coding: utf-8 -*-
"""
Created on Sun Aug 13 21:31:41 2023

@author: QC109_4
python CythonSetup.py build_ext --inplace --force > EX_cython.cpp
"""
from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("EX_cython2.py", annotate=True)
)
