using Toybox.System;

(:glance)
class Logic {

        // STEADY TEST VERSION: Marches forward linearly second-by-second without loops or locks
    static function nowSecondsOfDay() {
        // --- LIVE CLOCK MODE (Uncomment this when loading onto your physical watch) ---
        var t = System.getClockTime();
        return (t.hour * 3600) + (t.min * 60) + t.sec;
    }




    static function getActiveSchedule() {
        var current = State.getSafeScheduleName();
        if (current.equals("Bell Schedule")) {
            return Schedules.BellSchedule;
        } else if (current.equals("Panther Schedule")) {
            return Schedules.PantherSchedule;
        } else {
            return Schedules.OFF;
        }
    }

        static function getStatus(schedule) {
        var nowSec = nowSecondsOfDay();

        if (schedule == null || schedule.size() == 0 || State.currentSchedule.equals("OFF")) {
            return { :name => "No School", :secondsLeft => 0, :totalSeconds => 1, :type => "off", :next => "" };
        }

        var firstStartSec = schedule[0][:start] * 60;
        var lastEndSec = schedule[schedule.size() - 1][:end] * 60;

        // 1. Before School Check
        if (nowSec < firstStartSec) {
            return {
                :name => "Before School",
                :secondsLeft => firstStartSec - nowSec,
                :totalSeconds => firstStartSec, // Total wait duration
                :type => "before",
                :next => schedule[0][:name]
            };
        }

        // 2. Main Schedule Processing Loop
        for (var i = 0; i < schedule.size(); i++) {
            var period = schedule[i];
            var startSec = period[:start] * 60;
            var endSec = period[:end] * 60;

            // Inside an active class
            if (nowSec >= startSec && nowSec < endSec) {
                var nextLabel = "";
                if (i + 1 < schedule.size()) {
                    nextLabel = schedule[i + 1][:name];
                }
                return {
                    :name => period[:name],
                    :secondsLeft => endSec - nowSec,
                    :totalSeconds => endSec - startSec, // ADDED: Pure duration of the class block
                    :type => "class",
                    :next => nextLabel
                };
            }

            // Inside an active transition block
            if (i + 1 < schedule.size()) {
                var nextPeriod = schedule[i + 1];
                var nextStartSec = nextPeriod[:start] * 60;
                
                if (nowSec >= endSec && nowSec < nextStartSec) {
                    return {
                        :name => "Transition",
                        :secondsLeft => nextStartSec - nowSec,
                        :totalSeconds => nextStartSec - endSec, // ADDED: Pure duration of the passing period
                        :type => "transition",
                        :next => nextPeriod[:name]
                    };
                }
            }
        }

        // 3. School Over Check
        if (nowSec >= lastEndSec) {
            return {
                :name => "School Over",
                :secondsLeft => 0,
                :totalSeconds => 1,
                :type => "tomorrow",
                :next => schedule[0][:name]
            };
        }

        return { :name => "No School", :secondsLeft => 0, :totalSeconds => 1, :type => "off", :next => "" };
    }
}
