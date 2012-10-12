# -*- coding: latin-1 -*-
"""
.. module:: pyfly1
   :platform: Windows
   :synopsis: A Python wrapper for the FlyCapture C API from Point Grey Research

.. moduleauthor:: Keith Brafford
"""
from libc.stdlib cimport malloc, free
import time      
import numpy
cimport numpy as np

class FCProperty(object):
    """An enumeration of the different camera properties that can be set via
the API.

Remarks:
 A lot of these properties are included only for completeness and future
 expandability, and will have no effect on a PGR camera."""
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
    """An enumeration of the different type of bus events."""
    BUS_RESET      = 0x02
    DEVICE_ARRIVAL = 0x03
    DEVICE_REMOVAL = 0x04


class FCFrameRate(object):
    """Enum describing different framerates."""
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
    """Enum describing different video modes.

Remarks:
 The explicit numbering is to provide downward compatibility for this enum."""
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
    """ An enumeration used to describe the different camera models that can
be accessed through this SDK."""
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
    """ An enumeration used to describe the different camera color
configurations."""
    BLACK_AND_WHITE = 0
    COLOR           = 1

class FCBusSpeed(object):
    """An enumeration used to describe the bus speed"""
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
    """ An enumeration used to describe the different color processing
methods.

Remarks:
 This is only relevant for cameras that do not do on-board color
 processing, such as the Dragonfly.  The FLYCAPTURE_RIGOROUS
 method is very slow and will not keep up with high frame rates."""
    DISABLE                = 0
    EDGE_SENSING           = 1
    NEAREST_NEIGHBOR       = 2
    NEAREST_NEIGHBOR_FAST  = 3
    RIGOROUS               = 4
    HQLINEAR               = 5

class FCStippleFormat(object):
    """An enumeration used to indicate the Bayer tile format of the stippled
images passed into a destippling function.

Remarks:
 This is only relevant for cameras that do not do onboard color
 processing, such as the Dragonfly.  The four letters of the enum
 value correspond to the "top left" 2x2 section of the stippled image.
 For example, the first line of a BGGR image image will be
 BGBGBG..., and the second line will be GRGRGR...."""
    BGGR     = 0
    GBRG     = 1
    GRBG     = 2
    RGGB     = 3
    DEFAULT  = 4

class FCPixelFormat(object):
    """An enumeration used to indicate the pixel format of an image.  This
enumeration is used as a member of FlyCaptureImage and as a parameter
to FlyCaptureStartCustomImage()."""
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
    """Enumerates the image file formats that flycaptureSaveImage() can write 
to."""
    PGM = 0
    PPM = 1
    BMP = 2
    JPG = 3
    PNG = 4
    RAW = 5

def get_library_version():
    """This function returns the version of the library defined in the
header file this python wrapper was compiled with.

    Parameters
    ----------
        None

    Returns
    -------
        out : tuple
              the major, minor version of the library

    Raises
    ------
        None
    """

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

def get_camera_count():
    cdef unsigned int camera_count
    errcheck(flycaptureBusCameraCount( &camera_count))
    return camera_count


def get_camera_information():
    cdef unsigned int camera_count
    
    # first we need to know how many cameras there are
    errcheck(flycaptureBusCameraCount( &camera_count))

    # now we need to allocate space for an array of
    # FlyCaptureInfoEx records, one for each camera
    cdef FlyCaptureInfoEx record_array[16]
    cdef unsigned int record_size = 16 

    errcheck(flycaptureBusEnumerateCamerasEx(record_array, &record_size))

    return_list = []
    for i in range(camera_count):
        d = {}
        d["SerialNumber"] = record_array[i].SerialNumber
        d["CameraType"] = record_array[i].CameraType
        d["CameraModel"] = record_array[i].CameraModel
        d["ModelName"] = str(record_array[i].pszModelName)
        d["VendorName"] = str(record_array[i].pszVendorName)
        d["SensorInfo"] = str(record_array[i].pszSensorInfo)
        d["iDCAMVer"] = record_array[i].iDCAMVer
        d["iNodeNum"] = record_array[i].iNodeNum
        d["iBusNum"] = record_array[i].iBusNum
        d["CameraMaxBusSpeed"] = record_array[i].CameraMaxBusSpeed
        d["iInitialized"] = record_array[i].iInitialized
        
        return_list.append(d)
    return return_list

#
# Pair Context
#
class ContextPair(object):
    THRESHOLD = .05

    @classmethod
    def SetThreshold(cls, threshold):
        cls.THRESHOLD = threshold

    def __init__(self):
        self.left = Context.from_index(1)
        self.right = Context.from_index(0)

    def SetColorProcessingMethod(self, method):
        self.left.SetColorProcessingMethod(method)
        self.right.SetColorProcessingMethod(method)

    def Start(self, video_mode, frame_rate, stipple_pattern = FCStippleFormat.GRBG):
        self.left.Start(video_mode, frame_rate, stipple_pattern)
        self.right.Start(video_mode, frame_rate, stipple_pattern)

    def Stop(self):
        self.left.Stop()
        self.right.Stop()

    def __del__(self):
        self.Destroy()

    def Destroy(self):
        self.left.Destroy()
        self.right.Destroy()

    def GrabImagePIL(self, transpose = None, bypass = False):
        import Image as PILImage

        pil_left, timestamp_left = self.left.GrabImagePIL(bypass = bypass)
        pil_right, timestamp_right = self.right.GrabImagePIL(bypass = bypass)

        delta = abs(timestamp_left - timestamp_right)

        if delta > self.THRESHOLD:
            if timestamp_left > timestamp_right:
                # left is newer
                pil_right, timestamp_right = self.right.GrabImagePIL()
            else:
                # right is newer
                pil_left, timestamp_left = self.left.GrabImagePIL()

        return pil_left, pil_right, timestamp_left, timestamp_right

    def GrabImageCV(self, transpose = None, bypass = False):
        cv_left, timestamp_left = self.left.GrabImageCV(bypass = bypass)
        cv_right, timestamp_right = self.right.GrabImageCV(bypass = bypass)

        delta = abs(timestamp_left - timestamp_right)

        if delta > self.THRESHOLD:
            if timestamp_left > timestamp_right:
                # left is newer
                cv_right, timestamp_right = self.right.GrabImageCV()
            else:
                # right is newer
                cv_left, timestamp_left = self.left.GrabImageCV()

        return cv_left, cv_right, timestamp_left, timestamp_right
    
    def GetCameraPropertyEx(self,key):
        left_one_push, left_on_off, left_auto, left_a, left_b = self.left.GetCameraPropertyEx(key)
        right_one_push, right_on_off, right_auto, right_a, right_b = self.right.GetCameraPropertyEx(key)
        return ((left_one_push, left_on_off, left_auto, left_a, left_b) , (right_one_push, right_on_off, right_auto, right_a, right_b) )
        
    def SetCameraPropertyTopEx(self, key, one_push=False, on_off=False, auto=False, a=-1, b=-1):
        self.left.SetCameraPropertyEx(key, one_push=one_push, on_off=on_off, auto=auto, a= a, b=b)
 
    def SetCameraPropertyBottEx(self, key, one_push=False, on_off=False, auto=False, a=-1, b=-1):
        self.right.SetCameraPropertyEx(key, one_push=one_push, on_off=on_off, auto=auto, a= a, b=b)
        
#
# 3D Context
#
class Context3D(object):    
    def __init__(self):
        self.left = Context.from_index(1)
        self.right = Context.from_index(0)
       
    def SetColorProcessingMethod(self, method):
        self.left.SetColorProcessingMethod(method)
        self.right.SetColorProcessingMethod(method)

    def Start(self, video_mode, frame_rate, stipple_pattern = FCStippleFormat.GRBG):
        self.left.Start(video_mode, frame_rate, stipple_pattern)
        self.right.Start(video_mode, frame_rate, stipple_pattern)

    def Stop(self):
        self.left.Stop()
        self.right.Stop()

    def __del__(self):
        self.Destroy()

    def Destroy(self):
        self.left.Destroy()
        self.right.Destroy()

    def GrabImagePIL(self, transpose = None, bypass = False):  
        import Image as PILImage

        pil_left, timestamp_left = self.left.GrabImagePIL(bypass = bypass)
        pil_right, timestamp_right = self.right.GrabImagePIL(bypass = bypass)
        
        size_left = pil_left.size
        size_right = pil_right.size
        
        if size_right != size_left:
            pil_right = pil_right.resize(size_left, PILImage.BILINEAR)

        if pil_left.mode == "L":
            red = pil_left
        else:
            red,g,b = pil_left.split()
            
        if pil_right.mode == "L":
            green = pil_right
            blue = pil_right
        else:
            r,green,blue = pil_right.split()

        pil_image = PILImage.merge("RGB", (red, green, blue))

        return pil_image, timestamp_left
    

                            
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

    def Start(self, video_mode, frame_rate, stipple_pattern = FCStippleFormat.GRBG):
        cdef FlyCaptureStippledFormat stipple_format = stipple_pattern

        errcheck(flycaptureStart(self._context, video_mode, frame_rate))

        if stipple_pattern != FCStippleFormat.DEFAULT:
            errcheck(flycaptureSetColorTileFormat(self._context, stipple_format))

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

    def GrabImageNP(self):
        import numpy as np
        cdef FlyCaptureImage image

        # grab the image
        errcheck(flycaptureGrabImage2(self._context, &image))
        iRows, iCols = image.iRows, image.iCols        
        size = iRows * iCols

        if image.pixelFormat in (FLYCAPTURE_MONO8, FLYCAPTURE_RAW8):
            # 8 bits of data per pixel
            A = numpy.frombuffer(image.pData[:size],dtype='uint8')

        elif image.pixelFormat in (FLYCAPTURE_MONO16, FLYCAPTURE_RAW16):
            # 16 bits of data per pixel            
            A = numpy.frombuffer(image.pData[:size*2],dtype='uint16')

        elif image.pixelFormat in (FLYCAPTURE_BGR, FLYCAPTURE_RGB8, FLYCAPTURE_444YUV8):
            # 24 bits of data per pixel            
            A = numpy.frombuffer(image.pData[:size*3],dtype='uint24')

        elif image.pixelFormat in (FLYCAPTURE_BGRU,):
            # 32 bits of data per pixel            
            A = numpy.frombuffer(image.pData[:size*4],dtype='uint32')

        return A.reshape((image.iRows, image.iCols ))        

    def GrabImagePIL(self, transpose = None, bypass = False):
        import Image as PILImage
        cdef FlyCaptureImage image
        cdef FlyCaptureImage converted
        cdef bytes py_string
        cdef unsigned char *convert_buffer
        cdef Py_ssize_t byte_length
        cdef int size

        # grab the image
        errcheck(flycaptureGrabImage2(self._context, &image))

        timestamp = image.timeStamp.ulSeconds + (image.timeStamp.ulMicroSeconds / 1e6)

        width, height = image.iCols, image.iRows  

        st = time.clock()

        # if we got a raw colour image (from a chameleon C)
        # we need to turn it into RGB
        if image.pixelFormat == FLYCAPTURE_RAW8:

            if bypass:
                size = width * height            
                py_string = image.pData[:size]
                pil_image = PILImage.fromstring('L', (width,height), py_string)
            else:
                # calculate the size (in bytes) of the image      
                size = width * height * 3 

                # allocate the space for the converted image
                convert_buffer = <unsigned char *> malloc(size)

                # set the relevant fields of the fly capture image structure
                #  1) the desired pixel format (BGR in our case)
                #  2) the image data buffer points to our allocated array
                converted.pixelFormat = FLYCAPTURE_BGR
                converted.pData = convert_buffer

                # perform the conversion
                errcheck(flycaptureConvertImage(self._context, &image, &converted))

                # turn the data buffer into a Python string            
                byte_length = size
                py_string = convert_buffer[:byte_length]
                
                # perform the creation of the PIL Image
                pil_image = PILImage.fromstring('RGB', (width, height), py_string)

                # free the temp buffer            
                free(convert_buffer)

        elif image.pixelFormat == FLYCAPTURE_MONO8:   
        
            # calculate the size (in bytes) of the image        
            width, height = image.iCols, image.iRows
            size = width * height

            # perform the creation of the PIL Image        
            py_string = image.pData[0:size]
            pil_image = PILImage.fromstring('L', (width, height), py_string)

        # apply any transpose
        if transpose:
            pil_image = pil_image.transpose(transpose)


        end= time.clock()
        #print "elapsed: %f" % (end - st)

        return pil_image, timestamp

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

    def GrabImageCV(self, transpose = None, bypass = False):
        import cv
        cdef FlyCaptureImage image
        cdef FlyCaptureImage converted
        cdef bytes py_string
        cdef unsigned char *convert_buffer
        cdef Py_ssize_t byte_length
        cdef int size

        # grab the image
        errcheck(flycaptureGrabImage2(self._context, &image))

        timestamp = image.timeStamp.ulSeconds + (image.timeStamp.ulMicroSeconds / 1e6)

        width, height = image.iCols, image.iRows  

        st = time.clock()

        # if we got a raw colour image (from a chameleon C)
        # we need to turn it into RGB
        if image.pixelFormat == FLYCAPTURE_RAW8:  
            if bypass:
                size = width * height            
                py_string = image.pData[:size]

                step = image.iRowInc
                cv_image = cv.CreateImageHeader((width, height),
                                                 cv.IPL_DEPTH_8U, 1)
                cv.SetData(cv_image, py_string, step)
                print "nChannels = %d" % cv_image.nChannels
            else:        
                # calculate the size (in bytes) of the image
                size = width * height * 3 

                # allocate the space for the converted image
                convert_buffer = <unsigned char *> malloc(size)

                # set the relevant fields of the fly capture image structure
                #  1) the desired pixel format (BGR in our case)
                #  2) the image data buffer points to our allocated array
                converted.pixelFormat = FLYCAPTURE_BGR
                converted.pData = convert_buffer

                # perform the conversion
                errcheck(flycaptureConvertImage(self._context, &image, &converted))

                # turn the data buffer into a Python string            
                byte_length = size
                py_string = convert_buffer[:byte_length]
                
                step = converted.iRowInc            
                cv_image = cv.CreateImageHeader((width, height),
                                                 cv.IPL_DEPTH_8U, 3)
                cv.SetData(cv_image, py_string, step)

                # free the temp buffer            
                free(convert_buffer)

        elif image.pixelFormat == FLYCAPTURE_MONO8:
            # calculate the size (in bytes) of the image
            width, height = image.iCols, image.iRows        

            # turn the data buffer into a Python string            
            byte_length = width * height
            py_string = image.pData[:byte_length]

            # create the grayscale CV image            
            step = image.iRowInc            
            cv_image_gray = cv.CreateImageHeader((width, height),
                                             cv.IPL_DEPTH_8U, 1)
            cv.SetData(cv_image_gray, py_string, step)

            # convert the CV grayscale image to an RBG image
            cv_image = cv.CreateImage((width, height), cv.IPL_DEPTH_8U, 3)            
            cv.CvtColor(cv_image_gray, cv_image, cv.CV_GRAY2RGB)

        # apply any transpose
        if transpose:
            cv.Flip(cv_image)

        end= time.clock()
        #print "elapsed: %f" % (end - st)

        return cv_image, timestamp

    def LockNext(self):
        import Image as PILImage
        cdef FlyCaptureImagePlus image
        errcheck(flycaptureLockNext(self._context, &image))
        #return image
        return None

    def GetCameraPropertyEx(self, FlyCaptureProperty key):
        cdef int one_push_i
        cdef int on_off_i
        cdef int auto_i
        cdef int a 
        cdef int b

        errcheck(flycaptureGetCameraPropertyEx(self._context, key, &one_push_i, &on_off_i, &auto_i, &a, &b))
        
        one_push = True if one_push_i is not 0 else False
        on_off = True if on_off_i is not 0 else False
        auto = True if auto_i is not 0 else False
        
        return (one_push, on_off, auto, a, b)

    def SetCameraPropertyEx(self, FlyCaptureProperty key, one_push=None, on_off=None, auto=None,  int a=-1, b=-1):
        cdef int one_push_i
        cdef int on_off_i
        cdef int auto_i

        values = self.GetCameraPropertyEx(key)

        one_push = values[0] if one_push is None else one_push
        on_off = values[1] if on_off is None else on_off
        auto = values[2] if auto is None else auto

        one_push_i = 1 if one_push else 0
        on_off_i = 1 if on_off else 0
        auto_i = 1 if auto else 0

        a = values[3] if a is -1 else a
        b = values[4] if b is -1 else b
        
        errcheck(flycaptureSetCameraPropertyEx(self._context, key,one_push_i, on_off_i, auto_i, a, b))
