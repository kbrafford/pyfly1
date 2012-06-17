import wx
import Image
import numpy
import time
import zmq
import threading

#from  multiprocessing import Process
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



def send_image(socket, im, flags=0, copy=True, track=False):
    """send a PIL image with metadata"""
    md = dict(
        size = im.size,
        mode = im.mode,
    )
    socket.send_json(md, flags|zmq.SNDMORE)    
    return socket.send(im.tostring(), flags, copy=copy, track=track)

def recv_image(socket, flags=0, copy=True, track=False):
    """recv a PIL image"""
    md = socket.recv_json(flags=flags)
    data = socket.recv(flags=flags, copy=copy, track=track)
    im = Image.fromstring(md["mode"], md["size"], data)
    return im





class CommsThread(threading.Thread):
    def __init__(self, window, num_workers):
        super(CommsThread, self).__init__()
        self.window = window
        self.num_workers = num_workers
        self.Kill = False
        self.setDaemon(True)
        
    def run(self):
        print "thread started!"
        zmq_context = zmq.Context()
        my_sockets = []
        for i in range(self.num_workers):
            zmq_receiver = zmq_context.socket(zmq.PULL)
            zmq_receiver.setsockopt(zmq.HWM, 2)            
            zmq_receiver.connect("tcp://127.0.0.1:%d" % PORTSET[i][1])
            my_sockets.append(zmq_receiver)

        while self.Kill == False:
            for s in my_sockets:            
                print "thread recv"
                image = recv_image(s)
                wx.CallAfter(self.window.new_image, image)

class Panel(wx.Panel):
    def __init__(self, parent, update_rate = 1.0):
        super(Panel, self).__init__(parent, -1)
        self.parent = parent
        self.update_rate = update_rate
        self.count = 0
        self.fps = 0.0
        self.image = None
        self.starttime = time.clock()
        self.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
        self.Bind(wx.EVT_PAINT, self.on_paint)
        self.update()
    def update_titlebar(self):
        self.parent.SetTitle("(%.2f fps) PyFly1 - heavy calculation, naive example" % self.fps)
    def update(self):
        self.Refresh()
        self.Update()
    def new_image(self, image):
        self.image = image
        self.update()        
    def create_bitmap(self):
        image = self.image
        print "just recv'd"
        
        if image:
            width, height = image.size
            data = image.convert('RGB').tostring()
            bitmap = wx.BitmapFromBuffer(width, height, data)
    
            # timekeeping        
            self.count += 1
            now = time.clock()
            elapsed = now - self.starttime
            if elapsed >= self.update_rate:
                self.fps = self.count / elapsed
                self.starttime = now
                self.count = 0
                self.update_titlebar()        
            return bitmap
        else:
            return wx.NullBitmap

    def on_paint(self, event):
        bitmap = self.create_bitmap()
        if bitmap != wx.NullBitmap:
            self.GetParent().check_size(bitmap.GetSize())
            dc = wx.AutoBufferedPaintDC(self)
            dc.DrawBitmap(bitmap, 0, 0)
            print "good bmp"
        else:
            dc = wx.PaintDC(self)
            print "bad bmp"
            

class Frame(wx.Frame):
    def __init__(self, num_workers):
        style = wx.DEFAULT_FRAME_STYLE & ~wx.RESIZE_BORDER & ~wx.MAXIMIZE_BOX
        super(Frame, self).__init__(None, -1, 'FlyCapture', style=style)
        self.panel = Panel(self)
        self.thread = CommsThread(self.panel, num_workers)
        self.Bind(wx.EVT_CLOSE, self.OnClose)

        wx.CallLater(500, self.later)

    def later(self):
        self.thread.start()

    def check_size(self, size):
        if self.GetClientSize() != size:
            self.SetClientSize(size)
            self.Center()
    def OnClose(self, event):
        self.panel.Destroy()
        event.Skip()

def main():
    # start the wx GUI
    app = wx.App(None)
    frame = Frame(4)
    frame.Center()
    frame.Show()

    #Process(target=camera_process, args=tuple()).start()
    #Process(target=worker_process, args=tuple()).start()
    
    app.MainLoop()

if __name__ == '__main__':
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

    setpriority(priority = 3)
    main()