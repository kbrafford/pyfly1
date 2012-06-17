import zmq
import socket
import mmap

from pyfly1 import Context, FCColorMethod, FCVideoMode, FCFrameRate

PORTSET = (
           (5557, 5558),
           (5559, 5560),
           (5561, 5562),
           (5563, 5564),
           (5565, 5566),
           (5567, 5568),
           (5569, 5570),
           )

def setpriority(pid=None,priority=1):
    """ Set The Priority of a Windows Process.  Priority is a value between 0-5 where
        2 is normal priority.  Default sets the priority of the current
        python process but can take any valid process ID. """
        
    import win32api,win32process,win32con
    
    priorityclasses = [win32process.IDLE_PRIORITY_CLASS,
                       win32process.BELOW_NORMAL_PRIORITY_CLASS,
                       win32process.NORMAL_PRIORITY_CLASS,
                       win32process.ABOVE_NORMAL_PRIORITY_CLASS,
                       win32process.HIGH_PRIORITY_CLASS,
                       win32process.REALTIME_PRIORITY_CLASS]
    if pid == None:
        pid = win32api.GetCurrentProcessId()
    handle = win32api.OpenProcess(win32con.PROCESS_ALL_ACCESS, True, pid)
    win32process.SetPriorityClass(handle, priorityclasses[priority])

def send_image(socket, im, flags=0, copy=False, track=False):
    """send a PIL image with metadata"""
    md = dict(
        size = im.size,
        mode = im.mode,
    )
    socket.send_json(md, flags|zmq.SNDMORE)    
    return socket.send(im.tostring(), flags, copy=copy, track=track)

def camera_process(num_workers = 1):
    num_workers = num_workers

    flycontext = Context.from_index(0)
    flycontext.SetColorProcessingMethod(FCColorMethod.EDGE_SENSING)
    flycontext.Start(FCVideoMode._1280x960Y8, FCFrameRate._15)

    zmq_context = zmq.Context()
    
    my_sockets = []
    for i in range(num_workers):
        zmq_sender = zmq_context.socket(zmq.PUSH)
        zmq_sender.setsockopt(zmq.HWM, 2)            
        zmq_sender.bind("tcp://127.0.0.1:%d" % PORTSET[i][0])
        my_sockets.append(zmq_sender)
    
    while True:
        for s in my_sockets:            
            print "grabbing image"
            image = flycontext.GrabImagePIL()
    
            print "sending image"
            send_image(s, image)    

def process_args():
    import argparse
    parser = argparse.ArgumentParser(description="pyfly1 camera process")

    parser.add_argument('num_workers',
                        metavar='num_workers',
                        type=int,
                        default = 1,
                        help="number of workers")

    return parser.parse_args()

if __name__ == "__main__":
    switches = process_args()

    setpriority(priority=3)
    camera_process(num_workers = switches.num_workers)