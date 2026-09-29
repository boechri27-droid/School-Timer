using Toybox.WatchUi;
using Toybox.Graphics;

class SchoolTimerCodeView extends WatchUi.View {

    private var _qrBitmapReference;

    function initialize() {
        View.initialize();
        // Load the updated 250x250 QR code graphic resource from memory
        _qrBitmapReference = WatchUi.loadResource(Rez.Drawables.SchoolQRCode);
    }

    function onUpdate(dc) {
        // High contrast pure black backdrop ensures zero border bleed on the AMOLED panel
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        // DRAW FULL-SIZE QR CODE IMAGE
        if (_qrBitmapReference != null) {
            // Your new image is 250x250 pixels. 
            // Subtracting half its width/height (125) centers it perfectly on your round screen.
            var drawX = (width / 2) - 125;
            var drawY = (height / 2) - 125;
            
            dc.drawBitmap(drawX, drawY, _qrBitmapReference);
        }
    }
}
