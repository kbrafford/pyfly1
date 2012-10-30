import time
import pyfly1
import cv
from pyfly1 import Context, FCColorMethod, FCVideoMode, FCFrameRate

def main():    
    video_mode = FCVideoMode._1280x960Y8
    frame_rate = FCFrameRate._15

    print "Getting context"
    context = Context.from_index(0)
    
    print "Setting color mode"
    context.SetColorProcessingMethod(FCColorMethod.EDGE_SENSING)
    
    print "Starting video mode"
    context.Start(video_mode, frame_rate)

    print "Sleeping for a bit"
    time.sleep(.1)

    start_time = time.clock()    
    print "grabbing image (Bypass == True)"    
    cvimage, timestamp = context.GrabImageCV(bypass = True)
    duration = time.clock() - start_time
    print "image acquired in %.5fms" % (duration * 1000.0)

    for i in range(10):
        start_time = time.clock()    
        print "grabbing another image (Bypass == True)"    
        cvimage, timestamp = context.GrabImageCV(bypass = False, grayscale = True)
        duration = time.clock() - start_time
        print "image acquired in %.5fms" % (duration * 1000.0)

    print "saving image"    
    cv.SaveImage("image.png", cvimage)

    print "shutting down"    
    context.Stop()
    context.Destroy()

if __name__ == '__main__':    
    main()