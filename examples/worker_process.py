import zmq
import Image

#
# PORTSET is the PULL and PUSH ports for
# the different workers
#
# i.e. worker 0 pulls from port 5557 and pushes on port 5558, etc.
#
PORTSET = (
           (5557, 5558),
           (5559, 5560),
           (5561, 5562),
           (5563, 5564),
           (5565, 5566),
           (5567, 5568),
           (5569, 5570),
           )

def send_image(socket, im, flags=0, copy=False, track=False):
    """send a PIL image with metadata"""
    md = dict(
        size = im.size,
        mode = im.mode,
    )
    socket.send_json(md, flags|zmq.SNDMORE)    
    return socket.send(im.tostring(), flags, copy=copy, track=track)

def recv_image(socket, flags=0, copy=False, track=False):
    """recv a PIL image"""
    md = socket.recv_json(flags=flags)
    data = socket.recv(flags=flags, copy=copy, track=track)
    im = Image.fromstring(md["mode"], md["size"], data)
    return im


def worker_process(id=0):
    PULL_PORT, PUSH_PORT = PORTSET[id]

    zmq_context = zmq.Context()

    zmq_receiver = zmq_context.socket(zmq.PULL)
    zmq_receiver.setsockopt(zmq.HWM, 2)    
    zmq_receiver.connect("tcp://127.0.0.1:%d" % PULL_PORT)        

    zmq_sender = zmq_context.socket(zmq.PUSH)
    zmq_sender.setsockopt(zmq.HWM, 2)
    zmq_sender.bind("tcp://127.0.0.1:%d" % PUSH_PORT)        

    while True:
        print "receiving image"
        im = recv_image(zmq_receiver)

        # do the work on the image
        om = im.resize((int(1280/1.5), int(960/1.5)), Image.BICUBIC)
        om = om.resize((int(1280/2.5), int(960/2.5)), Image.BICUBIC)
        om = om.resize((int(1280/3.75), int(960/3.75)), Image.BICUBIC)
        om = om.resize((int(1280/2), int(960/2)), Image.BICUBIC)

        # now send it forward
        print "sending image"
        send_image(zmq_sender, om)

def process_args():
    import argparse
    parser = argparse.ArgumentParser(description="pyfly1 worker process")
    
    parser.add_argument('id',
                        metavar='id',
                        type=int,
                        default = 0,
                        help="worker id (0, 1, 2, ... etc)")

    return parser.parse_args()

if __name__ == "__main__":
    switches = process_args()

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
    #setpriority(priority=3)

    print "kicking off worker id =", switches.id
    worker_process(id = switches.id)