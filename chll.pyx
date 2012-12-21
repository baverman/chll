import sys
from math import pow, log
from array import array
from struct import Struct
from operator import or_

from libc.math cimport pow as cpow
cimport cython
cimport cpython.array

header = Struct('!ii')

POW_2_32 = pow(2, 32)
NEGATIVE_POW_2_32 = -POW_2_32

LOG2_BITS_PER_WORD = 6
REGISTER_SIZE = 5

@cython.boundscheck(False)
cdef fill_bits(int count, unsigned int[:] source, char[:] dest):
    cdef int j
    cdef int i
    cdef int shift
    
    j = 0
    for i in range(source.shape[0]):
        shift = 0
        while j < count and shift < 30:
            dest[j] = (source[i] & (0x1f << shift)) >> shift
            shift += 5
            j += 1

@cython.boundscheck(False)
cdef double calc_sum(char[:] view):
    cdef double result
    cdef int i

    result = 0

    for i in range(view.shape[0]):
        result += cpow(2, -view[i])

    return result

@cython.boundscheck(False)
cdef merge_sets(char[:] source, char[:] dest):
    cdef int i
    cdef char v

    for i in range(source.shape[0]):
        v = source[i]
        if v > dest[i]:
            dest[i] = v		


class HyperLogLog(object):
    def __init__(self, log2m, data):
        self.log2m = log2m
        self.data = data
        self.count = 2**log2m

        if log2m == 4:
            self.alpha_MM = 0.673 * self.count * self.count
        elif log2m == 5:
            self.alpha_MM = 0.697 * self.count * self.count
        elif log2m == 6:
            self.alpha_MM = 0.709 * self.count * self.count
        else:
            self.alpha_MM = (0.7213 / (1 + 1.079 / self.count)) * self.count * self.count

    def cardinality(self, enable_long_range_correction=True):
        register_sum = calc_sum(self.data)
        estimate = self.alpha_MM * (1 / register_sum)

        if estimate <= (5.0 / 2.0) * self.count:
            zeros = self.data.count(0) * 1.0
            return int(round(self.count * log(self.count / zeros)));
        elif estimate <= (1.0 / 30.0) * POW_2_32:
            return int(round(estimate))
        elif estimate > (1.0 / 30.0) * POW_2_32:
            if enable_long_range_correction:
                return int(round((NEGATIVE_POW_2_32 * log(1.0 - (estimate / POW_2_32)))))
            else:
                return int(round(estimate))

        return 0

zero_sets = {}
def get_zero_byte_array(size):
    try:
        return zero_sets[size][:]
    except KeyError:
        pass

    arr = zero_sets[size] = array('b')
    arr.fromstring('\x00' * size)
    return arr[:]

def create(data):
    log2m, size = header.unpack(data[:header.size])

    source = array('I')
    source.fromstring(data[header.size:])
    if sys.byteorder == 'little':
        source.byteswap()

    dest = get_zero_byte_array(1 << log2m)
    fill_bits(1 << log2m, source, dest)

    return HyperLogLog(log2m, dest)

def merge(counters):
    dest = get_zero_byte_array(1 << counters[0].log2m)
    for c in counters:
        merge_sets(c.data, dest)

    return HyperLogLog(counters[0].log2m, dest)
