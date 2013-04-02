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
