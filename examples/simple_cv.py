
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

    print "grabbing image"    
    cvimage, timestamp = context.GrabImageCV(bypass = True)

    print "saving image"    
    cv.SaveImage("image.png", cvimage)

    print "shutting down"    
    context.Stop()
    context.Destroy()

if __name__ == '__main__':    
    main()