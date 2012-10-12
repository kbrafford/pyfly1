cdef extern from "PGRFlyCapture.h":
    ctypedef void* FlyCaptureContext
    ctypedef unsigned long FlyCaptureCameraSerialNumber
    ctypedef void FlyCaptureCallback( void* pParam, int iMessage, unsigned long ulParam )

    ctypedef enum FlyCaptureError:
        FLYCAPTURE_OK
        FLYCAPTURE_FAILED
        FLYCAPTURE_INVALID_ARGUMENT
        FLYCAPTURE_INVALID_CONTEXT
        FLYCAPTURE_NOT_IMPLEMENTED
        FLYCAPTURE_ALREADY_INITIALIZED
        FLYCAPTURE_ALREADY_STARTED
        FLYCAPTURE_CALLBACK_NOT_REGISTERED
        FLYCAPTURE_CALLBACK_ALREADY_REGISTERED
        FLYCAPTURE_CAMERACONTROL_PROBLEM
        FLYCAPTURE_COULD_NOT_OPEN_FILE
        FLYCAPTURE_COULD_NOT_OPEN_DEVICE_HANDLE
        FLYCAPTURE_MEMORY_ALLOC_ERROR
        FLYCAPTURE_NO_IMAGE
        FLYCAPTURE_NOT_INITIALIZED
        FLYCAPTURE_NOT_STARTED
        FLYCAPTURE_MAX_BANDWIDTH_EXCEEDED
        FLYCAPTURE_NON_PGR_CAMERA
        FLYCAPTURE_INVALID_MODE
        FLYCAPTURE_ERROR_UNKNOWN
        FLYCAPTURE_INVALID_CUSTOM_SIZE
        FLYCAPTURE_TIMEOUT
        FLYCAPTURE_TOO_MANY_LOCKED_BUFFERS
        FLYCAPTURE_VERSION_MISMATCH
        FLYCAPTURE_DEVICE_BUSY
        FLYCAPTURE_DEPRECATED
        FLYCAPTURE_BUFFER_SIZE_TOO_SMALL

    ctypedef enum FlyCaptureProperty:
        FLYCAPTURE_BRIGHTNESS
        FLYCAPTURE_AUTO_EXPOSURE
        FLYCAPTURE_SHARPNESS
        FLYCAPTURE_WHITE_BALANCE
        FLYCAPTURE_HUE
        FLYCAPTURE_SATURATION
        FLYCAPTURE_GAMMA
        FLYCAPTURE_IRIS
        FLYCAPTURE_FOCUS
        FLYCAPTURE_ZOOM
        FLYCAPTURE_PAN
        FLYCAPTURE_TILT
        FLYCAPTURE_SHUTTER
        FLYCAPTURE_GAIN
        FLYCAPTURE_TRIGGER_DELAY
        FLYCAPTURE_FRAME_RATE
        FLYCAPTURE_SOFTWARE_WHITEBALANCE
        FLYCAPTURE_TEMPERATURE


    ctypedef enum FlyCaptureBusEvent:
        FLYCAPTURE_MESSAGE_BUS_RESET = 0x02
        FLYCAPTURE_MESSAGE_DEVICE_ARRIVAL,
        FLYCAPTURE_MESSAGE_DEVICE_REMOVAL


    ctypedef enum FlyCaptureFrameRate:
        FLYCAPTURE_FRAMERATE_1_875
        FLYCAPTURE_FRAMERATE_3_75
        FLYCAPTURE_FRAMERATE_7_5
        FLYCAPTURE_FRAMERATE_15
        FLYCAPTURE_FRAMERATE_30
        FLYCAPTURE_FRAMERATE_UNUSED
        FLYCAPTURE_FRAMERATE_60
        FLYCAPTURE_FRAMERATE_120
        FLYCAPTURE_FRAMERATE_240
        FLYCAPTURE_NUM_FRAMERATES
        FLYCAPTURE_FRAMERATE_CUSTOM
        FLYCAPTURE_FRAMERATE_ANY

    ctypedef enum FlyCaptureVideoMode:
        FLYCAPTURE_VIDEOMODE_160x120YUV444 = 0
        FLYCAPTURE_VIDEOMODE_320x240YUV422 = 1
        FLYCAPTURE_VIDEOMODE_640x480YUV411 = 2
        FLYCAPTURE_VIDEOMODE_640x480YUV422 = 3
        FLYCAPTURE_VIDEOMODE_640x480RGB  = 4
        FLYCAPTURE_VIDEOMODE_640x480Y8   = 5
        FLYCAPTURE_VIDEOMODE_640x480Y16  = 6
        FLYCAPTURE_VIDEOMODE_800x600YUV422 = 17
        FLYCAPTURE_VIDEOMODE_800x600RGB  = 18
        FLYCAPTURE_VIDEOMODE_800x600Y8   = 7
        FLYCAPTURE_VIDEOMODE_800x600Y16  = 19
        FLYCAPTURE_VIDEOMODE_1024x768YUV422    = 20
        FLYCAPTURE_VIDEOMODE_1024x768RGB = 21
        FLYCAPTURE_VIDEOMODE_1024x768Y8  = 8
        FLYCAPTURE_VIDEOMODE_1024x768Y16 = 9
        FLYCAPTURE_VIDEOMODE_1280x960YUV422    = 22
        FLYCAPTURE_VIDEOMODE_1280x960RGB = 23
        FLYCAPTURE_VIDEOMODE_1280x960Y8  = 10
        FLYCAPTURE_VIDEOMODE_1280x960Y16 = 24
        FLYCAPTURE_VIDEOMODE_1600x1200YUV422   = 50
        FLYCAPTURE_VIDEOMODE_1600x1200RGB= 51
        FLYCAPTURE_VIDEOMODE_1600x1200Y8 = 11
        FLYCAPTURE_VIDEOMODE_1600x1200Y16= 52
        FLYCAPTURE_VIDEOMODE_CUSTOM= 15
        FLYCAPTURE_VIDEOMODE_ANY   = 16
        FLYCAPTURE_NUM_VIDEOMODES  = 23

    ctypedef enum FlyCaptureCameraModel:
        FLYCAPTURE_FIREFLY
        FLYCAPTURE_DRAGONFLY
        FLYCAPTURE_AIM
        FLYCAPTURE_SCORPION
        FLYCAPTURE_TYPHOON
        FLYCAPTURE_FLEA
        FLYCAPTURE_DRAGONFLY_EXPRESS
        FLYCAPTURE_FLEA2
        FLYCAPTURE_FIREFLY_MV
        FLYCAPTURE_DRAGONFLY2
        FLYCAPTURE_BUMBLEBEE
        FLYCAPTURE_BUMBLEBEE2
        FLYCAPTURE_BUMBLEBEEXB3
        FLYCAPTURE_GRASSHOPPER
        FLYCAPTURE_CHAMELEON
        FLYCAPTURE_UNKNOWN = -1
        FCCM_FORCE_QUADLET   = 0x7FFFFFFF

    ctypedef enum FlyCaptureCameraType:
        FLYCAPTURE_BLACK_AND_WHITE,
        FLYCAPTURE_COLOR

    ctypedef enum FlyCaptureBusSpeed:
        FLYCAPTURE_S100
        FLYCAPTURE_S200
        FLYCAPTURE_S400
        FLYCAPTURE_S480
        FLYCAPTURE_S800
        FLYCAPTURE_S1600
        FLYCAPTURE_S3200
        FLYCAPTURE_S_FASTEST
        FLYCAPTURE_ANY
        FLYCAPTURE_SPEED_UNKNOWN = -1
        FLYCAPTURE_SPEED_FORCE_QUADLET   = 0x7FFFFFFF

    ctypedef struct FlyCaptureInfoEx:
        FlyCaptureCameraSerialNumber   SerialNumber
        FlyCaptureCameraType CameraType
        FlyCaptureCameraModel    CameraModel
        char pszModelName[ 512 ]
        char pszVendorName[ 512 ]
        char pszSensorInfo[ 512 ]
        int  iDCAMVer
        int  iNodeNum
        int  iBusNum
        FlyCaptureBusSpeed   CameraMaxBusSpeed
        int  iInitialized
        unsigned longulReserved[ 115 ]

    ctypedef struct FlyCaptureDriverInfo:
        char pszDriverName[ 512 ]
        char pszVersion [ 512 ]


    ctypedef enum FlyCaptureColorMethod:
        FLYCAPTURE_DISABLE
        FLYCAPTURE_EDGE_SENSING
        FLYCAPTURE_NEAREST_NEIGHBOR
        FLYCAPTURE_NEAREST_NEIGHBOR_FAST
        FLYCAPTURE_RIGOROUS
        FLYCAPTURE_HQLINEAR


    ctypedef enum FlyCaptureStippledFormat:
        FLYCAPTURE_STIPPLEDFORMAT_BGGR
        FLYCAPTURE_STIPPLEDFORMAT_GBRG
        FLYCAPTURE_STIPPLEDFORMAT_GRBG
        FLYCAPTURE_STIPPLEDFORMAT_RGGB  
        FLYCAPTURE_STIPPLEDFORMAT_DEFAULT


    ctypedef enum FlyCapturePixelFormat:
        FLYCAPTURE_MONO8 = 0x00000001
        FLYCAPTURE_411YUV8   = 0x00000002
        FLYCAPTURE_422YUV8   = 0x00000004
        FLYCAPTURE_444YUV8   = 0x00000008
        FLYCAPTURE_RGB8= 0x00000010
        FLYCAPTURE_MONO16    = 0x00000020
        FLYCAPTURE_RGB16 = 0x00000040
        FLYCAPTURE_S_MONO16  = 0x00000080
        FLYCAPTURE_S_RGB16   = 0x00000100
        FLYCAPTURE_RAW8= 0x00000200
        FLYCAPTURE_RAW16 = 0x00000400
        FLYCAPTURE_BGR = 0x10000001
        FLYCAPTURE_BGRU= 0x10000002
        FCPF_FORCE_QUADLET   = 0x7FFFFFFF

    ctypedef enum FlyCaptureImageFileFormat:
        FLYCAPTURE_FILEFORMAT_PGM
        FLYCAPTURE_FILEFORMAT_PPM
        FLYCAPTURE_FILEFORMAT_BMP
        FLYCAPTURE_FILEFORMAT_JPG
        FLYCAPTURE_FILEFORMAT_PNG
        FLYCAPTURE_FILEFORMAT_RAW

    ctypedef struct FlyCaptureTimestamp:
        unsigned long ulSeconds
        unsigned long ulMicroSeconds
        unsigned long ulCycleSeconds
        unsigned long ulCycleCount
        unsigned long ulCycleOffset

    ctypedef struct FlyCaptureImage:
        int iRows
        int iCols
        int iRowInc
        FlyCaptureVideoMode   videoMode
        FlyCaptureTimestamp   timeStamp
        unsigned char*  pData
        bint bStippled
        FlyCapturePixelFormat pixelFormat
        int iNumImages
        unsigned long   ulReserved[ 5 ]

    FlyCaptureError flycaptureBusCameraCount( unsigned int* puiCount )
    FlyCaptureError flycaptureBusEnumerateCamerasEx( FlyCaptureInfoEx*  arInfo, unsigned int* puiSize )
    FlyCaptureError flycaptureModifyCallback(FlyCaptureContext context, FlyCaptureCallback* pfnCallback, void* pParam, bint bAdd )
    FlyCaptureError flycaptureCreateContext(FlyCaptureContext* pContext )
    FlyCaptureError flycaptureDestroyContext(FlyCaptureContext context )
    FlyCaptureError flycaptureInitialize(FlyCaptureContext context, unsigned long ulDevice )
    FlyCaptureError flycaptureInitializeFromSerialNumber(FlyCaptureContext context, FlyCaptureCameraSerialNumber serialNumber )
    FlyCaptureError flycaptureGetCameraInfo(FlyCaptureContext context, FlyCaptureInfoEx* pInfo )
    FlyCaptureError flycaptureGetDriverInfo(FlyCaptureContext context, FlyCaptureDriverInfo* pInfo )
    FlyCaptureError flycaptureGetBusSpeed(FlyCaptureContext context, FlyCaptureBusSpeed* pAsyncBusSpeed,FlyCaptureBusSpeed* pIsochBusSpeed )
    FlyCaptureError flycaptureSetBusSpeed(FlyCaptureContext  context, FlyCaptureBusSpeed asyncBusSpeed, FlyCaptureBusSpeed isochBusSpeed )
    int flycaptureGetLibraryVersion()
    char* flycaptureErrorToString(FlyCaptureError error )
    char* flycaptureRegisterToString( unsigned long ulRegister  )
    FlyCaptureError flycaptureCheckVideoMode(FlyCaptureContext   context,FlyCaptureVideoMode videoMode,FlyCaptureFrameRate frameRate,bint* pbSupported )
    FlyCaptureError flycaptureGetCurrentVideoMode(FlyCaptureContext    context,FlyCaptureVideoMode* pVideoMode,FlyCaptureFrameRate* pFrameRate )
    FlyCaptureError flycaptureGetCurrentCustomImage(FlyCaptureContext context,unsigned int* puiMode,unsigned int* puiImagePosLeft,unsigned int* puiImagePosTop,unsigned int* puiWidth,unsigned int* puiHeight,unsigned int* puiPacketSizeBytes,float* pfSpeed, FlyCapturePixelFormat* pPixelFormat )
    FlyCaptureError flycaptureGetColorProcessingMethod( FlyCaptureContext  context, FlyCaptureColorMethod*   pMethod )
    FlyCaptureError flycaptureSetColorProcessingMethod( FlyCaptureContext context, FlyCaptureColorMethod    method )
    FlyCaptureError flycaptureGetColorTileFormat(   FlyCaptureContext   context,   FlyCaptureStippledFormat*  pformat )
    FlyCaptureError flycaptureSetColorTileFormat(  FlyCaptureContext  context,  FlyCaptureStippledFormat format )
    FlyCaptureError flycaptureStart(  FlyCaptureContext   context,  FlyCaptureVideoMode videoMode,  FlyCaptureFrameRate frameRate )
    FlyCaptureError flycaptureQueryCustomImage(FlyCaptureContext context,unsigned intuiMode,bint* pbAvailable,unsigned int* puiMaxImagePixelsWidth,unsigned int* puiMaxImagePixelsHeight,unsigned int* puiPixelUnitHorz,unsigned int* puiPixelUnitVert, unsigned int* puiPixelFormats )
    FlyCaptureError flycaptureQueryCustomImageEx(FlyCaptureContext context,unsigned intuiMode,bint* pbAvailable,unsigned int* puiMaxImagePixelsWidth,unsigned int* puiMaxImagePixelsHeight,unsigned int* puiPixelUnitHorz,unsigned int* puiPixelUnitVert, unsigned int* puiOffsetUnitHorz, unsigned int* puiOffsetUnitVert, unsigned int* puiPixelFormats )
    FlyCaptureError flycaptureStartCustomImage(FlyCaptureContext context,unsigned intuiMode,unsigned intuiImagePosLeft,unsigned intuiImagePosTop,unsigned intuiWidth,unsigned intuiHeight,float fBandwidth, FlyCapturePixelFormat   format )
    FlyCaptureError flycaptureStop(  FlyCaptureContext context )
    FlyCaptureError flycaptureSetGrabTimeoutEx( FlyCaptureContext context, unsigned long ulTimeout )
    FlyCaptureError flycaptureGrabImage(FlyCaptureContext   context,unsigned char**   ppImageBuffer,int*    piRows,int*    piCols,int*    piRowInc,FlyCaptureVideoMode*  pVideoMode )
    FlyCaptureError flycaptureGrabImage2( FlyCaptureContext   context, FlyCaptureImage*   pimage )
    FlyCaptureError flycaptureSaveImage(  FlyCaptureContext context,   FlyCaptureImage *pImage,   char* pszPath,  FlyCaptureImageFileFormat   format)
    FlyCaptureError flycaptureSetJPEGCompressionQuality(  FlyCaptureContext context,  int    iQuality)
    FlyCaptureError flycaptureConvertImage(FlyCaptureContext context, FlyCaptureImage* pimageSrc,FlyCaptureImage* pimageDest)
    FlyCaptureError flycaptureInplaceRGB24toBGR24(unsigned char* pImageBuffer, intiImagePixels)
    FlyCaptureError flycaptureInplaceWhiteBalance(   FlyCaptureContext context,   unsigned char* pData,   int iRows,   int iCols )
    FlyCaptureError flycaptureGetCameraPropertyRange( FlyCaptureContext  context, FlyCaptureProperty cameraProperty, bint*  pbPresent, long*  plMin, long*  plMax, long*  plDefault, bint*  pbAuto, bint*pbManual )
    FlyCaptureError flycaptureGetCameraProperty( FlyCaptureContext   context, FlyCaptureProperty  cameraProperty, long*   plValueA, long*   plValueB, bint*   pbAuto )
    FlyCaptureError flycaptureSetCameraProperty( FlyCaptureContext  context, FlyCaptureProperty cameraProperty, long   lValueA, long   lValueB,bint   bAuto )
    FlyCaptureError flycaptureSetCameraPropertyBroadcast(   FlyCaptureContext  context,   FlyCaptureProperty cameraProperty,   long   lValueA,   long   lValueB,   bint   bAuto )
    FlyCaptureError flycaptureGetCameraPropertyRangeEx(   FlyCaptureContext    context,   FlyCaptureProperty   cameraProperty,   bint*    pbPresent,   bint*    pbOnePush,   bint*    pbReadOut,   bint*    pbOnOff,   bint*    pbAuto,   bint*  pbManual,   int* piMin,   int* piMax )
    FlyCaptureError flycaptureGetCameraPropertyEx(    FlyCaptureContext   context,    FlyCaptureProperty  cameraProperty,    bint*   pbOnePush,    bint*   pbOnOff,    bint*   pbAuto,    int*    piValueA,    int*    piValueB )
    FlyCaptureError flycaptureSetCameraPropertyEx(    FlyCaptureContext    context,    FlyCaptureProperty   cameraProperty,   OnePush,    bOnOff,     bAuto,  intiValueA,    intiValueB )
    FlyCaptureError flycaptureSetCameraPropertyBroadcastEx( FlyCaptureContext    context, FlyCaptureProperty   cameraProperty, bint bOnePush, bint bOnOff, bint bAuto, intiValueA, intiValueB )
    FlyCaptureError flycaptureGetCameraAbsPropertyRange(  FlyCaptureContext  context,  FlyCaptureProperty cameraProperty,  bint*  pbPresent,  float* pfMin,  float* pfMax,   char** ppszUnits,   char** ppszUnitAbbr )
    FlyCaptureError flycaptureGetCameraAbsProperty( FlyCaptureContext   context, FlyCaptureProperty  cameraProperty, float*  pfValue )
    FlyCaptureError flycaptureGetCameraAbsPropertyEx( FlyCaptureContext   context, FlyCaptureProperty  cameraProperty, bint*   pbOnePush, bint*   pbOnOff, bint*   pbAuto, float*  pfValue )
    FlyCaptureError flycaptureSetCameraAbsProperty(    FlyCaptureContext  context,    FlyCaptureProperty cameraProperty,    float  fValue )
    FlyCaptureError flycaptureSetCameraAbsPropertyEx(    FlyCaptureContext  context,    FlyCaptureProperty cameraProperty, bint   bOnePush, bint   bOnOff, bint   bAuto,    float  fValue )
    FlyCaptureError flycaptureSetCameraAbsPropertyBroadcastEx(    FlyCaptureContext  context,    FlyCaptureProperty cameraProperty, bint   bOnePush, bint   bOnOff, bint   bAuto,    float  fValue )
    FlyCaptureError flycaptureSetCameraAbsPropertyBroadcast(  FlyCaptureContext  context,  FlyCaptureProperty cameraProperty,  float  fValue )
    FlyCaptureError flycaptureGetCameraRegister( FlyCaptureContext context, unsigned long ulRegister, unsigned long*    pulValue )
    FlyCaptureError flycaptureSetCameraRegister( FlyCaptureContext context, unsigned long ulRegister, unsigned long ulValue )
    FlyCaptureError flycaptureSetCameraRegisterBroadcast(   FlyCaptureContext context,   unsigned long ulRegister,   unsigned long ulValue )
    FlyCaptureError flycaptureGetMemoryChannel(    FlyCaptureContext context,    unsigned int* puiCurrentChannel,    unsigned int* puiNumChannels )
    FlyCaptureError flycaptureSaveToMemoryChannel(    FlyCaptureContext context,    unsigned long ulChannel )
    FlyCaptureError flycaptureRestoreFromMemoryChannel(   FlyCaptureContext context,   unsigned long ulChannel )
    FlyCaptureError flycaptureGetCameraTrigger(FlyCaptureContext context,unsigned int* puiPresence,unsigned int* puiOnOff,unsigned int* puiPolarity,unsigned int* puiTriggerMode )
    FlyCaptureError flycaptureSetCameraTrigger(FlyCaptureContext context,unsigned intuiOnOff,unsigned intuiPolarity,unsigned intuiTriggerMode )
    FlyCaptureError flycaptureSetCameraTriggerBroadcast(  FlyCaptureContext context,  unsigned char ucOnOff,  unsigned char ucPolarity,  unsigned char ucTriggerMode )
    FlyCaptureError flycaptureQueryTrigger(   FlyCaptureContext  context,   bint*  pbPresent,   bint*  pbReadOut,   bint*  pbOnOff,   bint*  pbPolarity,   bint*  pbValueRead,   unsigned int*puiSourceMask,   bint*  pbSoftwareTrigger,   unsigned int*puiModeMask )
    FlyCaptureError flycaptureGetTrigger( FlyCaptureContext context, bint* pbOnOff, int*  piPolarity, int*  piSource, int*  piRawValue, int*  piMode, int*  piParameter )
    FlyCaptureError flycaptureSetTrigger(FlyCaptureContext context, bint  bOnOff, int   iPolarity, int   iSource, int   iMode, int   iParameter )
    FlyCaptureError flycaptureSetTriggerBroadcast(    FlyCaptureContext context,    bint  bOnOff,    int   iPolarity,    int   iSource,    int   iMode,    int   iParameter )
    FlyCaptureError flycaptureGetStrobe(  FlyCaptureContext context,  int   iSource,  bint* pbOnOff,  bint* pbPolarityActiveLow,  int*  piDelay,  int*  piDuration )
    FlyCaptureError flycaptureSetStrobe(  FlyCaptureContext context,  int   iSource,  bint  bOnOff,  bint  bPolarityActiveLow,  int   iDelay,  int   iDuration )
    FlyCaptureError flycaptureSetStrobeBroadcast(  FlyCaptureContext context,  int   iSource,  bint  bOnOff,  bint  bPolarityActiveLow,  int   iDelay,  int   iDuration )
    FlyCaptureError flycaptureQueryStrobe(  FlyCaptureContext context,  int   iSource,  bint* pbAvailable,  bint* pbReadOut,  bint* pbOnOff,  bint* pbPolarity,  int*  piMinValue,  int*  piMaxValue )
    FlyCaptureError flycaptureQueryLookUpTable( FlyCaptureContext context, bint* pbAvailable, unsigned int* puiNumChannels, bint* pbOn, unsigned int* puiBitDepth, unsigned int* puiNumEntries )
    FlyCaptureError flycaptureEnableLookUpTable(  FlyCaptureContext context,  bint  bOn )
    FlyCaptureError flycaptureSetLookUpTableChannel(FlyCaptureContext   context,unsigned int  uiChannel, unsigned int* puiArray )
    FlyCaptureError flycaptureGetLookUpTableChannel(FlyCaptureContext context,unsigned intuiChannel,unsigned int* puiArray )


    ctypedef struct FlyCaptureImagePlus:
        FlyCaptureImage   image
        unsigned int      uiSeqNum
        unsigned int      uiBufferIndex
        unsigned int      uiBufSeqNum

    ctypedef struct FlyCaptureImageEvent:
        unsigned char* pBuffer
        unsigned int   uiSizeBytes
        unsigned int   uiSeqNum
        unsigned int   uiBufferIndex
        void*          pInternal
        unsigned long  ulReserved[ 8 ]

    ctypedef struct FlyCapturePacketInfo:
        unsigned int   uiMinSizeBytes
        unsigned int   uiMaxSizeBytes
        unsigned int   uiMaxSizeEventBytes
        unsigned long  ulReserved[ 8 ]

    cdef enum:
        FLYCAPTURE_IMAGE_FILTER_NONE                 = 0x00000000,
        FLYCAPTURE_IMAGE_FILTER_SCORPION_CROSSTALK   = 0x00000001,
        FLYCAPTURE_IMAGE_FILTER_ALL                  = 0xFFFFFFFF,


    FlyCaptureError flycaptureInitializePlus(FlyCaptureContext   context, unsigned long       ulBusIndex, unsigned long       ulNumBuffers, unsigned char**     arpBuffers )
    FlyCaptureError flycaptureInitializeFromSerialNumberPlus(FlyCaptureContext   context,
                         FlyCaptureCameraSerialNumber serialNumber,
                         unsigned long       ulNumBuffers,
                         unsigned char**     arpBuffers )
    FlyCaptureError flycaptureInitializeNotify(
                           FlyCaptureContext    context,
                           unsigned long        ulNumEvents,
                           FlyCaptureImageEvent arpEvents[] )


    FlyCaptureError flycaptureStartCustomImagePacket(
                                 FlyCaptureContext       context,
                                 unsigned long	         ulMode,
                                 unsigned long           ulImagePosLeft,
                                 unsigned long           ulImagePosTop,
                                 unsigned long	         ulWidth,
                                 unsigned long	         ulHeight,
                                 unsigned long	         ulPacketSizeBytes,
                                 FlyCapturePixelFormat   format )

    FlyCaptureError flycaptureStartLockNext(
                        FlyCaptureContext    context,
                        FlyCaptureVideoMode  videoMode, 
                        FlyCaptureFrameRate  frameRate )

    FlyCaptureError flycaptureStartLockNextCustomImage(
                                   FlyCaptureContext     context,
                                   unsigned long         ulMode,
                                   unsigned long         ulImagePosLeft,
                                   unsigned long         ulImagePosTop,
                                   unsigned long         ulWidth,
                                   unsigned long	 ulHeight,
                                   float                 fBandwidth,
                                   FlyCapturePixelFormat format )


    FlyCaptureError flycaptureStartLockNextCustomImagePacket(
                                         FlyCaptureContext     context,
                                         unsigned long	       ulMode,
                                         unsigned long         ulImagePosLeft,
                                         unsigned long         ulImagePosTop,
                                         unsigned long	       ulWidth,
                                         unsigned long	       ulHeight,
                                         unsigned long	       ulPacketSizeBytes,
                                         FlyCapturePixelFormat format )

    FlyCaptureError flycaptureSyncForLockNext(
                          FlyCaptureContext* arContexts,
                          unsigned long      ulContexts )

    FlyCaptureError flycaptureLockNext(
                   FlyCaptureContext      context,
                   FlyCaptureImagePlus*   pimage )


    FlyCaptureError flycaptureLockLatest(
                     FlyCaptureContext    context,
                     FlyCaptureImagePlus* pimage )


    FlyCaptureError flycaptureUnlock(
                 FlyCaptureContext  context,
                 unsigned long      ulBufferIndex )

    FlyCaptureError flycaptureUnlockAll(
                    FlyCaptureContext  context )

    FlyCaptureError flycaptureGetImageFilters(FlyCaptureContext   context, unsigned int* puiFilters )


    FlyCaptureError flycaptureSetImageFilters(FlyCaptureContext   context,
                          unsigned int        uiFilters )


    FlyCaptureError flycaptureGetImageTimestamping(FlyCaptureContext  context, bint*  pbOn )


    FlyCaptureError flycaptureSetImageTimestamping(FlyCaptureContext  context, bint bOn )


    FlyCaptureError flycaptureParseImageTimestamp(
                              FlyCaptureContext    context,
                              unsigned char* pData,
                              unsigned int*        puiSeconds,
                              unsigned int*        puiCount,
                              unsigned int*        puiOffset )

    FlyCaptureError flycaptureLockNextEvent(
                        FlyCaptureContext    context,
                        FlyCaptureImage*     pimage,
                        FlyCaptureImageEvent arpEvents[] )


    FlyCaptureError flycaptureWaitForImageEvent(
                            FlyCaptureContext      context,
                            FlyCaptureImageEvent*  pevent, 
                            unsigned long          ulTimeout )


    FlyCaptureError flycaptureUnlockEvent(
                      FlyCaptureContext      context,
                      FlyCaptureImageEvent   arpEvents[] )


    FlyCaptureError flycaptureGetPacketInfo(
                        FlyCaptureContext       context,
                        FlyCaptureVideoMode     videoMode,
                        FlyCaptureFrameRate     frameRate,
                        FlyCapturePacketInfo*   pinfo )


    FlyCaptureError flycaptureGetCustomImagePacketInfo(
                                   FlyCaptureContext     context,
                                   unsigned long	 ulMode,
                                   unsigned long	 ulWidth,
                                   unsigned long	 ulHeight,
                                   FlyCapturePixelFormat format,
                                   FlyCapturePacketInfo* pinfo )

    FlyCaptureError flycaptureReadRegisterBlock(
			    FlyCaptureContext   context,
                            unsigned short      usAddrHigh,
                            unsigned long       ulAddrLow,
                            unsigned long*      pulBuffer,
                            unsigned long       ulLength )
                            

    FlyCaptureError flycaptureWriteRegisterBlock(
                             FlyCaptureContext      context,
                             unsigned short         usAddrHigh,
                             unsigned long          ulAddrLow,
                              unsigned long*   pulBuffer,
                             unsigned long          ulLength )
