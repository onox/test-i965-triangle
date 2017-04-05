#######################################################################################
#       Lake of Constance Hangar :: M.Kraus
#       Boeing 707 for Flightgear Septemper 2013
#       This file is licenced under the terms of the GNU General Public Licence V2 or later
#######################################################################################

Doors = {};

Doors.new = func {
    return {
        parents: [Doors],
        pilotwin: aircraft.door.new("instrumentation/doors/pilotwin", 2.0, 0),
        copilotwin: aircraft.door.new("instrumentation/doors/copilotwin", 2.0, 0),
        pasfront: aircraft.door.new("instrumentation/doors/pasfront", 4.0, 0),
        cargo: aircraft.door.new("instrumentation/doors/cargo", 12.0, 0),
        nose: aircraft.door.new("instrumentation/doors/nose", 2.0, 0),
   };
};

Doors.pilotwinexport = func {
    me.pilotwin.toggle();

    # if somebody opens the cockpit windows in flight
    var speed = getprop("/velocities/groundspeed-kt") or 0;
    if (speed > 200) {
        setprop("b707/pressurization/safety-valve", 0);
        b707.safety_valv_pos();
    }
}

Doors.copilotwinexport = func {
    me.copilotwin.toggle();
    # if somebody opens the cockpit windows in flight
    var speed = getprop("/velocities/groundspeed-kt") or 0;
    if (speed > 200) {
        setprop("b707/pressurization/safety-valve", 0);
        b707.safety_valv_pos();
    }
}

Doors.pasfrontexport = func {
    var alt = getprop("/position/altitude-agl-ft") or 0;
    if (alt < 7.0) {
        me.pasfront.toggle();
        setprop("/b707/ground-service/enabled", 1);
    }
    else {
        setprop("/instrumentation/doors/pasfront/position-norm", 0);
    }
}

Doors.cargoexport = func {
    var alt = getprop("/position/altitude-agl-ft") or 0;
    var cargoliner = getprop("sim/multiplay/generic/int[9]") or 0;
    if (alt < 7.0 and cargoliner) {
        me.cargo.toggle();
        setprop("/b707/ground-service/enabled", 1);
    }
    else {
        setprop("/instrumentation/doors/cargo/position-norm", 0);
    }
}

Doors.noseexport = func {
    var alt = getprop("/position/altitude-agl-ft") or 0;
    var inside = getprop("sim/current-view/internal") or 0;
    if (alt < 7.0 and !inside) {
        me.nose.toggle();
        setprop("/b707/ground-service/enabled", 1);
    }
    else {
        setprop("/instrumentation/doors/nose/position-norm", 0);
    }
}

# objects must be here, otherwise local to init()
doorsystem = Doors.new();
