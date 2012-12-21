from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(
    name='chll',
    version='0.1',
    description='cython HyperLogLog implementation compatible with java stream-lib',
    author='Anton Bobrov',
    author_email='bobrov@vl.ru',
    url='https://github.com/baverman/chll',
    cmdclass = {'build_ext': build_ext},
    ext_modules = [Extension("chll", ["chll.pyx"], libraries=["m"])]
)