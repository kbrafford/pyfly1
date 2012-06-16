import wx
import Image
from pyfly1 import Context, FCColorMethod, FCVideoMode, FCFrameRate

class Panel(wx.Panel):
    def __init__(self, parent, context):
        super(Panel, self).__init__(parent, -1)
        self.context = context
        self.count = 0
        self.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
        self.Bind(wx.EVT_PAINT, self.on_paint)
        self.update()

    def update(self):
        self.Refresh()
        self.Update()
        wx.CallLater(1, self.update)

    def create_bitmap(self):
        print self.count
        self.count += 1.5
        if self.count >= 360:
            self.count = 0
        #image = self.context.GrabImagePIL().resize((1280/2, 960/2), Image.BICUBIC).resize((1280/3, 960/3), Image.BICUBIC).rotate(self.count, Image.BICUBIC)
        image = self.context.GrabImagePIL()
        print image.size
        width, height = image.size
        data = image.convert('RGB').tostring()
        bitmap = wx.BitmapFromBuffer(width, height, data)
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
        Panel(self, context)
    def check_size(self, size):
        if self.GetClientSize() != size:
            self.SetClientSize(size)
            self.Center()

def main():
    # Start the point grey camera
    context = Context.from_index(0)
    context.SetColorProcessingMethod(FCColorMethod.EDGE_SENSING)
    context.Start(FCVideoMode._1280x960Y8, FCFrameRate._15)

    # now start the wx GUI
    app = wx.App(None)
    frame = Frame(context)
    frame.Center()
    frame.Show()
    try:
        app.MainLoop()
    except:
        print "boosh!"
    finally:
        # shut down the camera
        context.Stop()
        context.Destroy()

if __name__ == '__main__':
    main()