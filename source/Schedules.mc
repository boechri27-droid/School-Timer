(:glance) class Schedules {

    // Renamed Schedule A container
    static var BellSchedule = [
        { :name => "PRIME", :start => 435, :end => 455 },
        { :name => "Calculus AB AP", :start => 459, :end => 504 },
        { :name => "World History AP", :start => 508, :end => 553 },
        { :name => "Health II",    :start => 557, :end => 602 },
        { :name => "Lunch",    :start => 606, :end => 636 },
        { :name => "Honors Choir",    :start => 636, :end => 692 },
        { :name => "English 10 Honors",    :start => 696, :end => 741 },
        { :name => "Seminar AP",    :start => 745, :end => 790 },
        { :name => "Biology Honors",    :start => 794, :end => 840 }
    ];

    // Renamed Schedule B container
    static var PantherSchedule = [
        { :name => "Calculus AB AP", :start => 435, :end => 478 },
        { :name => "World History AP", :start => 482, :end => 523 },
        { :name => "Health II",    :start => 527, :end => 568 },
        { :name => "AM Pathways",    :start => 572, :end => 602 },
        { :name => "Lunch",    :start => 606, :end => 634 },
        { :name => "Honors Choir",    :start => 634, :end => 690 },
        { :name => "PM Pathways",    :start => 690, :end => 715 },
        { :name => "English 10 Honors",    :start => 719, :end => 757 },
        { :name => "Seminar AP",    :start => 761, :end => 799 },
        { :name => "Biology Honors",    :start => 803, :end => 840 }
    ];

    static var OFF = [
        { :name => "No School", :start => 0, :end => 1440 }
    ];
}
