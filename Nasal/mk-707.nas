# Lake of Constance Hangar :: M.Kraus
# Avril 2013
# This file is licenced under the terms of the GNU General Public Licence V2 or later
################################ Reverser ####################################

# The heading offset to 0
var turn_offset_deg = setlistener("/systems/electrical/right-bus", func(volt)
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
	val2 = getprop(rv2) or 0;
	val3 = getprop(rv3) or 0;
	val4 = getprop(rv4) or 0;
	
	t1 = getprop("/controls/engines/engine[0]/throttle") or 0;
	t2 = getprop("/controls/engines/engine[1]/throttle") or 0;
	t3 = getprop("/controls/engines/engine[2]/throttle") or 0;
	t4 = getprop("/controls/engines/engine[3]/throttle") or 0;

	if (val1 == 0 and val2 == 0 and val3 == 0 and val4 == 0 and
			t1 < 0.25 and t2 < 0.25 and t3 < 0.25 and t4 < 0.25 ) {
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
	}
	
	if (val1 == 1.0 and val2 == 1.0 and val3 == 1.0 and val4 == 1.0 and
			t1 == 0 and t2 == 0 and t3 == 0 and t4 == 0){
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

######################################## compass controll #######################################
# if compass controll is set to MAG (directional gyro slaved to flux valve) and not DG (compass indicate directional gyro heading),
# the offset will be set automatically

var mag_controll = func {
	var mag_selected = getprop("/instrumentation/compass-controll/mag");
	if( mag_selected == nil ) mag_selected = 0.0;
	if( mag_selected ) {
		interpolate("/instrumentation/heading-indicator/offset-deg", 0, 0.25);
		settimer( mag_controll, 82);
	}
}

setlistener( "/instrumentation/compass-controll/mag", mag_controll);

####################################### generator helper #######################################
var gen_kw = func{
		var p = "/controls/special/generator/";
		var f1 = getprop("/controls/special/generator/gen-freq[0]") or 0;
		var f2 = getprop("/controls/special/generator/gen-freq[1]") or 0;
		var f3 = getprop("/controls/special/generator/gen-freq[2]") or 0;
		var f4 = getprop("/controls/special/generator/gen-freq[3]") or 0;

		var a1 = getprop("engines/engine[0]/oil-pressure-psi") or 0;
		var a2 = getprop("engines/engine[1]/oil-pressure-psi") or 0;
		var a3 = getprop("engines/engine[2]/oil-pressure-psi") or 0;
		var a4 = getprop("engines/engine[3]/oil-pressure-psi") or 0;
		
		var gc1 = getprop("/controls/special/generator/gen-controll[0]") or 0;
		var gc2 = getprop("/controls/special/generator/gen-controll[1]") or 0;
		var gc3 = getprop("/controls/special/generator/gen-controll[2]") or 0;
		var gc4 = getprop("/controls/special/generator/gen-controll[3]") or 0;
		
		var gb1 = getprop("/controls/special/generator/gen-breaker[0]") or 0;
		var gb2 = getprop("/controls/special/generator/gen-breaker[1]") or 0;
		var gb3 = getprop("/controls/special/generator/gen-breaker[2]") or 0;
		var gb4 = getprop("/controls/special/generator/gen-breaker[3]") or 0;
		
		var gt1 = getprop("/controls/special/generator/gen-bus-tie[0]") or 0;
		var gt2 = getprop("/controls/special/generator/gen-bus-tie[1]") or 0;
		var gt3 = getprop("/controls/special/generator/gen-bus-tie[2]") or 0;
		var gt4 = getprop("/controls/special/generator/gen-bus-tie[3]") or 0;
		
		var gc = getprop("/controls/special/ground-connect") or 0;
		var lvs = getprop("/controls/special/load-volt-selector") or 0;
		
		if(lvs > 0 and gc and gc1 and gb1 and gt1){
		  var k1 = a1*f1;
		  interpolate("engines/engine[0]/kw", k1, 2.1);
		}else{
			interpolate("engines/engine[0]/kw", 0, 0.5);
		}
		
		if(lvs > 0 and gc and gc2 and gb2 and gt2){
		  var k2 = a2*f2;
		  interpolate("engines/engine[1]/kw", k2, 2.1);
		}else{
			interpolate("engines/engine[1]/kw", 0, 0.5);
		}	
		
		if(lvs > 0 and gc and gc3 and gb3 and gt3){
		  var k3 = a3*f3;
		  interpolate("engines/engine[2]/kw", k3, 2.1);
		}else{
			interpolate("engines/engine[2]/kw", 0, 0.5);
		}	
		
		if(lvs > 0 and gc and gc4 and gb4 and gt4){
		  var k4 = a4*f4;
		  interpolate("engines/engine[3]/kw", k4, 2.1);
		}else{
			interpolate("engines/engine[3]/kw", 0, 0.5);
		}
		
		settimer( gen_kw, 2);
}

#fire it up
gen_kw();

################################### AC Paralleling Selector ####################################
setlistener("controls/special/ac/ac-power", func{
	var bat = getprop("/controls/electric/battery-switch") or 0;
	if(bat){
		setprop("/controls/special/ac/sync1", 1);
		setprop("/controls/special/ac/sync2", 1);
		settimer( func { setprop("/controls/special/ac/sync1",0); }, 0.75);
		settimer( func { setprop("/controls/special/ac/sync2",0); }, 1.1);
	}
},1,0);

