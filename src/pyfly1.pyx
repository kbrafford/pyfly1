# -*- coding: latin-1 -*-
"""
.. module:: pyfly1
   :platform: Windows
   :synopsis: A Python wrapper for the FlyCapture C API from Point Grey Research

.. moduleauthor:: Keith Brafford
"""
    
class FCError(Exception):
    """Exception wrapper for errors returned from underlying FlyCapture2 calls"""
    def __init__(self, errorcode):
        self.errorcode = errorcode

    def __str__(self):
        #error_desc = error_dict.get(self.errorcode)
        error_desc = "Some error"
        return repr(error_desc)
        
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
        errcheck(flycaptureStartCustomImage(self._context, mode,
            left, top, width, height, bw, fmt))

    def StartLockNext(self, video_mode, frame_rate):
        errcheck(flycaptureStartLockNext(self._context,
            video_mode, frame_rate))

    def Stop(self):
        errcheck(flycaptureStop(self._context))

    def SetColorProcessingMethod(self, method):
        errcheck(flycaptureSetColorProcessingMethod(
            self._context, method))

    #def GrabImage(self):
    #    image = Image()
    #    errcheck(flycaptureGrabImage2(self._context, &image))
    #    return image

    def GrabImagePIL(self):
        cdef FlyCaptureImage image
        cdef FlyCaptureImage converted
        cdef char * data
        errcheck(flycaptureGrabImage2(self._context, &image))
        
        import Image as PILImage
        width, height = image.iCols, image.iRows
        size = width * height * 3
        #converted.pData = (unsigned char *)0
        converted.pixelFormat = FLYCAPTURE_BGR
        errcheck(flycaptureConvertImage(self._context, &image, &converted))
        data = converted.pData[0:size]
        image = PILImage.fromstring('RGB', (width, height), data)
        b, g, r = image.split()
        image = PILImage.merge('RGB', (r, g, b))
        image = image.transpose(PILImage.FLIP_TOP_BOTTOM)
        return image

    def GrabImagePIL16(self):
        import Image as PILImage
        image = self.GrabImage()
        width, height = image.Cols, image.Rows
        size = width * height * 2
        data = image.Data[0:size]
        image = PILImage.fromstring('I;16', (width, height), data)
        return image

    def LockNext(self):
        image = ImagePlus()
        check_result(flycaptureLockNext(self._context, pointer(image)))
        return image

    def GetCameraPropertyEx(self, FlyCaptureProperty key):
        cdef bint one_push
        cdef bint on_off
        cdef bint auto
        cdef int a 
        cdef int b
        errcheck(flycaptureGetCameraPropertyEx(self._context, key,
            &one_push, &on_off, &auto, &a, &b))
        return (one_push, on_off, auto, a, b)

    def SetCameraPropertyEx(self, FlyCaptureProperty key, bint one_push=False, bint on_off=False,
        bint auto=False,  int a=-1, b=-1):
        values = self.GetCameraPropertyEx(key)
        one_push = values[0] if one_push is None else one_push
        on_off = values[1] if on_off is None else on_off
        auto = values[2] if auto is None else auto
        a = values[3] if a is -1 else a
        b = values[4] if b is -1 else b
        check_result(flycaptureSetCameraPropertyEx(self._context, key,
            one_push, on_off, auto, a, b))
