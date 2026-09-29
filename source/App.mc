using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.Application.Storage;

(:glance)
class SchoolTimerApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) as Void {
        var saved = Storage.getValue("saved_schedule");
        if (saved != null) {
            State.currentSchedule = saved as Lang.String;
        } else {
            State.currentSchedule = "Bell Schedule";
        }
    }

    function getInitialView() {
        return [ new SchoolTimerView(), new SchoolTimerDelegate() ];
    }

    // FIXED: Removed the manual array typing blocks to let the compiler auto-resolve the return array safely
    function getGlanceView() {
        return [ new SchoolTimerGlanceView() ];
    }

    function onStop(state) as Void {
        Storage.setValue("saved_schedule", State.currentSchedule);
    }
}
