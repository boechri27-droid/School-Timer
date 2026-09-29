(:glance)
class State {
    // Keeps track of the live schedule letter/name
    static var currentSchedule = "Bell Schedule";

    // Ensures we never return an empty text field to the logic processor
    static function getSafeScheduleName() as Toybox.Lang.String {
        if (currentSchedule == null || currentSchedule.equals("")) {
            currentSchedule = "Bell Schedule";
        }
        return currentSchedule;
    }
}
