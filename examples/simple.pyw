import wx
import Image
import ImageDraw
import ImageFont
import time
import pyfly1
from pyfly1 import Context, FCColorMethod, FCVideoMode, FCFrameRate

class Panel(wx.Panel):
    def __init__(self, parent, context, my_index, update_rate = 1.0):
        super(Panel, self).__init__(parent, -1)
        self.context, self.serial = context
        self.serial = str(self.serial)
        self.my_index = my_index
        self.parent = parent
        self.font = ImageFont.truetype("arial.ttf", 20)
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
        image = self.context.GrabImagePIL().resize((int(1280/2), int(960/2)), Image.NEAREST)
        draw = ImageDraw.Draw(image)
        draw.text((10,10), self.serial, font = self.font, fill='rgb(200, 255, 255)')
        #image = self.context.GrabImagePIL()
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

class Frame(wx.Frame):
    def __init__(self, contexts):
        style = wx.DEFAULT_FRAME_STYLE & ~wx.RESIZE_BORDER & ~wx.MAXIMIZE_BOX
        super(Frame, self).__init__(None, -1, 'FlyCapture', style=style)
        self.sizer = wx.BoxSizer(wx.HORIZONTAL)
        self.panel_count = len(contexts)
        self.panels = []
        for index, context in enumerate(contexts):
            p = Panel(self, context, index)
            self.sizer.Add(p, 1, wx.EXPAND)
            self.panels.append(p)
        self.SetSizerAndFit(self.sizer)
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

def main():    
    # Start the point grey camera(s)
    # This example works with color and
    # monochrome Chameleon models
    camera_info_list = pyfly1.get_camera_information()
 
    contexts = []
    for index, info in enumerate(camera_info_list):    
        context,serial = Context.from_index(index),info["ModelName"] + " - " + str(info["SerialNumber"])
        context.SetColorProcessingMethod(FCColorMethod.EDGE_SENSING)
        context.Start(FCVideoMode._1280x960Y8, FCFrameRate._15)
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