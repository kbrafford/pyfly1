//=============================================================================
// Copyright © 2008 Point Grey Research, Inc. All Rights Reserved.
//
// This software is the confidential and proprietary information of Point
// Grey Research, Inc. ("Confidential Information").  You shall not
// disclose such Confidential Information and shall use it only in
// accordance with the terms of the license agreement you entered into
// with PGR.
//
// PGR MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THE
// SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE, OR NON-INFRINGEMENT. PGR SHALL NOT BE LIABLE FOR ANY DAMAGES
// SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING
// THIS SOFTWARE OR ITS DERIVATIVES.
//=============================================================================

//=============================================================================
//
// PGRDirectShow.h
//
//   Defines the API to the PGR FlyStream library.
//
//  We welcome your bug reports, suggestions, and comments:
//  www.ptgrey.com/support/contact
//
//=============================================================================


//=============================================================================
// $Id: PGRDirectShow.h,v 1.3 2009/07/21 23:59:37 mgara Exp $
//=============================================================================

//=============================================================================
// PGR Includes
//=============================================================================
#include "pgrflycapture.h"
#include "pgrflycaptureplus.h"
#include "pgrcameragui.h"



//
// Description:
//  This is a structure to hold DCAM format information
//
struct VideoModes{
	//This stores the video mode as represented in FlyCapture
	FlyCaptureVideoMode videoMode;
	//This stores the framerate as represented in Flycapture
	FlyCaptureFrameRate	frameRate;
	//this stores the width of the image when using the above video mode
	unsigned long		width;
	//this stores the hight of the image when using the above video mode
	unsigned long		hight;
};

//
// Description:
//  This is a structure is returned from the GetAvailableFormats call and
//	it stores the DCAM formats that this camera can use.
//
struct DCAMFormats
{
	VideoModes		videoModes[FLYCAPTURE_NUM_VIDEOMODES];
	unsigned long	numFormats;
};

//
// Description:
//  This is the Interface that allows Users to Set and Get Properties on 
//	the Camera.  You can Querry the FlyStream Capture Filter for the 
//	IID_IFlyCaptureProperties and it will return a pointer to the 
//	IFlyCaptureProperties interface.  Please see the FlyStreamCapEx example.
//

// {2BD99656-1552-4d98-B648-0DD0196D1649}
const IID IID_IFlyCaptureProperties = {0x2bd99656, 0x1552, 0x4d98, {0xb6,0x48,0xd,0xd0,0x19,0x6d,0x16,0x49}};

interface IFlyCaptureProperties : public IUnknown
{
	//=============================================================================
	// DCam Image Format Functions
	//=============================================================================
	// Group = DCam Image Format Functions

	//-----------------------------------------------------------------------------
	//
	// Name: GetAvailableFormats()
	//
	// Description:
	//   This function returns an array of DCam Formats that the Camera supports.
	//
	// Arguments:
	//   pFormats - Array of DCam Formats that the camera supports.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
    STDMETHOD(GetAvailableFormats)(DCAMFormats *pFormats) = 0;

	
	//-----------------------------------------------------------------------------
	//
	// Name: GetImageFormat()
	//
	// Description:
	//   Returnst the index of the format currently set.  The index refers to 
	//	 the index of the videoModes array in the DCAMFormats structure returned
	//	 by a call to GetAvailableFormats().
	//
	// Arguments:
	//   pulFormat - index of currently set format.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetImageFormat)(unsigned long *pulFormat) = 0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetImageFormat()
	//
	// Description:
	//   Sets the index of the format to be used.  The index refers to 
	//	 the index of the videoModes array in the DCAMFormats structure returned
	//	 by a call to GetAvailableFormats().
	//
	// Arguments:
	//   ulFormat - index of the format to be set.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
    STDMETHOD(SetImageFormat)(unsigned long ulFormat) = 0;

	

	//=============================================================================
	// Register Functions
	//=============================================================================
	// Group = Register Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetRegister()
	//
	// Description:
	//   Returns the value in the register specified by an offset.
	//
	// Arguments:
	//   ulOffset - The register address offset.
	//   pulValue - The value stored in the register.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetRegister)(unsigned long ulOffset, unsigned long *pulValue) = 0;

	
	//-----------------------------------------------------------------------------
	//
	// Name: SetRegister()
	//
	// Description:
	//   Sets the value in the register specified by an offset.
	//
	// Arguments:
	//   ulOffset - The register address offset.
	//   ulValue - The value to be stored in the register.
	//   bBroadcast - If the setting should be broadcast.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
    STDMETHOD(SetRegister)(unsigned long ulOffset, unsigned long ulValue, bool bBroadcast = false) = 0;


	//=============================================================================
	// Brightness Functions
	//=============================================================================
	// Group = Brightness Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetBrightness()
	//
	// Description:
	//   Gets the Brightness Value.
	//
	// Arguments:
	//   pBrightness - The Brightness Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetBrightness)(long* pBrightness, bool* pbAuto = NULL )=0;
	
	
	//-----------------------------------------------------------------------------
	//
	// Name: SetBrightness()
	//
	// Description:
	//   Sets the Brightness Value.
	//
	// Arguments:
	//   lBrightness - The Brightness Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetBrightness)(long lBrightness, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetBrightnessRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min Brightness Value.
	//   pMax - The Max Brightness Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetBrightnessRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;
	
	
	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsBrightness()
	//
	// Description:
	//   Gets the Absolute Brightness Value.
	//
	// Arguments:
	//   pBrightness - The Brightness Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsBrightness)(float* pBrightness, bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsBrightness()
	//
	// Description:
	//   Sets the Absolute Brightness Value.
	//
	// Arguments:
	//   lBrightness - The Brightness Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsBrightness)(float lBrightness, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsBrightnessRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  
	//   Also determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min Brightness Value.
	//   pMax - The Absolute Max Brightness Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsBrightnessRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


	//=============================================================================
	// Exposure Functions
	//=============================================================================
	// Group = Exposure Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetExposure()
	//
	// Description:
	//   Gets the Exposure Value.
	//
	// Arguments:
	//   plExposure - The Exposure Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetExposure)(long* plExposure,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetExposure()
	//
	// Description:
	//   Sets the Exposure Value.
	//
	// Arguments:
	//   lExposure - The Exposure Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetExposure)(long lExposure, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetExposureRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min Exposure Value.
	//   pMax - The Max Exposure Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetExposureRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsExposure()
	//
	// Description:
	//   Gets the Absolute Exposure Value.
	//
	// Arguments:
	//   plExposure - The Exposure Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsExposure)(float* plExposure,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsExposure()
	//
	// Description:
	//   Sets the Absolute Exposure Value.
	//
	// Arguments:
	//   lExposure - The Exposure Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsExposure)(float lExposure, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsExposureRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min Exposure Value.
	//   pMax - The Absolute Max Exposure Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsExposureRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


	//=============================================================================
	// Shutter Functions
	//=============================================================================
	// Group = Shutter Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetShutter()
	//
	// Description:
	//   Gets the Shutter Value.
	//
	// Arguments:
	//   plShutter - The Shutter Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetShutter)(long* plShutter,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetShutter()
	//
	// Description:
	//   Sets the Shutter Value.
	//
	// Arguments:
	//   lShutter - The Shutter Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetShutter)(long lShutter, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetShutterRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min Shutter Value.
	//   pMax - The Max Shutter Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetShutterRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsShutter()
	//
	// Description:
	//   Gets the Absolute Shutter Value.
	//
	// Arguments:
	//   plShutter - The Shutter Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsShutter)(float* plShutter,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsShutter()
	//
	// Description:
	//   Sets the Absolute Shutter Value.
	//
	// Arguments:
	//   lShutter - The Shutter Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsShutter)(float lShutter, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsShutterRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min Shutter Value.
	//   pMax - The Absolute Max Shutter Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsShutterRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


	//=============================================================================
	// Sharpness Functions
	//=============================================================================
	// Group = Sharpness Functions

	
	//-----------------------------------------------------------------------------
	//
	// Name: GetSharpness()
	//
	// Description:
	//   Gets the Sharpness Value.
	//
	// Arguments:
	//   plSharpness - The Sharpness Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetSharpness)(long* plSharpness,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetSharpness()
	//
	// Description:
	//   Sets the Sharpness Value.
	//
	// Arguments:
	//   lSharpness - The Sharpness Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetSharpness)(long lSharpness, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetSharpnessRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min Sharpness Value.
	//   pMax - The Max Sharpness Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetSharpnessRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsSharpness()
	//
	// Description:
	//   Gets the Absolute Sharpness Value.
	//
	// Arguments:
	//   plSharpness - The Sharpness Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsSharpness)(float* plSharpness,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsSharpness()
	//
	// Description:
	//   Sets the Absolute Sharpness Value.
	//
	// Arguments:
	//   lSharpness - The Sharpness Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsSharpness)(float lSharpness, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsSharpnessRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min Sharpness Value.
	//   pMax - The Absolute Max Sharpness Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsSharpnessRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


	//=============================================================================
	// Gain Functions
	//=============================================================================
	// Group = Gain Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetGain()
	//
	// Description:
	//   Gets the Gain Value.
	//
	// Arguments:
	//   plGain - The Gain Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetGain)(long* plGain,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetGain()
	//
	// Description:
	//   Sets the Gain Value.
	//
	// Arguments:
	//   lGain - The Gain Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetGain)(long lGain, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetGainRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min Gain Value.
	//   pMax - The Max Gain Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetGainRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsGain()
	//
	// Description:
	//   Gets the Absolute Gain Value.
	//
	// Arguments:
	//   plGain - The Gain Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsGain)(float* plGain,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsGain()
	//
	// Description:
	//   Sets the Absolute Gain Value.
	//
	// Arguments:
	//   lGain - The Gain Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsGain)(float lGain, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsGainRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min Gain Value.
	//   pMax - The Absolute Max Gain Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsGainRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


	//=============================================================================
	// Hue Functions
	//=============================================================================
	// Group = Hue Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetHue()
	//
	// Description:
	//   Gets the Hue Value.
	//
	// Arguments:
	//   plHue - The Hue Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetHue)(long* plHue, bool* pbAuto = NULL )=0;

	
	//-----------------------------------------------------------------------------
	//
	// Name: SetHue()
	//
	// Description:
	//   Sets the Hue Value.
	//
	// Arguments:
	//   lHue - The Hue Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetHue)(long lHue, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetHueRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min Hue Value.
	//   pMax - The Max Hue Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetHueRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsHue()
	//
	// Description:
	//   Gets the Absolute Hue Value.
	//
	// Arguments:
	//   plHue - The Hue Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsHue)(float* plHue, bool* pbAuto = NULL )=0;

	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsHue()
	//
	// Description:
	//   Sets the Absolute Hue Value.
	//
	// Arguments:
	//   lHue - The Hue Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsHue)(float lHue, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsHueRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min Hue Value.
	//   pMax - The Absolute Max Hue Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsHueRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


	//=============================================================================
	// Saturation Functions
	//=============================================================================
	// Group = Saturation Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetSaturation()
	//
	// Description:
	//   Gets the Saturation Value.
	//
	// Arguments:
	//   plSaturation - The Saturation Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetSaturation)(long* plSaturation,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetSaturation()
	//
	// Description:
	//   Sets the Saturation Value.
	//
	// Arguments:
	//   lSaturation - The Saturation Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetSaturation)(long lSaturation, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetSaturationRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min Saturation Value.
	//   pMax - The Max Saturation Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetSaturationRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;

	
	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsSaturation()
	//
	// Description:
	//   Gets the Absolute Saturation Value.
	//
	// Arguments:
	//   plSaturation - The Saturation Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsSaturation)(float* plSaturation,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsSaturation()
	//
	// Description:
	//   Sets the Absolute Saturation Value.
	//
	// Arguments:
	//   lSaturation - The Saturation Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsSaturation)(float lSaturation, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsSaturationRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min Saturation Value.
	//   pMax - The Absolute Max Saturation Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsSaturationRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


	//=============================================================================
	// Gamma Functions
	//=============================================================================
	// Group = Gamma Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetGamma()
	//
	// Description:
	//   Gets the Gamma Value.
	//
	// Arguments:
	//   plGamma - The Gamma Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetGamma)(long* plGamma, bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetGamma()
	//
	// Description:
	//   Sets the Gamma Value.
	//
	// Arguments:
	//   lGamma - The Gamma Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetGamma)(long lGamma, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetGammaRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min Gamma Value.
	//   pMax - The Max Gamma Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetGammaRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsGamma()
	//
	// Description:
	//   Gets the Absolute Gamma Value.
	//
	// Arguments:
	//   plGamma - The Gamma Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsGamma)(float* plGamma, bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsGamma()
	//
	// Description:
	//   Sets the Absolute Gamma Value.
	//
	// Arguments:
	//   lGamma - The Gamma Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsGamma)(float lGamma, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsGammaRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min Gamma Value.
	//   pMax - The Absolute Max Gamma Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsGammaRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


	//=============================================================================
	// Pan Functions
	//=============================================================================
	// Group = Pam Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetPan()
	//
	// Description:
	//   Gets the Pan Value.
	//
	// Arguments:
	//   plPan - The Pan Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetPan)(long* plPan,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetPan()
	//
	// Description:
	//   Sets the Pan Value.
	//
	// Arguments:
	//   lPan - The Pan Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetPan)(long lPan, bool bAuto = false)=0;

	
	//-----------------------------------------------------------------------------
	//
	// Name: GetPanRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min Pan Value.
	//   pMax - The Max Pan Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetPanRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;

	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsPan()
	//
	// Description:
	//   Gets the Absolute Pan Value.
	//
	// Arguments:
	//   plPan - The Pan Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsPan)(float* plPan,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsPan()
	//
	// Description:
	//   Sets the Absolute Pan Value.
	//
	// Arguments:
	//   lPan - The Pan Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsPan)(float lPan, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsPanRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min Pan Value.
	//   pMax - The Absolute Max Pan Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsPanRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


	//=============================================================================
	// Tilt Functions
	//=============================================================================
	// Group = Tilt Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetTilt()
	//
	// Description:
	//   Gets the Tilt Value.
	//
	// Arguments:
	//   plTilt - The Tilt Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetTilt)(long* plTilt,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetTilt()
	//
	// Description:
	//   Sets the Tilt Value.
	//
	// Arguments:
	//   lTilt - The Tilt Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetTilt)(long lTilt, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetTiltRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min Tilt Value.
	//   pMax - The Max Tilt Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetTiltRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsTilt()
	//
	// Description:
	//   Gets the Absolute Tilt Value.
	//
	// Arguments:
	//   plTilt - The Tilt Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsTilt)(float* plTilt,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsTilt()
	//
	// Description:
	//   Sets the Absolute Tilt Value.
	//
	// Arguments:
	//   lTilt - The Tilt Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsTilt)(float lTilt, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsTiltRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min Tilt Value.
	//   pMax - The Absolute Max Tilt Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsTiltRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


    //=============================================================================
	// WhiteBalance Functions
	//=============================================================================
	// Group = WhiteBalance Functions


	//-----------------------------------------------------------------------------
	//
	// Name: GetWhiteBalance()
	//
	// Description:
	//   Gets the WhiteBalance Value.
	//
	// Arguments:
	//   plWhiteBalance - The WhiteBalance Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetWhiteBalance)(long* plWhiteBalance,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetWhiteBalance()
	//
	// Description:
	//   Sets the WhiteBalance Value.
	//
	// Arguments:
	//   lWhiteBalance - The WhiteBalance Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetWhiteBalance)(long lWhiteBalance, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetWhiteBalanceRange()
	//
	// Description:
	//   Gets the Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Min WhiteBalance Value.
	//   pMax - The Max WhiteBalance Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetWhiteBalanceRange)(long* pMin,long* pMax, bool* pbAutoSupported = NULL)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsWhiteBalance()
	//
	// Description:
	//   Gets the Absolute WhiteBalance Value.
	//
	// Arguments:
	//   plWhiteBalance - The WhiteBalance Value.
	//   pbAuto - Is Auto enabled? (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsWhiteBalance)(float* plWhiteBalance,bool* pbAuto = NULL )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetAbsWhiteBalance()
	//
	// Description:
	//   Sets the Absolute WhiteBalance Value.
	//
	// Arguments:
	//   lWhiteBalance - The WhiteBalance Value.
	//   bAuto - Enable Auto Mode for this param. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetAbsWhiteBalance)(float lWhiteBalance, bool bAuto = false)=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetAbsWhiteBalanceRange()
	//
	// Description:
	//   Gets the Abslute Min and Max values that this parameter can be set to.  Also 
	//   determines if Auto mode is supported.
	//
	// Arguments:
	//   pMin - The Absolute Min WhiteBalance Value.
	//   pMax - The Absolute Max WhiteBalance Value.
	//   pbAutoSupported - Is Auto mode supported for this parameter? (Optional)
	//   pUnits - Specifies the absolute units used for this parameter. (Optional)
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetAbsWhiteBalanceRange)(float* pMin,float* pMax, bool* pbAutoSupported = NULL,const char** pUnits = NULL)=0;


	//=============================================================================
	// Custom Image Functions
	//=============================================================================
	// Group = Custom Image Functions

	//-----------------------------------------------------------------------------
	//
	// Name: GetOutputVerticalFlip()
	//
	// Description:
	//   Returns whether or not the image is being flipped vertically.  The 
	//   returned flag is either true or false depending if we are flipping 
	//   or not flipping the image vertically.
	//
	// Arguments:
	//   pbFlag - Is the image being flipped vertically
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetOutputVerticalFlip)(bool* pbFlag )=0;

	//-----------------------------------------------------------------------------
	//
	// Name: SetOutputVerticalFlip()
	//
	// Description:
	//   Sets whether or not the image is to be flipped vertically.  If the
	//   flag is set to true, the image will be flipped vertically.
	//
	// Arguments:
	//   pbFlag - Flag to turn on vertical flipping of the output image.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetOutputVerticalFlip)(bool bFlag  )=0;

	//-----------------------------------------------------------------------------
	//
	// Name: GetCustomImageMode()
	//
	// Description:
	//   Gets the Custom Image State of the Camera.  The returned flag is either 
	//   true or false depending if the camera is in custom image mode or not.
	//
	// Arguments:
	//   pbFlag - Is the camera in Custom Image mode.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetCustomImageMode)(bool* pbFlag )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetCustomImageMode()
	//
	// Description:
	//   Sets the Custom Image State of the Camera.  If the flag is either set to 
	//   true the camera will be put into Custom Image mode.
	//
	// Arguments:
	//   pbFlag - Flag to turn custom image mode on.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetCustomImageMode)(bool bFlag  )=0;

	
	//-----------------------------------------------------------------------------
	//
	// Name: QueryCustomImage()
	//
	// Description:
	//   Gets Information about a certain Custom Image setup.  The values will
	//   return maximum size of image and also what formats are supported.
	//
	// Arguments:
	//   uiMode - What Custom Image Mode to Querry.
	//   pbAvailable - Is this Configuration supported by this camera?
	//   puiMaxWidth - Maximum image width supported by this camera.
	//   puiMaxHight - Maximum image hight supported by this camera.
	//   puiPixFormats - A bitwise mask of all the FlyCapturePixelFormat's supported.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(QueryCustomImage)(unsigned int uiMode,bool* pbAvailable,unsigned int* puiMaxWidth,unsigned int* puiMaxHight, unsigned int* puiPixFormats )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: SetCustomImage()
	//
	// Description:
	//   Sets the specifics of the Custom Image that will stream.
	//
	// Arguments:
	//   uiMode - What Custom Image Mode to use.
	//   uiLeft - This is the (x) pixel offset from the left of the ccd.
	//   uiTop - This is the (y) pixel offset from the top of the ccd.
	//   uiWidth - image width to be set.
	//   uiHight - image hight to be set.
	//   uiPixFormat - The FlyCapturePixelFormat to be set.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(SetCustomImage)(unsigned int uiMode,unsigned int uiLeft,unsigned int uiTop,unsigned int uiWidth,unsigned int uiHight, unsigned int uiPixFormat )=0;


	//-----------------------------------------------------------------------------
	//
	// Name: GetCustomImage()
	//
	// Description:
	//   Sets the specifics of the Custom Image that will stream.
	//
	// Arguments:
	//   uiMode - What Custom Image Mode is being used.
	//   uiLeft - This is the (x) pixel offset from the left of the ccd.
	//   uiTop - This is the (y) pixel offset from the top of the ccd.
	//   uiWidth - image width.
	//   uiHight - image hight.
	//   uiPixFormat - The FlyCapturePixelFormat being currently used.
	//
	// Returns:
	//   An HRESULT error code indicating the success or failure of the function.
	//
	STDMETHOD(GetCustomImage)(unsigned int* uiMode,unsigned int* uiLeft,unsigned int* uiTop,unsigned int* uiWidth,unsigned int* uiHight, unsigned int* uiPixFormat )=0;
	

};