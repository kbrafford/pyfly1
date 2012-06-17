pyfly1
======

A Python wrapper for Point Grey Research's FlyCapture v1 API

Status
------

This wrapper is currently under development.

work done
~~~~~~~~~

- usable support for Point Grey Chameleon USB 2.0 cameras (colour and monochrome)
- Context setup
- Camera start
- grab FlyCapture image as PIL image
- grab FlyCapture image Numpy array

missing features
~~~~~~~~~~~~~~~~

- support for Firewire, USB 3.0, and Gig-E cameras

Requirements
------------

- python
- cython
- Point Grey Research's FlyCapture SDK with V1 API


Building and Installation
-------------------------

1) checkout pyfly1 project repo

2) to run the examples, you will want pyfly1.pyd (the output of the Cython build process)
   to be on your python path.  So, I recommend adding the src dir of the repo's src dir
   by creating a file called "default.pth" in your python directory, with this line in it:
   
   C:\Path\To\Pyfly1Repo\src
   
   For instance, I have a file called "default.pth" in my C:\Python27 directory, with this
   one line of content in it:
   
   C:\Users\Keith\Documents\GitHub\pyfly1\src
   
3) Install the FlyCapture software

   - install sdk from Point Grey Research
   - copy PGRFlyCapture.dll into pyfly1/src directory

3) python setup.py build_ext --inplace

   (rerun last command whenever cython extension has changed)


Examples
--------

The examples use wx.Python and PIL to show the working module.

1)  *simple.py* is a straightforward demonstration of Chameleon camera access. It shows multiple cameras
    if they are avaialable

2)  *heavycalc_naive.py* does some deliberately heavy maths on the camera image

3)  *camera_process*, *worker_process*, *heavycalc_pipelined* implement a multi processor heavy calculation
    solution that shows that on a multicore machine zero-mq can improve system performance

License:
--------

MIT

Tested Platforms
----------------
 
 * Python 2.7 (32-bit), windows 7-64, Point Grey Research 32-bit SDK

(C) Keith Brafford 2012

