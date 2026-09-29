using Toybox.WatchUi;
using Toybox.System;
using Toybox.Lang;

class SchoolTimerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onPreviousPage() as Lang.Boolean {
        cycleSchedule(true);
        return true; 
    }

    function onNextPage() as Lang.Boolean {
        cycleSchedule(false);
        return true; 
    }

    // FIXED: Triggers exactly on the second START press inside the full app view
    function onSelect() as Lang.Boolean {
        // Push your dedicated QR code view onto the screen stack
        WatchUi.pushView(
            new SchoolTimerCodeView(), 
            new WatchUi.BehaviorDelegate(), // Standard back button handler works automatically
            WatchUi.SLIDE_UP                 // Smoothly slides the QR code up over the timers
        );
        return true;
    }

    private function cycleSchedule(forward as Lang.Boolean) as Void {
        var current = State.currentSchedule;
        if (current.equals("Bell Schedule")) {
            State.currentSchedule = forward ? "Panther Schedule" : "OFF";
        } else if (current.equals("Panther Schedule")) {
            State.currentSchedule = forward ? "OFF" : "Bell Schedule";
        } else if (current.equals("OFF")) {
            State.currentSchedule = forward ? "Bell Schedule" : "Panther Schedule";
        }
        Toybox.Application.Storage.setValue("saved_schedule", State.currentSchedule);
        WatchUi.requestUpdate();
    }
}
