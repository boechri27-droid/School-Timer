using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Timer;
using Toybox.Lang;

class SchoolTimerView extends WatchUi.View {

    private var _statusData = { :name => "No School", :secondsLeft => 0, :type => "off", :next => "" };
    private var _uiTimer as Timer.Timer?;
    private var _lastKnownSchedule = "";

    function initialize() {
        View.initialize();
        _lastKnownSchedule = State.getSafeScheduleName();
    }

    function onShow() {
        _uiTimer = new Timer.Timer();
        _uiTimer.start(method(:refreshScreen) as Lang.Method, 1000, true);
    }

    function refreshScreen() as Void {
        var currentSched = State.getSafeScheduleName();
        if (!currentSched.equals(_lastKnownSchedule)) {
            _lastKnownSchedule = currentSched;
        }
        WatchUi.requestUpdate();
    }

        function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var schedule = Logic.getActiveSchedule();
        _statusData = Logic.getStatus(schedule);

        var width = dc.getWidth();
        var height = dc.getHeight();

        var totalSecondsLeft = _statusData[:secondsLeft];
        var displayMinutes = totalSecondsLeft / 60;
        var displaySeconds = totalSecondsLeft % 60;

        // 1. URBAN COLOR-CODED STATE SELECTOR
        var timeColor = Graphics.COLOR_WHITE;
        var labelColor = Graphics.COLOR_WHITE;

        if (_statusData[:type].equals("transition")) {
            labelColor = Graphics.COLOR_YELLOW;
            timeColor = (displayMinutes < 2) ? Graphics.COLOR_RED : Graphics.COLOR_YELLOW; 
        } else if (_statusData[:type].equals("class")) {
            labelColor = Graphics.COLOR_BLUE;
            timeColor = (displayMinutes < 5) ? Graphics.COLOR_ORANGE : Graphics.COLOR_WHITE; 
        } else if (_statusData[:type].equals("before")) {
            labelColor = Graphics.COLOR_LT_GRAY;
        } else {
            labelColor = Graphics.COLOR_LT_GRAY;
        }

        // 2. DYNAMIC BEZEL PROGRESS RING (Starts full, shrinks clockwise toward the top center)
        if (!_statusData[:type].equals("off") && !_statusData[:type].equals("tomorrow")) {
            var totalDuration = _statusData[:totalSeconds];
            if (totalDuration == null || totalDuration <= 0) { totalDuration = 1; }
            
            // Calculate the percentage of time REMAINING
            var percentRemaining = (totalSecondsLeft.toFloat() / totalDuration.toFloat());
            if (percentRemaining > 1.0) { percentRemaining = 1.0; }
            if (percentRemaining < 0.0) { percentRemaining = 0.0; }
            
            // Math Fix: Subtracting the percentage from 90 degrees maps the calculation 
            // clockwise. At 100% left, it sweeps all the way around to 90 degrees.
            var endAngle = 90 - (percentRemaining * 360); 

            dc.setColor(labelColor, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(4); 
            
            // Draw the evaporating arc track around the watch screen boundaries
            dc.drawArc(
                width / 2,         // Center X
                height / 2,        // Center Y
                (width / 2) - 3,   // Radius
                Graphics.ARC_CLOCKWISE, // Tells the rendering path to follow the subtraction layout clockwise
                90,                // Anchor point (Top center)
                endAngle           // Dynamic End Angle that recedes clockwise toward 90
            );
            
            // Reset Pen Width back to standard
            dc.setPenWidth(1);
        }

        // 3. DRAW HEADER & ZONE 
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 20, Graphics.FONT_SMALL, "Schedule:", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, 60, Graphics.FONT_SMALL, State.currentSchedule, Graphics.TEXT_JUSTIFY_CENTER);

        // 4. DRAW ACTIVE TARGET NAME 
        dc.setColor(labelColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, (height / 2) - 70, Graphics.FONT_MEDIUM, _statusData[:name], Graphics.TEXT_JUSTIFY_CENTER);

        // 5. DRAW NEXT PERIOD SUB-LABEL 
        if (!_statusData[:next].equals("")) {
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            var prefix = "Next: "; 
            dc.drawText(
                width / 2,
                (height / 2) - 5,
                Graphics.FONT_XTINY,
                prefix + _statusData[:next],
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }

        // 6. DRAW COUNTDOWN CLOCK
        var timeString = "--:--";
        if (!_statusData[:type].equals("off") && !_statusData[:type].equals("tomorrow")) {
            timeString = Lang.format("$1$:$2$", [displayMinutes.format("%02d"), displaySeconds.format("%02d")]);
            dc.setColor(timeColor, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            if (_statusData[:type].equals("tomorrow")) {
                timeString = "Done";
            }
        }
        dc.drawText(width / 2, (height / 2) + 25, Graphics.FONT_LARGE, timeString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onHide() {
        if (_uiTimer != null) {
            _uiTimer.stop();
            _uiTimer = null;
        }
    }
}
