# Lake of Constance Hangar :: M.Kraus
# Avril 2013
# This file is licenced under the terms of the GNU General Public Licence V2 or later

############################ init ENGINE START AIR PRESSURE ##################################
# used in the autostarts.nas  var starter()
var stAirRight = props.globals.initNode("b707/start-air-bottle-press[0]",2810,"DOUBLE");
var stAirLeft  = props.globals.initNode("b707/start-air-bottle-press[1]",2960,"DOUBLE");

var oT1 = props.globals.initNode("b707/oil/oil-temp[0]",0,"DOUBLE");
var oT2 = props.globals.initNode("b707/oil/oil-temp[1]",0,"DOUBLE");
var oT3 = props.globals.initNode("b707/oil/oil-temp[2]",0,"DOUBLE");
var oT4 = props.globals.initNode("b707/oil/oil-temp[3]",0,"DOUBLE");

var oil1 = props.globals.initNode("b707/oil/quantity[0]",6400,"DOUBLE");
var oil2 = props.globals.initNode("b707/oil/quantity[1]",6400,"DOUBLE");
var oil3 = props.globals.initNode("b707/oil/quantity[2]",6400,"DOUBLE");
var oil4 = props.globals.initNode("b707/oil/quantity[3]",6400,"DOUBLE");


################################ Reverser ####################################

# The heading offset to 0
var turn_offset_deg = setlistener("b707/ess-bus", func(volt)
{
if (volt.getValue() >= 25.18)
 {
  interpolate("/instrumentation/heading-indicator/offset-deg", 0, 2);
  removelistener(turn_offset_deg);
 }
}, 0, 0);

var togglereverser = func {
	r1 = "/fdm/jsbsim/propulsion/engine";
	r2 = "/fdm/jsbsim/propulsion/engine[1]";
	r3 = "/fdm/jsbsim/propulsion/engine[2]";
	r4 = "/fdm/jsbsim/propulsion/engine[3]";

	rc1 = "/controls/engines/engine";
	rc2 = "/controls/engines/engine[1]";
	rc3 = "/controls/engines/engine[2]";
	rc4 = "/controls/engines/engine[3]"; 

	r5 = "/sim/input/selected";

	rv1 = "/engines/engine/reverser-pos-norm"; 
	rv2 = "/engines/engine[1]/reverser-pos-norm";
	rv3 = "/engines/engine[2]/reverser-pos-norm"; 
	rv4 = "/engines/engine[3]/reverser-pos-norm"; 

	val1 = getprop(rv1) or 0;
	
	t1 = getprop("/controls/engines/engine[0]/throttle") or 0;

	if ((val1 == 0 or val1 == nil) and t1 < 0.25) {
		interpolate(rv1, 1.0, 1.4); 
		interpolate(rv2, 1.0, 1.4);
		interpolate(rv3, 1.0, 1.4); 
		interpolate(rv4, 1.0, 1.4);   
		setprop(r1,"reverser-angle-rad",2);
		setprop(r2,"reverser-angle-rad",2);   
		setprop(r3,"reverser-angle-rad",2);
		setprop(r4,"reverser-angle-rad",2);
		setprop(rc1,"reverser", "true");
		setprop(rc2,"reverser", "true");
		setprop(rc3,"reverser", "true");
		setprop(rc4,"reverser", "true");
		setprop(r5,"engine", "true");
		setprop(r5,"engine[1]", "true");
		setprop(r5,"engine[2]", "true");
		setprop(r5,"engine[3]", "true");
	} else {
		if (val1 == 1.0 and t1 == 0){
		interpolate(rv1, 0.0, 1.4);
		interpolate(rv2, 0.0, 1.4); 
		interpolate(rv3, 0.0, 1.4);
		interpolate(rv4, 0.0, 1.4);  
		setprop(r1,"reverser-angle-rad",0);
		setprop(r2,"reverser-angle-rad",0); 
		setprop(r3,"reverser-angle-rad",0);
		setprop(r4,"reverser-angle-rad",0);
		setprop(rc1,"reverser",0);
		setprop(rc2,"reverser",0);
		setprop(rc3,"reverser",0);
		setprop(rc4,"reverser",0);
		setprop(r5,"engine", "true");
		setprop(r5,"engine[1]", "true");
		setprop(r5,"engine[2]", "true");
		setprop(r5,"engine[3]", "true");
		}
	}
}

var toggleLandingLights = func {

  if(!getprop("controls/lighting/landing-light[0]")){
  	setprop("controls/lighting/landing-light[0]",1); 
  }else{
		setprop("controls/lighting/landing-light[0]",0);  
  }

  if(!getprop("controls/lighting/landing-light[1]")){
  	setprop("controls/lighting/landing-light[1]",1); 
  }else{
		setprop("controls/lighting/landing-light[1]",0);  
  }

  if(!getprop("controls/lighting/landing-light[2]")){
  	setprop("controls/lighting/landing-light[2]",1); 
  }else{
		setprop("controls/lighting/landing-light[2]",0);  
  }
  
  if(!getprop("controls/lighting/landing-light[3]")){
  	setprop("controls/lighting/landing-light[3]",1); 
  }else{
		setprop("controls/lighting/landing-light[3]",0);  
  }
}

################## Little Help Window on bottom of screen #################
var help_win = screen.window.new( 0, 0, 1, 3 );
help_win.fg = [1,1,1,1];

var messenger = func{
help_win.write(arg[0]);
}
print("Help infosystem started");

var h_altimeter = func {
	var press_inhg = getprop("/instrumentation/altimeter/setting-inhg");
	var press_qnh = getprop("/instrumentation/altimeter/setting-hpa");
	if(  press_inhg == nil ) press_inhg = 0.0;
	if(  press_qnh == nil ) press_qnh = 0.0;
	help_win.write(sprintf("Baro alt pressure: %.0f hpa %.2f inhg ", press_qnh, press_inhg) );
}

var h_heading = func {
	var press_hdg = getprop("/autopilot/settings/heading-bug-deg");
	if(  press_hdg == nil ) press_hdg = 0.0;
	help_win.write(sprintf("Target heading: %.0f ", press_hdg) );
}

var h_course = func {
	var press_course = getprop("/instrumentation/nav/radials/selected-deg");
	if(  press_course == nil ) press_course = 0.0;
	help_win.write(sprintf("Selected course is: %.0f ", press_course) );
}

var h_course_two = func {
	var press_course_two = getprop("/instrumentation/nav[1]/radials/selected-deg");
	if(  press_course_two == nil ) press_course_two = 0.0;
	help_win.write(sprintf("Selected course on copilot HSI is: %.0f ", press_course_two) );
}

var h_tas = func {
	var press_tas = getprop("/autopilot/settings/target-speed-kt");
	if(  press_tas == nil ) press_tas = 0.0;
	help_win.write(sprintf("Target speed: %.0f ", press_tas) );
}

var h_vs = func {
	var press_vs = getprop("/autopilot/settings/vertical-speed-fpm");
	if(  press_vs == nil ) press_vs = 0.0;
	help_win.write(sprintf("Vertical speed: %.0f ", press_vs) );
}

var h_mis = func {
	var press_mis = getprop("/instrumentation/rmi/face-offset");
	if(  press_mis == nil ) press_mis = 0.0;
	help_win.write(sprintf("%.0f degrees", press_mis) );
}

setlistener( "/instrumentation/altimeter/setting-inhg", h_altimeter );
setlistener( "/autopilot/settings/heading-bug-deg", h_heading );
setlistener( "/instrumentation/nav/radials/selected-deg", h_course );
setlistener( "/instrumentation/nav[1]/radials/selected-deg", h_course_two );
setlistener( "/autopilot/settings/target-speed-kt", h_tas );
setlistener( "/autopilot/settings/vertical-speed-fpm", h_vs);
setlistener( "/instrumentation/rmi/face-offset", h_mis);


var show_alti = func {
	var press_inhg = getprop("/instrumentation/altimeter/setting-inhg");
	if(  press_inhg == nil ) press_inhg = 0.0;
	var alt_ft = getprop("/instrumentation/aglradar/alt-ft");
	if(  alt_ft == nil ) alt_ft = 0.0;
	var alt_on = getprop("/instrumentation/aglradar/power-btn");
	if(  alt_on == nil ) alt_on = 0;	
  var s_alti = getprop("/instrumentation/altimeter/indicated-altitude-ft") or 0;
  if(alt_on){
  	help_win.write(sprintf("With %.2f inhg the actual altitude is: %.0f ft. AGL is %.0f ft", press_inhg, s_alti, alt_ft) );
  }else{
   	help_win.write(sprintf("With %.2f inhg the actual altitude is: %.0f ft. Groundradar is off.", press_inhg, s_alti, alt_ft) ); 
  }
}

var show_lat_lon = func {
	var lat = getprop("/position/latitude-string");
	var lon = getprop("/position/longitude-string");
	help_win.write(sprintf("lat: "~lat~" lon: "~lon)); 
}

var show_dme = func {
  var dme = getprop("/controls/switches/dme") or 0;
  var tacan_miles = getprop("/instrumentation/tacan/indicated-distance-nm") or 0;
  var dme_miles1 = getprop("/instrumentation/dme/indicated-distance-nm") or 0;
  var dme_miles2 = getprop("/instrumentation/dme[1]/indicated-distance-nm") or 0;

  var decToString = func(x){
    var d = int(math.mod((x*100),100));

    return (int(x)~"."~d);  
  }

  if (dme == 2){
    var x = decToString(tacan_miles);
    var freq = getprop("/instrumentation/tacan/frequencies/selected-channel") or 0;
    var frex = getprop("/instrumentation/tacan/frequencies/selected-channel[4]");
    help_win.write(sprintf("Distance to TACAN \""~freq ~ frex~"\" %.2f nm", x) );
  }
  
  if (dme == 1){
    var x = decToString(dme_miles2);
    var id = getprop("/instrumentation/nav[1]/nav-id") or 0.0;
    help_win.write(sprintf("Distance to VOR-DME \""~id~"\" %.2f nm", x) );
  }

  if (!dme){
    var x = decToString(dme_miles1);
    var id = getprop("/instrumentation/nav/nav-id") or 0.0;             
    help_win.write(sprintf("Distance to VOR-DME \""~id~"\" %.2f nm", x) );
  }
}

var show_fuel_consumption = func {
	var used = getprop("/b707/fuel/fuel-per-hour-lbs") or 0;
	var fueltotal = getprop("/consumables/fuel/total-fuel-lbs") or 0;
	var kg =  used * 0.45359237;
	var totalkg = fueltotal * 0.45359237;
	var rt = 0;
	
	# how long we can fly
	if(used){
		var rt = fueltotal / used * 3600;
	  var hours = int(rt/3600);
		var minutes = int(math.mod(rt / 60, 60));
	}
	
	if(kg > 0){
		help_win.write(sprintf("Total Fuel: %.2fkg - fuel consumption/hour: %.2fkg expected flighttime %3dh %02dmin", fueltotal, kg, hours, minutes));
	}else{
		help_win.write(sprintf("NO FUEL CONSUMPTION - Total fuel: %.2fkg", fueltotal));
	}
}
   
# show the mp or ai aircraft information on the radar

var show_mp_info = func (i){
	var cs  = getprop("instrumentation/mptcas/mp[" ~ i ~ "]/callsign") or "";
	var al  = getprop("instrumentation/mptcas/mp[" ~ i ~ "]/altitude-ft") or 0;
	var as  = getprop("instrumentation/mptcas/mp[" ~ i ~ "]/tas-kt") or 0;
	var dis = getprop("instrumentation/mptcas/mp[" ~ i ~ "]/distance-nm") or 0;

  help_win.write(sprintf(cs~" %.0fft / %.0fkts / %.2fnm", al, as, dis) ); 
} 

var show_ai_info = func (i){
	var cs  = getprop("instrumentation/mptcas/ai[" ~ i ~ "]/callsign") or "";
	var al  = getprop("instrumentation/mptcas/ai[" ~ i ~ "]/altitude-ft") or 0;
	var as  = getprop("instrumentation/mptcas/ai[" ~ i ~ "]/tas-kt") or 0;
	var dis = getprop("instrumentation/mptcas/ai[" ~ i ~ "]/distance-nm") or 0;

  help_win.write(sprintf(cs~" %.0fft / %.0fkts / %.2fnm", al, as, dis) );
}

#################################### helper for the standby ADI ############################################
var gauge_erec = func {
  setprop("/instrumentation/vertical-speed-indicator/serviceable",0);
  var tmp_vs = getprop("/instrumentation/vertical-speed-indicator/indicated-speed-fpm") or 0;
  var tmp_vs_target_max = 4000;
  var tmp_vs_target_min = -3000;
  interpolate("/instrumentation/adi/knob-pos",1,0.2);
  interpolate("/instrumentation/vertical-speed-indicator/indicated-speed-fpm",tmp_vs_target_max,0.3); 
	settimer( func{ interpolate("/instrumentation/vertical-speed-indicator/indicated-speed-fpm",tmp_vs_target_min,0.7); }, 0.3);
	settimer( func{ interpolate("/instrumentation/vertical-speed-indicator/indicated-speed-fpm",tmp_vs,0.5); }, 1.0);
	settimer( func{   setprop("/instrumentation/vertical-speed-indicator/serviceable", 1);
										setprop("/instrumentation/adi/knob-pos", 0); }, 1.5);

}


####################################### total operating time ###################################
var operating_time_counter = func {
	#print("operating time counter works");
  var act_time    	= props.globals.getNode("/sim/time/elapsed-sec");
  var start_time  	= props.globals.getNode("/instrumentation/operating-time/start-time");
  var old_total   	= props.globals.getNode("/instrumentation/operating-time/total");
  var old_total_h   = props.globals.getNode("/instrumentation/operating-time/total-h");
  var old_total_m   = props.globals.getNode("/instrumentation/operating-time/total-m");
  
  var new_total   = old_total.getValue() + (act_time.getValue() - start_time.getValue());
  
  var hours = new_total / 3600;
  var minutes = int(math.mod(new_total / 60, 60));
  
  start_time.setValue(act_time.getValue());
  old_total.setValue(new_total);
  old_total_h.setValue(hours);
  old_total_m.setValue(minutes);
  
	settimer( operating_time_counter, 60);
}

operating_time_counter();

####################################### speedbrake helper #######################################
var stepSpeedbrakes = func(step) {
    # Hard-coded speedbrakes movement in 4 equal steps:
    var val = 0.25 * step + getprop("/controls/flight/speedbrake");
    setprop("/controls/flight/speedbrake", val > 1 ? 1 : val < 0 ? 0 : val);
}

######################################## compass control #######################################
# if compass control is set to MAG (directional gyro slaved to flux valve) and not DG (compass indicate directional gyro heading),
# the offset will be set automatically

var mag_control = func {
	var mag_selected = getprop("/instrumentation/compass-control/mag") or 0;
	if( mag_selected == nil ) mag_selected = 0.0;
	if( mag_selected ) {
		interpolate("/instrumentation/heading-indicator/offset-deg", 0, 0.25);
		settimer( mag_control, 82);
	}
}

setlistener( "/instrumentation/compass-control/mag", mag_control);


######################################## engine vibrations #######################################
var my_mini_rand = func(min,max) {
		  var min = min;
		  var max = max;
		  var r = 0;

			while( r < min or r > max ){
					r = rand();
			}
			
		  return r;
}

var eng_vib = func {

	var evib1 = getprop("/engines/engine[0]/n2") or 0;
	var evib2 = getprop("/engines/engine[1]/n2") or 0;
	var evib3 = getprop("/engines/engine[2]/n2") or 0;
	var evib4 = getprop("/engines/engine[3]/n2") or 0;
	var dc = getprop("/b707/ess-bus") or 0;
	var vibte = getprop("/b707/vibrations/vib-test") or 0;	
	var state = getprop("/b707/vibrations/vib-sel") or 0;
	
	var a1 = 0;
	var a2 = 0;
	var a3 = 0;
	var a4 = 0;

	if(state == 1 and !vibte) {
		if(evib1 > 10 and dc > 20) a1 = my_mini_rand(0.46, 0.54);
		if(evib2 > 10 and dc > 20) a2 = my_mini_rand(0.42, 0.58);
		if(evib3 > 10 and dc > 20) a3 = my_mini_rand(0.43, 0.57);
		if(evib4 > 10 and dc > 20) a4 = my_mini_rand(0.46, 0.54);
		interpolate("/b707/vibrations/vib[0]", a1, 2.5);
		interpolate("/b707/vibrations/vib[1]", a2, 2.5);
		interpolate("/b707/vibrations/vib[2]", a3, 2.5);
		interpolate("/b707/vibrations/vib[3]", a4, 3.5);
		settimer( eng_vib, 2.5);
		
	}elsif(state == 2 and !vibte) {
		if(evib1 > 10 and dc > 20) a1 = my_mini_rand(0.25, 0.35);
		if(evib2 > 10 and dc > 20) a2 = my_mini_rand(0.25, 0.35);
		if(evib3 > 10 and dc > 20) a3 = my_mini_rand(0.25, 0.35);
		if(evib4 > 10 and dc > 20) a4 = my_mini_rand(0.25, 0.35);
		interpolate("/b707/vibrations/vib[0]", a1, 2.5);
		interpolate("/b707/vibrations/vib[1]", a2, 2.5);
		interpolate("/b707/vibrations/vib[2]", a3, 2.5);
		interpolate("/b707/vibrations/vib[3]", a4, 2.5);
		settimer( eng_vib, 2.5);
		
	}else{
		interpolate("/b707/vibrations/vib[0]", a1, 0.5);
		interpolate("/b707/vibrations/vib[1]", a2, 0.5);
		interpolate("/b707/vibrations/vib[2]", a3, 0.5);
		interpolate("/b707/vibrations/vib[3]", a4, 0.5);
	}

}

setlistener("/b707/vibrations/vib-sel", eng_vib,1,0);

############################## view helper ###############################
var changeView = func (n){
  var actualView = props.globals.getNode("/sim/current-view/view-number", 1);
  if (actualView.getValue() == n){
    actualView.setValue(0);
  }else{
    actualView.setValue(n);
  }
}

################## hydraulic system and auxilliary pumps #################
var HydQuant = props.globals.initNode("b707/hydraulic/quantity",5400,"DOUBLE");
var rud = props.globals.initNode("/b707/hydraulic/rudder",0,"DOUBLE");
var sys = props.globals.initNode("/b707/hydraulic/system",0,"DOUBLE");
var shut1 = props.globals.getNode("/b707/hydraulic/hyd-fluid-shutoff[0]", 1);
var shut2 = props.globals.getNode("/b707/hydraulic/hyd-fluid-shutoff[1]", 1);
var pump1 = props.globals.getNode("/b707/hydraulic/hyd-fluid-pump[0]", 1);
var pump2 = props.globals.getNode("/b707/hydraulic/hyd-fluid-pump[1]", 1);
var acAux1 = props.globals.getNode("/b707/hydraulic/ac-aux-pump[0]", 1);
var acAux2 = props.globals.getNode("/b707/hydraulic/ac-aux-pump[1]", 1);
var eb = props.globals.getNode("/b707/ess-bus", 1);

setlistener("/b707/hydraulic/hyd-fluid-shutoff[0]", func{
	if(shut1.getBoolValue() and eb.getValue() > 23){
		 if (sys.getValue() <= 1 and pump1.getBoolValue()){ 
		 		interpolate("/b707/hydraulic/system", 2210, 12); # <=1 interpolation did not started before
		 		var q = (HydQuant.getValue() >= 5400) ? 4400 : HydQuant.getValue() - 1000;
		 		interpolate("/b707/hydraulic/quantity", q, 12);
		 }
	}else{
		 pump1.setBoolValue(0);
		 if (!shut2.getBoolValue() or !pump2.getBoolValue(0) or eb.getValue() < 23) { 
		 		interpolate("/b707/hydraulic/system", 0, 7);
		 		var q = (HydQuant.getValue() >= 4400) ? 5400 : HydQuant.getValue() + 1000;
		 		interpolate("/b707/hydraulic/quantity", q, 7);
		 }	
	}
},0,0);

setlistener("/b707/hydraulic/hyd-fluid-shutoff[1]", func{
	if(shut2.getBoolValue() and eb.getValue() > 23){
		 if (sys.getValue() <= 1 and pump2.getBoolValue()){ 
		 		interpolate("/b707/hydraulic/system", 2210, 12); # <=1 interpolation did not started before
		 		var q = (HydQuant.getValue() >= 5400) ? 4400 : HydQuant.getValue() - 1000;
		 		interpolate("/b707/hydraulic/quantity", q, 12);
		 }
	}else{
		 pump2.setBoolValue(0);
		 if (!shut1.getBoolValue() or !pump1.getBoolValue(0) or eb.getValue() < 23) { 
		 		interpolate("/b707/hydraulic/system", 0, 7);
		 		var q = (HydQuant.getValue() >= 4400) ? 5400 : HydQuant.getValue() + 1000;
		 		interpolate("/b707/hydraulic/quantity", q, 7);
		 }	
	}
},0,0);

setlistener("/b707/hydraulic/hyd-fluid-pump[0]", func{
	if(pump1.getBoolValue() and eb.getValue() > 23){
		 if (sys.getValue() <= 1 and shut1.getBoolValue()){ 
		 		interpolate("/b707/hydraulic/system", 2210, 12); # <=1 interpolation did not started before
		 		var q = (HydQuant.getValue() >= 5400) ? 4400 : HydQuant.getValue() - 1000;
		 		interpolate("/b707/hydraulic/quantity", q, 12);
		 }
	}else{
		 if (!shut2.getBoolValue() or !pump2.getBoolValue()) { 
		 		interpolate("/b707/hydraulic/system", 0, 7);
		 		var q = (HydQuant.getValue() >= 4400) ? 5400 : HydQuant.getValue() + 1000;
		 		interpolate("/b707/hydraulic/quantity", q, 7);
		 }	
	}
},0,0);

setlistener("/b707/hydraulic/hyd-fluid-pump[1]", func{
	if(pump2.getBoolValue() and eb.getValue() > 23){
		 if (sys.getValue() <= 1 and shut2.getBoolValue()) { 
		 		interpolate("/b707/hydraulic/system", 2210, 12); # <=1 interpolation did not started before
		 		var q = (HydQuant.getValue() >= 5400) ? 4400 : HydQuant.getValue() - 1000;
		 		interpolate("/b707/hydraulic/quantity", q, 12);
		 }
	}else{
		 if (!shut1.getBoolValue() or !pump1.getBoolValue()) { 
		 		interpolate("/b707/hydraulic/system", 0, 7);
		 		var q = (HydQuant.getValue() >= 4400) ? 5400 : HydQuant.getValue() + 1000;
		 		interpolate("/b707/hydraulic/quantity", q, 7);
		 }	
	}
},0,0);

setlistener("/b707/hydraulic/ac-aux-pump[0]", func{
	if(acAux1.getBoolValue() and eb.getValue() > 23){
		 if (rud.getValue() <= 1){ 
		 		interpolate("/b707/hydraulic/rudder", 3010, 14); # <=1 interpolation did not started before
		 		var q = (HydQuant.getValue() >= 5400) ? 4200 : HydQuant.getValue() - 1200;
		 		interpolate("/b707/hydraulic/quantity", q, 14);
		 }
	}else{
		 if (!acAux2.getBoolValue()) { 
		 		 	interpolate("/b707/hydraulic/rudder", 0, 8);
		 			var q = (HydQuant.getValue() >= 4200) ? 5400 : HydQuant.getValue() + 1200;
			 		interpolate("/b707/hydraulic/quantity", q, 8);
		 }	
	}
},0,0);

setlistener("/b707/hydraulic/ac-aux-pump[1]", func{
	if(acAux2.getBoolValue() and eb.getValue() > 23){
		 if (rud.getValue() <= 1){ 
		 		interpolate("/b707/hydraulic/rudder", 3010, 14); # <=1 interpolation did not started before
		 		var q = (HydQuant.getValue() >= 5400) ? 4200 : HydQuant.getValue() - 1200;
		 		interpolate("/b707/hydraulic/quantity", q, 14);
		 }
	}else{
		 if (!acAux1.getBoolValue()) { 
		 		 	interpolate("/b707/hydraulic/rudder", 0, 8);
		 			var q = (HydQuant.getValue() >= 4200) ? 5400 : HydQuant.getValue() + 1200;
			 		interpolate("/b707/hydraulic/quantity", q, 8);
		 }	
	}
},0,0);

############################################ Fire #####################################################
# see in fuel-and-payload.nas engines_alive();

setlistener("/b707/warning/fire-button[0]", func(state){
	var state = state.getValue() or 0;
	if(state){
		 settimer( func { setprop("/controls/engines/engine[0]/fire", 0); }, 3);
	}
},0,0);
setlistener("/b707/warning/fire-button[1]", func(state){
	var state = state.getValue() or 0;
	if(state){
		 settimer( func { setprop("/controls/engines/engine[1]/fire", 0); }, 3);
	}
},0,0);
setlistener("/b707/warning/fire-button[2]", func(state){
	var state = state.getValue() or 0;
	if(state){
		 settimer( func { setprop("/controls/engines/engine[2]/fire", 0); }, 3);
	}
},0,0);
setlistener("/b707/warning/fire-button[3]", func(state){
	var state = state.getValue() or 0;
	if(state){
		 settimer( func { setprop("/controls/engines/engine[3]/fire", 0); }, 3);
	}
},0,0);

# if gen-drive is set to on in flight, engines crashed
setlistener("/b707/generator/gen-drive[0]", func(state){
	var state = state.getBoolValue() or 0;
	var a = getprop("/position/altitude-agl-ft") or 0;
	if(a > 20 and state){
		 settimer( func { setprop("/controls/engines/engine[0]/fire", 1); }, 2);
	}
},0,0);
setlistener("/b707/generator/gen-drive[1]", func(state){
	var state = state.getBoolValue() or 0;
	var a = getprop("/position/altitude-agl-ft") or 0;
	if(a > 20 and state){
		 settimer( func { setprop("/controls/engines/engine[1]/fire", 1); }, 2);
	}
},0,0);
setlistener("/b707/generator/gen-drive[2]", func(state){
	var state = state.getBoolValue() or 0;
	var a = getprop("/position/altitude-agl-ft") or 0;
	if(a > 20 and state){
		 settimer( func { setprop("/controls/engines/engine[2]/fire", 1); }, 2);
	}
},0,0);
setlistener("/b707/generator/gen-drive[3]", func(state){
	var state = state.getBoolValue() or 0;
	var a = getprop("/position/altitude-agl-ft") or 0;
	if(a > 20 and state){
		 settimer( func { setprop("/controls/engines/engine[3]/fire", 1); }, 2);
	}
},0,0);

########################### OIL Sysstem  ######################################
var calc_oil_temp = func{
	var atemp  =  getprop("/environment/temperature-degc") or 0;
	
	foreach(var e; props.globals.getNode("/engines").getChildren("engine")) {
		var n = e.getNode("oil-pressure-psi").getValue() or 0;
		var r = e.getNode("running").getValue() or 0;
		var t = n * 2.148;
		if(r){
			interpolate("/b707/oil/oil-temp["~e.getIndex()~"]", t, 32);
		}else{
			interpolate("/b707/oil/oil-temp["~e.getIndex()~"]", atemp, 32);
		}
	}
	
	settimer( calc_oil_temp, 32);
}

settimer( calc_oil_temp, 10); # start first after 10 sec.

####################### COOLING AND PRESSURIZATION LOOP ###########################
var safety_valv_pos = func {
	setprop("b707/pressurization/safety-valve-pos", 0);
	setprop("/b707/pressurization/manual-mode-switch", 0);
	if(getprop("b707/pressurization/safety-valve")){ 
		settimer( func { setprop("b707/pressurization/safety-valve-pos", 1) }, 2.1 );
	}
}

var calc_pressurization	= func{
	# loop time
	var t = 3;
	# if pressurization is on automatic and safety-valve is closed
	var svp = getprop("/b707/pressurization/safety-valve-pos") or 0;
	var ms  = getprop("/b707/pressurization/manual-mode-switch") or 0;
	var rate = getprop("/b707/pressurization/incr-decr-rate") or 0.1; # never divide to zero
	var mcs = getprop("/b707/pressurization/manual-control-selector") or 0; # never divide to zero
	var vs = getprop("/instrumentation/vertical-speed-indicator/indicated-speed-fpm") or 0;
	var alt = getprop("/instrumentation/altimeter/indicated-altitude-ft") or 0.1; # never divide to zero
	var calt = getprop("/b707/pressurization/cabin-altitude") or 0;
	var max = getprop("/b707/pressurization/cabin-max") or 0;
	var mode = getprop("/b707/pressurization/mode-switch") or 0; # true is take off / false for landing
	
	if(svp){
	
		if(ms){
			var norm = alt/6.36;
			if(norm - 0.5 > calt){
				rate = (rate <= 250 and mode) ? 250 : rate;
			}elsif(norm + 0.5 < calt){
				rate = (rate >= -250 and !mode) ? -250 : rate;
			}else{
			  rate = 0;
			}

			calt = calt + (t*rate/60);
			calt = (calt > norm and mode) ? norm : calt;		# in takeoff or flight mode
			calt = (calt < norm and !mode) ? norm : calt;   # in landinng mode
			
			interpolate("/b707/pressurization/cabin-max", norm, t);  # the white scale is set automatically
			interpolate("/b707/pressurization/cabin-altitude", calt, t); # the alt needles 
			interpolate("/b707/pressurization/climb-rate", rate, t); # the climb rate
			#print("calc_pressurization is running in auto mode");
		}else{
			
			if((mcs > 0 and calt < max) or (mcs < 0 and calt > max)){
				calt = calt + (t*mcs/60);
			}else{
				calt = calt;
				mcs = 0;
			}	
			
			interpolate("/b707/pressurization/cabin-altitude", calt, t); # the alt needles as result of white scale and manual control 
			interpolate("/b707/pressurization/climb-rate", mcs, t);		# the climb rate as result of manual control
			#print("calc_pressurization is working on manual mode");
		}
		
	}else{
		calt = alt;
		#print("calc_pressurization is not working");
		interpolate("/b707/pressurization/cabin-altitude", alt, t);
		interpolate("/b707/pressurization/climb-rate", vs, t);
		var ra = getprop("position/altitude-agl-ft") or 0;
		if(ra > 2000) screen.log.write(sprintf("ATTENTION! No pressurization!"), 1.0, 0.0, 0.0);
	}
	
	# cabin differential pressure
	var diff = alt - calt;
	var psi = diff * 8.6/30000;
	interpolate("/b707/pressurization/cabin-differential-pressure", psi, t);
	
	settimer(calc_pressurization, t);
	
}

settimer( calc_pressurization, 9); # start first after 10 sec.

