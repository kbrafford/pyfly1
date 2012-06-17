import wx
import Image
import ImageDraw
import ImageFont
import time
import pyfly1
from pyfly1 import Context, FCColorMethod, FCVideoMode, FCFrameRate

class Panel(wx.Panel):
    def __init__(self, parent, context, update_rate = 1.0):
        super(Panel, self).__init__(parent, -1)
        self.context = context
        self.parent = parent
        self.update_rate = update_rate
        self.count = 0
        self.fps = 0.0
        self.font = ImageFont.truetype("arial.ttf", 20)    
        self.starttime = time.clock()
        self.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
        self.Bind(wx.EVT_PAINT, self.on_paint)
        self.update()
    def update_titlebar(self):
        self.parent.SetTitle("(%.2f fps) PyFly1 - heavy calculation, naive example" % self.fps)
    def update(self):
        self.Refresh()
        self.Update()
        wx.CallLater(5, self.update)
    def create_bitmap(self):
        image = self.context.GrabImagePIL()
        image = image.resize((int(1280/1.5), int(960/1.5)), Image.BICUBIC)
        image = image.resize((int(1280/2.5), int(960/2.5)), Image.BICUBIC)
        image = image.resize((int(1280/3.75), int(960/3.75)), Image.BICUBIC)
        image = image.resize((int(1280/2), int(960/2)), Image.BICUBIC)

        #draw = ImageDraw.Draw(image)
        #draw.text((10,10), "Hello, children", font = self.font, fill='rgb(200, 255, 255)')

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

    def on_paint(self, event):
        bitmap = self.create_bitmap()
        self.GetParent().check_size(bitmap.GetSize())
        dc = wx.AutoBufferedPaintDC(self)
        dc.DrawBitmap(bitmap, 0, 0)

class Frame(wx.Frame):
    def __init__(self, context):
        style = wx.DEFAULT_FRAME_STYLE & ~wx.RESIZE_BORDER & ~wx.MAXIMIZE_BOX
        super(Frame, self).__init__(None, -1, 'FlyCapture', style=style)
        self.panel = Panel(self, context)
        self.Bind(wx.EVT_CLOSE, self.OnClose)        
    def check_size(self, size):
        if self.GetClientSize() != size:
            self.SetClientSize(size)
            self.Center()
    def OnClose(self, event):
        self.panel.Destroy()
        event.Skip()

def main():
    context = Context.from_index(0)
    context.SetColorProcessingMethod(FCColorMethod.EDGE_SENSING)
    context.Start(FCVideoMode._1280x960Y8, FCFrameRate._15)

    # now start the wx GUI
    app = wx.App(None)
    frame = Frame(context)
    frame.Center()
    frame.Show()

    app.MainLoop()

    # shut down the camera
    context.Stop()
    context.Destroy()

if __name__ == '__main__':    
    main()