# Lake of Constance Hangar :: M.Kraus
# Avril 2013
# This file is licenced under the terms of the GNU General Public Licence V2 or later
# ==================================== timer stuff ===============================
var run_tyresmoke0 = 0;
var run_tyresmoke1 = 0;
var run_tyresmoke2 = 0;
var tyresmoke_0 = aircraft.tyresmoke.new(0, 0, 0.3, 0);
var tyresmoke_1 = aircraft.tyresmoke.new(1, 0, 0.3, 0);
var tyresmoke_2 = aircraft.tyresmoke.new(2, 0, 0.3, 0);

# =============================== listeners ===============================
setlistener("gear/gear[0]/position-norm", func {
	var gear = getprop("gear/gear[0]/position-norm");
	if (gear == 1 ){
		run_tyresmoke0 = 1;
	}else{
		run_tyresmoke0 = 0;
	}
},1,0);

setlistener("gear/gear[1]/position-norm", func {
	var gear = getprop("gear/gear[1]/position-norm");
	if (gear == 1 ){
		run_tyresmoke1 = 1;
	}else{
		run_tyresmoke1 = 0;
	}
},1,0);

setlistener("gear/gear[2]/position-norm", func {
	var gear = getprop("gear/gear[2]/position-norm");
	if (gear == 1 ){
		run_tyresmoke2 = 1;
	}else{
		run_tyresmoke2 = 0;
	}
},1,0);

# end 
