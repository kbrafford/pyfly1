import cv
import pyfly1
import wx

class Panel(wx.Panel):
    def __init__(self, parent, context):
        super(Panel, self).__init__(parent, -1)
        self.context = context
        self.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
        self.Bind(wx.EVT_PAINT, self.on_paint)
        self.update()
        # set up pause here
        self.imageBgnd, timestamp = self.context.GrabImageCV()
    def update(self):
        self.Refresh()
        self.Update()
        wx.CallLater(1, self.update)
    def create_bitmap(self):
        image, timestamp = self.context.GrabImageCV()
        cv.Sub(image,self.imageBgnd,image) #find background
        width, height = cv.GetSize(image)
        data = image.tostring()
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
    context = pyfly1.Context.from_index(0)
    context.SetColorProcessingMethod(pyfly1.FCColorMethod.EDGE_SENSING)
    context.Start(pyfly1.FCVideoMode._1280x960Y8, pyfly1.FCFrameRate._15)
    app = wx.App(None)
    frame = Frame(context)
    frame.Center()
    frame.Show()
    app.MainLoop()
    context.Stop()

if __name__ == '__main__':
    main()
