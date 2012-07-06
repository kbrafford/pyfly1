import os.path, platform
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy

#bits,foo = platform.architecture()

#
# Build the pyd with python setup.py build_ext --inplace
#
desc = """This is Keith Brafford's first attempt at
a wrapper for the FlyCapture v1 C API.
"""

INCLUDEDIR = r'../include'
LIBDIR = r'../lib'

setup(
    name = 'pyfly1',
    version = '0.1',
    description = desc,
    cmdclass = {'build_ext': build_ext},                  
    #packages = [''],
    ext_modules = [Extension("pyfly1",
                             ["pyfly1.pyx"],
                             include_dirs = [".",
                                             INCLUDEDIR,
                                             numpy.get_include(),
                                             ],
                             extra_compile_args = [],
                             extra_link_args = [],
                             libraries = ['PGRFlyCapture'],
                             library_dirs = [LIBDIR]
                             )
                   ],
    )