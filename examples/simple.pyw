import wx
import Image
import ImageDraw
import ImageFont
import time
import pyfly1
from pyfly1 import Context, FCColorMethod, FCVideoMode, FCFrameRate

class Panel(wx.Panel):
    def __init__(self, parent, context, my_index, font, update_rate = 1.0):
        super(Panel, self).__init__(parent, -1)
        self.context, self.serial = context
        self.serial = str(self.serial)
        self.my_index = my_index
        self.panel_count = parent.panel_count
        self.parent = parent
        self.font = font
        self.update_rate = update_rate
        self.count = 0
        self.fps = 0.0
        self.starttime = time.clock()
        self.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
        self.Bind(wx.EVT_PAINT, self.on_paint)
        self.update()
    def update_titlebar(self):
        self.parent.SetTitle("PyFly1 - simple example (%.2f fps)" % self.fps)
    def update(self):
        self.Refresh()
        self.Update()
        wx.CallLater(5, self.update)

    def create_bitmap(self):
        image, timestamp, acq, post = self.context.GrabImagePIL(bypass = False)
        print self.my_index, timestamp
        #image = image.resize((int(1280/self.panel_count), int(960/self.panel_count)), Image.NEAREST)
        image = image.resize((int(1280/2), int(960/2)), Image.NEAREST)

        #image = self.context.GrabImagePIL(transpose = Image.FLIP_TOP_BOTTOM)
         
        # ImageDraw.text() function causes MASSIVE memory leak       
        #draw = ImageDraw.Draw(image)
        #draw.text((12,12), self.serial, font = self.font, fill='rgb(100, 100, 100)')        
        #draw.text((10,10), self.serial, font = self.font, fill='rgb(200, 255, 255)')
        #del draw

        width, height = image.size
        data = image.convert('RGB').tostring()
        bitmap = wx.BitmapFromBuffer(width, height, data)

        # timekeeping
        if self.my_index == 0:        
            self.count += 1
            now = time.clock()
            elapsed = now - self.starttime
            if elapsed >= self.update_rate:
                self.fps = self.count / elapsed
                self.starttime = now
                self.count = 0
                self.update_titlebar()

        return bitmap

    def on_paint(self, event):
        bitmap = self.create_bitmap()
        self.GetParent().check_size(bitmap.GetSize())
        dc = wx.AutoBufferedPaintDC(self)
        dc.DrawBitmap(bitmap, 0, 0)

class ControlPanel(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent, -1)
        self.sizer = wx.BoxSizer(wx.HORIZONTAL)
        self.auto_button = wx.CheckBox(self, -1, "Auto")
        self.onoff_button = wx.CheckBox(self, -1, "On/Off")
        self.sizer.AddStretchSpacer()
        self.sizer.Add(self.auto_button, 0, wx.RIGHT | wx.ALIGN_CENTER_VERTICAL, 5)
        self.sizer.Add(self.onoff_button, 0, wx.RIGHT | wx.ALIGN_CENTER_VERTICAL, 5)
        self.SetSizerAndFit(self.sizer)
        self.SetMinSize((-1, 20))

class Frame(wx.Frame):
    def __init__(self, contexts):
        style = wx.DEFAULT_FRAME_STYLE & ~wx.RESIZE_BORDER & ~wx.MAXIMIZE_BOX
        super(Frame, self).__init__(None, -1, 'FlyCapture', style=style)
        self.contexts = contexts
        self.controlpanel = ControlPanel(self)
        self.controlpanel.auto_button.Bind(wx.EVT_CHECKBOX, self.OnButton)
        self.controlpanel.onoff_button.Bind(wx.EVT_CHECKBOX, self.OnButton)        
        self.mainsizer = wx.BoxSizer(wx.VERTICAL)
        self.sizer = wx.BoxSizer(wx.HORIZONTAL)
        font = ImageFont.truetype("arial.ttf", 20)
        self.panel_count = len(contexts)
        self.panels = []
        for index, context in enumerate(contexts):
            p = Panel(self, context, index, font)
            self.sizer.Add(p, 1, wx.EXPAND)
            self.panels.append(p)
        self.mainsizer.Add(self.sizer, 1, wx.EXPAND)
        self.mainsizer.Add(self.controlpanel, 0, wx.EXPAND)
        self.SetSizerAndFit(self.mainsizer)
        self.Bind(wx.EVT_CLOSE, self.OnClose)        
    def check_size(self, size):
        w,h = size
        size = w * self.panel_count, h
        if self.GetClientSize() != size:
            self.SetClientSize(size)
            self.Center()
    def OnClose(self, event):
        for p in self.panels:
            p.Destroy()
        event.Skip()
    def OnButton(self, event):
        for context, sn in self.contexts:    
            p = context.GetCameraPropertyEx(pyfly1.FCProperty.AUTO_EXPOSURE)
            auto, on_off = self.controlpanel.auto_button.GetValue(), self.controlpanel.onoff_button.GetValue()
            context.SetCameraPropertyEx(pyfly1.FCProperty.AUTO_EXPOSURE, 
                                        one_push = False,
                                        on_off = on_off,
                                        auto = auto,
                                        a=p.a,
                                        b=p.b)

        
        
        
def main():    
    video_mode = FCVideoMode._1280x960Y8
    frame_rate = FCFrameRate._15

    # Start the point grey camera(s)
    # This example works with color and
    # monochrome Chameleon models
    camera_info_list = pyfly1.get_camera_information()

    contexts = []
    for index, info in enumerate(camera_info_list):    
        context,serial = Context.from_index(index),info["ModelName"] + " - S/N " + str(info["SerialNumber"])
        context.SetColorProcessingMethod(FCColorMethod.EDGE_SENSING)
        context.Start(video_mode, frame_rate)
        contexts.append((context,serial))
 
    # now start the wx GUI
    app = wx.App(None)
    frame = Frame(contexts)
    frame.Center()
    frame.Show()

    app.MainLoop()

    # shut down the cameras
    for context, serial in contexts:
        context.Stop()
        context.Destroy()

if __name__ == '__main__':    
    main()