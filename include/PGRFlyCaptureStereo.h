//=============================================================================
// Copyright © 2005 Point Grey Research, Inc. All Rights Reserved.
// 
// This software is the confidential and proprietary information of Point
// Grey Research, Inc. ("Confidential Information").  You shall not
// disclose such Confidential Information and shall use it only in
// accordance with the terms of the license agreement you entered into
// with Point Grey Research Inc.
// 
// PGR MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THE
// SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE, OR NON-INFRINGEMENT. PGR SHALL NOT BE LIABLE FOR ANY DAMAGES
// SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING
// THIS SOFTWARE OR ITS DERIVATIVES.
//
// Digiclops® is a registered trademark of Point Grey Research Inc.
//=============================================================================
//=============================================================================
// $Id: PGRFlyCaptureStereo.h,v 1.3 2007/04/16 17:09:56 demos Exp $
//=============================================================================
//=============================================================================
//
// PGRFlyCaptureStereo.h
//
//   Defines the stero functionality of the Flycapture SDK.  
//
//  We welcome your bug reports, suggestions, and comments:
//  www.ptgrey.com/support/contact
//
//=============================================================================
#ifndef __PGRFLYCAPTURESTEREO_H__
#define __PGRFLYCAPTURESTEREO_H__


//=============================================================================
// System Includes
//=============================================================================
#ifdef WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#endif

//=============================================================================
// Project Includes
//=============================================================================
#include "pgrflycapture.h"

#ifdef __cplusplus
extern "C"
{
#endif

//=============================================================================
// Definitions
//=============================================================================

// 32bpp BGRU packed image from the top camera.
#define TOP_IMAGE    0x1
// 32bpp BGRU packed image from the left camera.
#define LEFT_IMAGE   0x2
// 32bpp BGRU packed image from the right camera.
#define RIGHT_IMAGE  0x4
// 24bpp unpacked image from all 3 cameras.
#define STEREO_IMAGE 0x8   
// All images.
#define ALL_IMAGES   ( TOP_IMAGE | LEFT_IMAGE | RIGHT_IMAGE | STEREO_IMAGE )

//
// Description: 
//  An enumeration used to identify the different stereo resolutions that are //  supported by the library.
//
typedef enum StereoImageResolution
{
   STEREO_160x120,	// 160 x 120 resolution.
   STEREO_256x192,	// 256 x 192 resolution.
   STEREO_320x240,      // 320 x 240 resolution.
   STEREO_400x300,      // 400 x 300 resolution.
   STEREO_512x384,	// 512 x 384 resolution.
   STEREO_640x480,      // 640 x 480 resolution.
   STEREO_800x600,	// 800 x 600 resolution.
   STEREO_1024x768,     // 1024 x 768 resolution.
   STEREO_1280x960,     // 1280 x 960 resolution.
} StereoImageResolution;

//
// Description: 
//  The type of the various StereoImageTypes.  These include TOP_IMAGE, 
//  LEFT_IMAGE, RIGHT_IMAGE, and STEREO_IMAGE. 
//
typedef unsigned long StereoImageType;

//-----------------------------------------------------------------------------
//
// Name:  flycaptureGetCalibrationFileFromCamera()
//
// Description:
//   Retrieves the calibration file from the camera.
//
// Arguments:
//   context     - The FlyCapture context to access.
//   pszFileName - A pointer to a string to store the file name in.
//
// Returns:
//   A FlyCaptureError indicating the success or failure of the function.
//
PGRFLYCAPTURE_API FlyCaptureError PGRFLYCAPTURE_CALL_CONVEN 
flycaptureGetCalibrationFileFromCamera( 
				       FlyCaptureContext context, 
				       char** pszFileName );

//-----------------------------------------------------------------------------
//
// Name:  flycapturePrepareStereoImage()
//
// Description:
//   Converts the raw pixel interleaved image captured from a stereo camera
//   into row interleaved format.
//
// Arguments:
//   context     - The FlyCapture context to access.
//   pImage      - The raw FlyCaptureimage captured from a stereo camera.
//   pImageMono  - A FlyCaptureImage image that has been converted. This can
//                 then be passed into triclopsBuildRGBTriclopsInput() to 
//                 create a RGB TriclopsInput.
//   pImageColor - A FlyCaptureImage image that has been converted. This can
//                 then passed into triclopsBuildPackedTriclopsInput() to
//                 create a packed TriclopsInput.
//
// Returns:
//   A FlyCaptureError indicating the success or failure of the function.
//
PGRFLYCAPTURE_API FlyCaptureError PGRFLYCAPTURE_CALL_CONVEN 
flycapturePrepareStereoImage( 
			     FlyCaptureContext context, 
			     FlyCaptureImage pImage, 
			     FlyCaptureImage* pImageMono, 
			     FlyCaptureImage* pImageColor );

#ifdef __cplusplus
};
#endif

#endif // #ifndef __PGRFLYCAPTURESTEREO_H__
