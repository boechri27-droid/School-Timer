using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;

(:glance)
class SchoolTimerGlanceView extends WatchUi.GlanceView {

    function initialize() {
        GlanceView.initialize();
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var schedule = Logic.getActiveSchedule();
        var statusData = Logic.getStatus(schedule);

        var labelColor = Graphics.COLOR_WHITE;
        if (statusData[:type].equals("transition")) {
            labelColor = Graphics.COLOR_YELLOW;
        } else if (statusData[:type].equals("class")) {
            labelColor = Graphics.COLOR_BLUE;
        } else {
            labelColor = Graphics.COLOR_LT_GRAY;
        }

        // Line 1: Center Status Title
        dc.setColor(labelColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, (height / 2) - 22, Graphics.FONT_GLANCE, statusData[:name], Graphics.TEXT_JUSTIFY_CENTER);

        // Line 2: Minutes Left Calculation (With a robust null-safety wrapper)
        var timeString = "--";
        
        if (!statusData[:type].equals("off") && !statusData[:type].equals("tomorrow")) {
            // FIXED: Verify the key exists and isn't null before performing math operations
            if (statusData[:secondsLeft] != null) {
                var seconds = statusData[:secondsLeft] as Lang.Number;
                var minsLeft = (seconds + 59) / 60; // Clean integer round-up
                timeString = minsLeft.toString() + " min left";
            } else {
                timeString = "-- min left";
            }
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            timeString = statusData[:type].equals("tomorrow") ? "Done" : "--:--";
        }

        dc.drawText(width / 2, (height / 2) + 7, Graphics.FONT_GLANCE, timeString, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
