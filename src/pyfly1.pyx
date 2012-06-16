# -*- coding: latin-1 -*-
"""
.. module:: pyfly1
   :platform: Windows
   :synopsis: A Python wrapper for the FlyCapture C API from Point Grey Research

.. moduleauthor:: Keith Brafford
"""
from libc.stdlib cimport malloc, free

class FCProperty(object):
    BRIGHTNESS            = 0
    AUTO_EXPOSURE         = 1
    SHARPNESS             = 2
    WHITE_BALANCE         = 3
    HUE                   = 4
    SATURATION            = 5
    GAMMA                 = 6
    IRIS                  = 7
    FOCUS                 = 8
    ZOOM                  = 9
    PAN                   = 10
    TILT                  = 11
    SHUTTER               = 12
    GAIN                  = 13
    TRIGGER_DELAY         = 14
    FRAME_RATE            = 15
    SOFTWARE_WHITEBALANCE = 16
    TEMPERATURE           = 17

class FCBusEvent(object):
    BUS_RESET      = 0x02
    DEVICE_ARRIVAL = 0x03
    DEVICE_REMOVAL = 0x04


class FCFrameRate(object):
    _1_875         = 0
    _3_75          = 1
    _7_5           = 2
    _15            = 3
    _30            = 4
    UNUSED         = 5
    _60            = 6
    _120           = 7
    _240           = 8
    NUM_FRAMERATES = 9
    CUSTOM         = 10
    ANY            = 11

class FCVideoMode(object):
    _160x120YUV444   = 0
    _320x240YUV422   = 1
    _640x480YUV411   = 2
    _640x480YUV422   = 3
    _640x480RGB      = 4
    _640x480Y8       = 5
    _640x480Y16      = 6
    _800x600YUV422   = 17
    _800x600RGB      = 18
    _800x600Y8       = 7
    _800x600Y16      = 19
    _1024x768YUV422  = 20
    _1024x768RGB     = 21
    _1024x768Y8      = 8
    _1024x768Y16     = 9
    _1280x960YUV422  = 22
    _1280x960RGB     = 23
    _1280x960Y8      = 10
    _1280x960Y16     = 24
    _1600x1200YUV422 = 50
    _1600x1200RGB    = 51
    _1600x1200Y8     = 11
    _1600x1200Y16    = 52
    CUSTOM           = 15
    ANY              = 16
    NUM_VIDEOMODES   = 23

class FCCameraModel(object):
    FIREFLY            = 0 
    DRAGONFLY          = 1
    AIM                = 2
    SCORPION           = 3
    TYPHOON            = 4
    FLEA               = 5
    DRAGONFLY_EXPRESS  = 6
    FLEA2              = 7
    FIREFLY_MV         = 8
    DRAGONFLY2         = 9
    BUMBLEBEE          = 10
    BUMBLEBEE2         = 11
    BUMBLEBEEXB3       = 12
    GRASSHOPPER        = 13
    CHAMELEON          = 14
    UNKNOWN            = -1
    FCCM_FORCE_QUADLET = 0x7FFFFFFF    

class FCCameraType(object):
    BLACK_AND_WHITE = 0
    COLOR           = 1

class FCBusSpeed(object):
    S100                = 0
    S200                = 1
    S400                = 2
    S480                = 3
    S800                = 4
    S1600               = 5
    S3200               = 6
    S_FASTEST           = 7
    ANY                 = 8
    SPEED_UNKNOWN       = -1
    SPEED_FORCE_QUADLET = 0x7FFFFFFF

class FCColorMethod(object):
    DISABLE                = 0
    EDGE_SENSING           = 1
    NEAREST_NEIGHBOR       = 2
    NEAREST_NEIGHBOR_FAST  = 3
    RIGOROUS               = 4
    HQLINEAR               = 5

class FCStippleFormat(object):
    BGGR     = 0
    GBRG     = 1
    GRBG     = 2
    RGGB     = 3
    DEFAULT  = 4

class FCPixelFormat(object):
    MONO8              = 0x00000001
    _411YUV8           = 0x00000002
    _422YUV8           = 0x00000004
    _444YUV8           = 0x00000008
    RGB8               = 0x00000010
    MONO16             = 0x00000020
    RGB16              = 0x00000040
    S_MONO16           = 0x00000080
    S_RGB16            = 0x00000100
    RAW8               = 0x00000200
    RAW16              = 0x00000400
    BGR                = 0x10000001
    BGRU               = 0x10000002
    FCPF_FORCE_QUADLET = 0x7FFFFFFF

class FCImageFileFormat(object):
    PGM = 0
    PPM = 1
    BMP = 2
    JPG = 3
    PNG = 4
    RAW = 5

def get_library_version():    
    version = flycaptureGetLibraryVersion()
    major = version / 100
    minor = version % 100
    return (major, minor)

def register_description(unsigned long int register):
    cdef bytes py_string
    
    py_string = flycaptureRegisterToString(register)
    return py_string

    
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
    def from_serial_number(FlyCaptureCameraSerialNumber serial_number):
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

    def InitializeFromSerialNumber(self, FlyCaptureCameraSerialNumber serial_number):
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
