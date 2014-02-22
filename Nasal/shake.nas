#######################################################################################
#		Lake of Constance Hangar :: M.Kraus
#		Boeing 707 for Flightgear February 2014
#		This file is licenced under the terms of the GNU General Public Licence V2 or later
#######################################################################################

############################ roll out and shake effect ##################################
var shakeEffect707 = props.globals.initNode("b707/shake-effect/effect",0,"BOOL");
var gSpeed = 0;
var sf = 0;
var xod = 0;
var yod = 0;
var zod = 0;
var xod2 = 0;
var yod2 = 0;
var zod2 = 0;
var vnumber = 0;
var ge_a_r  = 0;

var theShakeEffect = func{
		ge_a_r = getprop("gear/gear[1]/wow") or 0;
		gSpeed = getprop("/velocities/groundspeed-kt") or 0;
		p_b = getprop("/controls/gear/brake-parking") or 0;
		xod = getprop("sim/current-view/x-offset-m") or 0;
		yod = getprop("sim/current-view/y-offset-m") or 0;
		zod = getprop("sim/current-view/z-offset-m") or 0;
		vnumber = getprop("sim/current-view/view-number") or 0;
		vnumber = (vnumber == 8) ?  101 : vnumber;
		vnumber = (vnumber == 9) ?  102 : vnumber;
		vnumber = (vnumber == 10) ? 103 : vnumber;
		vnumber = (vnumber == 11) ? 104 : vnumber;
		vnumber = (vnumber == 12) ? 105 : vnumber;
		xod2 = getprop("sim/view["~vnumber~"]/config/x-offset-m") or 0;
		yod2 = getprop("sim/view["~vnumber~"]/config/y-offset-m") or 0;
		zod2 = getprop("sim/view["~vnumber~"]/config/z-offset-m") or 0;

		sf = gSpeed / 240000;

		# print("sf .... : " ~ sf);
	    
	
		if(shakeEffect707.getBoolValue() and ge_a_r){

		  interpolate("sim/current-view/x-offset-m", xod + sf, 0.1);
		  interpolate("sim/current-view/y-offset-m",  yod + sf, 0.1);
		  interpolate("sim/current-view/z-offset-m",  zod + sf, 0.1);
		  settimer(func{
		  	 interpolate("sim/current-view/x-offset-m", xod - sf*2, 0.1);
		  	 interpolate("sim/current-view/y-offset-m",  yod - sf*2, 0.1);
		  	 interpolate("sim/current-view/z-offset-m",  zod - sf*2, 0.1);  
		  }, 0.1);
		  settimer(func{
		  	setprop("sim/current-view/x-offset-m", xod2);
		  	setprop("sim/current-view/y-offset-m",  yod2);
		  	setprop("sim/current-view/z-offset-m",  zod2);
		  }, 0.2);

			settimer(theShakeEffect, 0.21);
			
		}else{
		  	setprop("sim/current-view/x-offset-m", xod2);
		  	setprop("sim/current-view/y-offset-m",  yod2);
		  	setprop("sim/current-view/z-offset-m",  zod2);
			
			setprop("b707/shake-effect/effect",0);		
		}	  
	  
}

# INFORMATION: script will be startet in brakesystem.nas line 81 dependend the groundspeed ############

setlistener("b707/shake-effect/effect", func(state){
	if(state.getBoolValue()){
		theShakeEffect();
	}
},1,0);

