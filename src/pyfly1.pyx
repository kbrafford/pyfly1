# -*- coding: latin-1 -*-
"""
.. module:: pyfly1
   :platform: Windows
   :synopsis: A Python wrapper for the FlyCapture C API from Point Grey Research

.. moduleauthor:: Keith Brafford
"""
from libc.stdlib cimport malloc, free

class FCError(Exception):
    """Exception wrapper for errors returned from underlying FlyCapture2 calls"""

    def __init__(self, errorcode):
        self.errorcode = errorcode

    def __str__(self):
        cdef bytes py_string
        py_string = flycaptureErrorToString(self.errorcode)
        return py_string
        
cdef inline bint errcheck(FlyCaptureError result) except True:
    cdef bint is_error = (result != FLYCAPTURE_OK)
    if is_error:
        raise FCError(result)
    return is_error
    
# Context Functions
cdef class Context(object):
    cdef FlyCaptureContext _context

    @staticmethod
    def from_index(int index):
        context = Context()
        context.Initialize(index)
        return context

    @staticmethod
    def from_serial_number(serial_number):
        context = Context()
        context.InitializeFromSerialNumber(serial_number)
        return context

    def __init__(self):
        errcheck(flycaptureCreateContext(&self._context))

    def __del__(self):
        self.Destroy()

    def Destroy(self):
        errcheck(flycaptureDestroyContext(self._context))

    def Initialize(self, int index):
        errcheck(flycaptureInitialize(self._context, index))

    def InitializeFromSerialNumber(self, serial_number):
        errcheck(flycaptureInitializeFromSerialNumber(
            self._context, serial_number))

    def Start(self, video_mode, frame_rate):
        errcheck(flycaptureStart(self._context, video_mode, frame_rate))

    def StartCustomImage(self, mode, left, top, width, height, float bandwidth, fmt):
        cdef float bw = float(bandwidth)
        errcheck(flycaptureStartCustomImage(self._context, mode,left, top, width, height, bw, fmt))

    def StartLockNext(self, video_mode, frame_rate):
        errcheck(flycaptureStartLockNext(self._context, video_mode, frame_rate))

    def Stop(self):
        errcheck(flycaptureStop(self._context))

    def SetColorProcessingMethod(self, method):
        errcheck(flycaptureSetColorProcessingMethod(
            self._context, method))

    #def GrabImage(self):
    #    image = Image()
    #    errcheck(flycaptureGrabImage2(self._context, &image))
    #    return image

    def GrabImagePIL(self, transpose = None):
        import Image as PILImage
        cdef FlyCaptureImage image
        cdef FlyCaptureImage converted
        cdef bytes py_string

        # grab the image
        errcheck(flycaptureGrabImage2(self._context, &image))

        # calculate the size (in bytes) of the image
        width, height = image.iCols, image.iRows        
        size = width * height * 3 
        
        # allocate a C buffer for the data
        cdef unsigned char * convert_buffer = <unsigned char *> malloc(size)

        # set the relevant fields of the fly capture image structure
        #  1) the desired pixel format (BGR in our case)
        #  2) the image data buffer points to our allocated array
        converted.pixelFormat = FLYCAPTURE_BGR
        converted.pData = convert_buffer
        
        # perform the conversion
        errcheck(flycaptureConvertImage(self._context, &image, &converted))

        # turn the data buffer into a Python string
        py_string = convert_buffer[0:size]
        
        # perform the creation of the PIL Image
        pil_image = PILImage.fromstring('RGB', (width, height), py_string)

        # we need to split the color channels
        # reversing red and blue
        b, g, r = pil_image.split()
        
        # re-merge them, swapping red and blue
        pil_image = PILImage.merge('RGB', (r, g, b))
        
        # apply any transpose
        if transpose:
            pil_image = pil_image.transpose(transpose)

        # free the temp buffer            
        free(convert_buffer)

        return pil_image

    def GrabImagePIL16(self):
        import Image as PILImage    
        cdef FlyCaptureImage image   
        cdef bytes py_string
        
        # grab the image
        errcheck(flycaptureGrabImage2(self._context, &image))
        
        # calculate the size (in bytes) of the image        
        width, height = image.iCols, image.iRows
        size = width * height * 2

        # perform the creation of the PIL Image        
        py_string = image.pData[0:size]
        pil_image = PILImage.fromstring('I;16', (width, height), py_string)
        return pil_image

    def LockNext(self):
        import Image as PILImage
        cdef FlyCaptureImagePlus image
        errcheck(flycaptureLockNext(self._context, &image))
        #return image
        return None

    def GetCameraPropertyEx(self, FlyCaptureProperty key):
        cdef bint one_push
        cdef bint on_off
        cdef bint auto
        cdef int a 
        cdef int b
        errcheck(flycaptureGetCameraPropertyEx(self._context, key, &one_push, &on_off, &auto, &a, &b))
        return (one_push, on_off, auto, a, b)

    def SetCameraPropertyEx(self, FlyCaptureProperty key, bint one_push=False, bint on_off=False,
        bint auto=False,  int a=-1, b=-1):
        values = self.GetCameraPropertyEx(key)
        one_push = values[0] if one_push is None else one_push
        on_off = values[1] if on_off is None else on_off
        auto = values[2] if auto is None else auto
        a = values[3] if a is -1 else a
        b = values[4] if b is -1 else b
        errcheck(flycaptureSetCameraPropertyEx(self._context, key,one_push, on_off, auto, a, b))
