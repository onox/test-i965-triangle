# Lake of Constance Hangar :: M.Kraus
# Avril 2013

################################ Reverser ####################################
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

	val = getprop(rv1);

	if (val == 0 or val == nil) {
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
		if (val == 1.0){
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
help_win.fg = [0,1,1,1];

var messenger = func{
help_win.write(arg[0]);
}
print("Help subsystem started");

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

setlistener( "/instrumentation/altimeter/setting-inhg", h_altimeter );
setlistener( "/autopilot/settings/heading-bug-deg", h_heading );
setlistener( "/autopilot/settings/target-speed-kt", h_tas );
setlistener( "/autopilot/settings/vertical-speed-fpm", h_vs);


var show_alti = func {
  var s_alti = getprop("/instrumentation/altimeter/indicated-altitude-ft") or 0;
  help_win.write(sprintf("Actual altitude is: %.0f ", s_alti) );
}

