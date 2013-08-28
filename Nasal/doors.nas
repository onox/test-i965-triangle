# =====
# Doors
# =====

Doors = {};

Doors.new = func {
   obj = { parents : [Doors],
           pilotwin : aircraft.door.new("instrumentation/doors/pilotwin", 2.0, 0),
		   		 copilotwin : aircraft.door.new("instrumentation/doors/copilotwin", 2.0, 0),
		   		 pasfront : aircraft.door.new("instrumentation/doors/pasfront", 4.0, 0),
		   		 pasrear : aircraft.door.new("instrumentation/doors/pasrear", 4.0, 0),
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
	var alt = getprop("/position/altitude-agl-ft") or 0;
	if(alt < 7.0){
   	me.pasfront.toggle();
   	setprop("/b707/ground-service/enabled", 1);
  }else{
  	setprop("/instrumentation/doors/pasfront/position-norm", 0);
  }
}

Doors.pasrearexport = func {
	var alt = getprop("/position/altitude-agl-ft") or 0;
	if(alt < 7.0){
   	me.pasrear.toggle();
   	setprop("/b707/ground-service/enabled", 1);
  }else{
  	setprop("/instrumentation/doors/pasrear/position-norm", 0);
  }
}

Doors.noseexport = func {
	var alt = getprop("/position/altitude-agl-ft") or 0;
	var inside = getprop("sim/current-view/internal") or 0;
	if(alt < 7.0 and !inside){
   	me.nose.toggle();
   	setprop("/b707/ground-service/enabled", 1);
  }else{
  	setprop("/instrumentation/doors/nose/position-norm", 0);
  }
}

# ==============
# Initialization
# ==============

# objects must be here, otherwise local to init()
doorsystem = Doors.new();
