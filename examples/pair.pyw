import wx
import Image
import ImageDraw
import ImageFont
import time
import pyfly1
from pyfly1 import Context, ContextPair, FCColorMethod, FCVideoMode, FCFrameRate

class Panel(wx.Panel):
    def __init__(self, parent, my_index, update_rate = 1.0):
        super(Panel, self).__init__(parent, -1)
        self.my_index = my_index
        self.my_bitmap = wx.NullBitmap
        self.panel_count = parent.panel_count
        self.parent = parent
        self.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
        self.Bind(wx.EVT_PAINT, self.on_paint)

    def set_bitmap(self, bitmap):
        self.my_bitmap = bitmap
        self.Refresh()        
        self.Update()

    def create_bitmap(self):
        return self.my_bitmap

    def on_paint(self, event):
        bitmap = self.create_bitmap()
        self.GetParent().check_size(bitmap.GetSize())
        dc = wx.AutoBufferedPaintDC(self)
        try:
            dc.DrawBitmap(bitmap, 0, 0)
        except:
            pass

class Frame(wx.Frame):
    def __init__(self, context):
        style = wx.DEFAULT_FRAME_STYLE & ~wx.RESIZE_BORDER & ~wx.MAXIMIZE_BOX
        super(Frame, self).__init__(None, -1, 'FlyCapture', style=style)

        self.sizer = wx.BoxSizer(wx.HORIZONTAL)
        self.context = context
        self.panel_count = 2
        self.panels = []
        for index in range(self.panel_count):
            p = Panel(self, index)
            self.sizer.Add(p, 1, wx.EXPAND)
            self.panels.append(p)
        self.SetSizerAndFit(self.sizer)
        self.Bind(wx.EVT_CLOSE, self.OnClose)

        self.update_rate = 1.0
        self.count = 0
        self.fps = 0.0
        self.starttime = time.clock()
        self.alive = True
        print self.panels
        wx.CallLater(50, self.update)

    def check_size(self, size):
        w,h = size
        size = w * self.panel_count, h
        if self.GetClientSize() != size:
            self.SetClientSize(size)
            self.Center()

    def update_titlebar(self):
        self.SetTitle("%.2f fps" % self.fps)

    def update(self):
        self.create_bitmaps()
        try:
            self.panels[0].set_bitmap(self.left_bitmap)
            self.panels[1].set_bitmap(self.right_bitmap)
            wx.CallLater(5, self.update)
        except:
            pass

    def create_bitmaps(self):
        left, right, time_left, time_right = self.context.GrabImagePIL()

        left = left.resize((int(1280/self.panel_count), int(960/self.panel_count)), Image.NEAREST)
        right = right.resize((int(1280/self.panel_count), int(960/self.panel_count)), Image.NEAREST)

        width, height = left.size
        left_data = left.convert('RGB').tostring()
        self.left_bitmap = wx.BitmapFromBuffer(width, height, left_data)

        width, height = right.size
        right_data = right.convert('RGB').tostring()
        self.right_bitmap = wx.BitmapFromBuffer(width, height, right_data)

        print "Got bitmaps! %.5f %.5f" % (time_left, time_right)

        # timekeeping
        self.count += 1
        now = time.clock()
        elapsed = now - self.starttime
        if elapsed >= self.update_rate:
            self.fps = self.count / elapsed
            self.starttime = now
            self.count = 0
            self.update_titlebar()

    def OnClose(self, event):
        for p in self.panels:
            p.Destroy()
        event.Skip()

def main():    
    video_mode = FCVideoMode._1280x960Y8
    frame_rate = FCFrameRate._15

    # Start the point grey camera(s)
    # This example works with color and
    # monochrome Chameleon models
    camera_info_list = pyfly1.get_camera_information()

    if len(camera_info_list) == 2:        
        context = ContextPair()
        context.SetColorProcessingMethod(FCColorMethod.NEAREST_NEIGHBOR_FAST)
        context.Start(video_mode, frame_rate)
    else:
        print "This demo is designed for precisely two cameras.  I found only",
        print len(camera_info_list), "cameras."
        return

    # now start the wx GUI
    app = wx.App(None)
    frame = Frame(context)
    frame.Center()
    frame.Show()

    app.MainLoop()

    # shut down the cameras
    context.Stop()
    context.Destroy()

if __name__ == '__main__':    
    main()
