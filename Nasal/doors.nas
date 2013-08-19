# =====
# Doors
# =====

Doors = {};

Doors.new = func {
   obj = { parents : [Doors],
           pilotwin : aircraft.door.new("instrumentation/doors/pilotwin", 2.0, 0),
		   		 copilotwin : aircraft.door.new("instrumentation/doors/copilotwin", 2.0, 0),
		   		 pasfront : aircraft.door.new("instrumentation/doors/pasfront", 2.0, 0),
		   		 pasrear : aircraft.door.new("instrumentation/doors/pasrear", 2.0, 0),
		   		 nose : aircraft.door.new("instrumentation/doors/nose", 2.0, 0),
         };
   return obj;
};

Doors.pilotwinexport = func {
   me.pilotwin.toggle();
}

Doors.copilotwinexport = func {
   me.copilotwin.toggle();
}

Doors.pasfrontexport = func {
   me.pasfront.toggle();
}

Doors.pasrearexport = func {
   me.pasrear.toggle();
}

Doors.noseexport = func {
   me.nose.toggle();
}

# ==============
# Initialization
# ==============

# objects must be here, otherwise local to init()
doorsystem = Doors.new();
