# Lake of Constance Hangar :: M.Kraus
# May 2013
# This file is licenced under the terms of the GNU General Public Licence V2 or later
## ENGINES
##########

# APU loop function

var apuLoop = func
 {

	if (getprop("engines/APU/rpm") >= 80) {
		setprop("engines/APU/serviceable",1);
	} else {
		setprop("engines/APU/serviceable",0);
	}

 var setting = getprop("controls/APU/off-start-run");
 var generator = getprop("controls/special/apu/apu-gen");

 # rpm and running
 if (setting != 0)
  {
  if (setting == 1)
   {
   var rpm = getprop("engines/APU/rpm");
   rpm += getprop("sim/time/delta-realtime-sec") * 7;
   if (rpm >= 100){
    	rpm = 100;
		  setprop("controls/APU/off-start-run",2); # automatic spring for the apu-master-switch
		  if(getprop("/sim/sound/switch2") == 1){
		  	 setprop("/sim/sound/switch2", 0); 
		  }else{
		  	 setprop("/sim/sound/switch2", 1);
		  }
    }
   setprop("engines/APU/rpm", rpm);
   }
  elsif (setting == 2 and getprop("engines/APU/rpm") >= 80)
   {
   props.globals.getNode("engines/APU/running").setBoolValue(1);
   }
  }
 else
  {
  props.globals.getNode("engines/APU/running").setBoolValue(0);

  var rpm = getprop("engines/APU/rpm");
  rpm -= getprop("sim/time/delta-realtime-sec") * 5;
  if (rpm < 0)
   {
   rpm = 0;
   }
  setprop("engines/APU/rpm", rpm);
  }
  
  # the generator and amp-v
  if (generator != 0 and getprop("engines/APU/rpm") >= 80){
		if (generator == 1){
		 var amp = getprop("engines/APU/amp-v");
		 amp += getprop("sim/time/delta-realtime-sec") * 12;
		 if (amp >= 144){
			amp = 144;
			}
		 setprop("engines/APU/amp-v", amp);
		 }
  }else{
		var amp = getprop("engines/APU/amp-v");
		amp -= getprop("sim/time/delta-realtime-sec") * 9;
	 	if (amp < 0){
		 amp = 0;
		}
		setprop("engines/APU/amp-v", amp);
  }
  
  # the apu temperature
  if (getprop("engines/APU/rpm") >= 40){

		 var temp = getprop("/engines/APU/temp");
		 if(!generator){
			 temp += getprop("sim/time/delta-realtime-sec") * 4;
			 if (temp >= 510){
				temp = 510;
				}
			}else{
			 temp += getprop("sim/time/delta-realtime-sec") * 6;
			 if (temp >= 610){
				temp = 610;
				}
			}
		 setprop("engines/APU/temp", temp);

  }else{
		var temp = getprop("engines/APU/temp") or 0;
		temp -= getprop("sim/time/delta-realtime-sec") * 2;
	 	if (temp < 0){
		 temp = 0;
		}
		setprop("engines/APU/temp", temp);
  }

 settimer(apuLoop, 0);
 };
 
 
# main loop function
var engineLoop = func(engine_no)
 {
 # control the throttles and main engine properties
 var engineCtlTree = "controls/engines/engine[" ~ engine_no ~ "]/";
 var engineOutTree = "engines/engine[" ~ engine_no ~ "]/";

 # the FDM switches the running property to true automatically if the cutoff is set to false, this is unwanted
 if (props.globals.getNode(engineOutTree ~ "running").getBoolValue() and !props.globals.getNode(engineOutTree ~ "started").getBoolValue())
  {
  props.globals.getNode(engineOutTree ~ "running").setBoolValue(0);
  }

 if (props.globals.getNode(engineOutTree ~ "on-fire").getBoolValue())
  {
  props.globals.getNode(engineOutTree ~ "failed").setBoolValue(1);
  }
 if (props.globals.getNode(engineCtlTree ~ "cutoff").getBoolValue() or props.globals.getNode(engineOutTree ~ "failed").getBoolValue())
  {
  if (getprop(engineOutTree ~ "rpm") > 0)
   {
   var rpm = getprop(engineOutTree ~ "rpm");
   rpm -= getprop("sim/time/delta-realtime-sec") * 2.5;
   setprop(engineOutTree ~ "rpm", rpm);
   }
  else
   {
   setprop(engineOutTree ~ "rpm", 0);
   }

  props.globals.getNode(engineOutTree ~ "running").setBoolValue(0);
  props.globals.getNode(engineOutTree ~ "started").setBoolValue(0);
  setprop(engineCtlTree ~ "throttle-lever", 0);
  }
 elsif (props.globals.getNode(engineCtlTree ~ "starter").getBoolValue() and props.globals.getNode("engines/APU/running").getBoolValue())
  {
  props.globals.getNode(engineCtlTree ~ "cutoff").setBoolValue(0);

  var rpm = getprop(engineOutTree ~ "rpm");
  rpm += getprop("sim/time/delta-realtime-sec") * 3;
  setprop(engineOutTree ~ "rpm", rpm);

  if (rpm >= getprop(engineOutTree ~ "n1"))
   {
#   props.globals.getNode(engineCtlTree ~ "starter").setBoolValue(0);
   props.globals.getNode(engineOutTree ~ "started").setBoolValue(1);
   props.globals.getNode(engineOutTree ~ "running").setBoolValue(1);
   }
  else
   {
   props.globals.getNode(engineOutTree ~ "running").setBoolValue(0);
   }
  }
 elsif (props.globals.getNode(engineOutTree ~ "running").getBoolValue())
  {
  if (getprop("autopilot/settings/speed") == "speed-to-ga")
   {
   setprop(engineCtlTree ~ "throttle-lever", 1);
   }
  else
   {
   setprop(engineCtlTree ~ "throttle-lever", getprop(engineCtlTree ~ "throttle"));
   }

  setprop(engineOutTree ~ "rpm", getprop(engineOutTree ~ "n1"));
  }

 settimer(func
  {
  engineLoop(engine_no);
  }, 0);
 };
# start the loop 2 seconds after the FDM initializes
setlistener("sim/signals/fdm-initialized", func
 {
 settimer(func
  {
  engineLoop(0);
  engineLoop(1);
  engineLoop(2);
  engineLoop(3);
  apuLoop();
  }, 2);
 });

# startup/shutdown functions
var startup = func
 {
	setprop("controls/engines/engine[0]/throttle", 0);
	setprop("controls/engines/engine[1]/throttle", 0);
	setprop("controls/engines/engine[2]/throttle", 0);
	setprop("controls/engines/engine[3]/throttle", 0);
	setprop("controls/APU/off-start-run", 2);
	setprop("engines/APU/rpm", 100);
	setprop("controls/electric/battery-switch", 1);
	setprop("controls/electric/APU-generator", 1);
	setprop("controls/electric/external-power", 1);
	setprop("controls/electric/engine[0]/generator", 1);
	setprop("controls/electric/engine[1]/generator", 1);
	setprop("controls/electric/engine[2]/generator", 1);
	setprop("controls/electric/engine[3]/generator", 1);
	setprop("controls/engines/engine[0]/cutoff", 1);
	setprop("controls/engines/engine[1]/cutoff", 1);
	setprop("controls/engines/engine[2]/cutoff", 1);
	setprop("controls/engines/engine[3]/cutoff", 1);
	setprop("consumables/fuel/tank[0]/selected", 1);
	setprop("consumables/fuel/tank[2]/selected", 1);
	setprop("consumables/fuel/tank[1]/selected", 1);
	setprop("controls/engines/engine[0]/starter", 1);
	setprop("controls/engines/engine[1]/starter", 1);
	setprop("controls/engines/engine[2]/starter", 1);
	setprop("controls/engines/engine[3]/starter", 1);
	screen.log.write("APU, APU Generator, Battery, External Power and Engine Starters have been turned on.", 1, 1, 1);
	
	 # lights on 
   if(getprop("sim/time/sun-angle-rad") > 1.55){
   		setprop("controls/lighting/beacon", 1);
   		setprop("controls/lighting/landing-light[0]", 1);
   		setprop("controls/lighting/landing-light[1]", 1);
   		setprop("controls/lighting/landing-light[2]", 1);
   		setprop("controls/lighting/nav-lights", 1);
   		setprop("controls/lighting/cabin-lights", 1);
   		setprop("controls/lighting/cabin-dim", 0.8);
   		setprop("controls/lighting/strobe", 1);
   }else{
   		setprop("controls/lighting/beacon", 1);
   		setprop("controls/lighting/nav-lights", 1);    
   }

   settimer(func
    {
			setprop("controls/engines/engine[0]/cutoff", 0);
			setprop("controls/engines/engine[1]/cutoff", 0);
			setprop("controls/engines/engine[2]/cutoff", 0);
			setprop("controls/engines/engine[3]/cutoff", 0);
			setprop("autopilot/settings/heading-bug-deg",getprop("orientation/heading-deg"));
    }, 1);
		
		# switch on the FlightRallyeMode
		var frwKnob = getprop("instrumentation/frw/btn-mode");
		if (frwKnob == 0) {
		  setprop("instrumentation/frw/btn-mode",1);
		  b707.frw_mode();
		}
		
 };

var shutdown = func
 {
	setprop("controls/electric/engine[0]/generator", 0);
	setprop("controls/electric/engine[1]/generator", 0);
	setprop("controls/electric/engine[2]/generator", 0);
	setprop("controls/electric/engine[3]/generator", 0);
	setprop("controls/engines/engine[0]/cutoff", 1);
	setprop("controls/engines/engine[1]/cutoff", 1);
	setprop("controls/engines/engine[2]/cutoff", 1);
	setprop("controls/engines/engine[3]/cutoff", 1);
	setprop("consumables/fuel/tank[0]/selected", 0);
	setprop("consumables/fuel/tank[2]/selected", 0);
	setprop("consumables/fuel/tank[1]/selected", 0);
	setprop("/controls/wiper/degrees",0);
	setprop("controls/APU/off-start-run", 0);
	screen.log.write("The Aircraft Engines have been shut down.", 1, 1, 1);
 };

# listener to activate these functions accordingly
setlistener("sim/model/start-idling", func(idle)
 {
 var autorun = idle.getBoolValue();
 var run1 = props.globals.getNode("engines/engine[0]/running").getBoolValue();
 var run2 = props.globals.getNode("engines/engine[1]/running").getBoolValue();
 var run3 = props.globals.getNode("engines/engine[2]/running").getBoolValue();
 var run4 = props.globals.getNode("engines/engine[3]/running").getBoolValue();
 
 if (autorun and !run1 and !run2 and !run3 and !run4)
  {
  startup();
   settimer(func
    {
			setprop("controls/engines/engine[2]/msg", 1);
    }, 1);
   settimer(func
    {
			setprop("controls/engines/engine[3]/msg", 1);
    }, 7);
   settimer(func
    {
			setprop("controls/engines/engine[1]/msg", 1);
    },12);
   settimer(func
    {
			setprop("controls/engines/engine[0]/msg", 1);
    },19);
   settimer(func
    {
			setprop("controls/engines/msg", 2);
    },28);

  }
 else
  {
  shutdown();
  setprop("controls/engines/msg", 0);
	setprop("controls/engines/engine[0]/msg", 0);
	setprop("controls/engines/engine[1]/msg", 0);
	setprop("controls/engines/engine[2]/msg", 0);
	setprop("controls/engines/engine[3]/msg", 0);
  }
 }, 0, 0);

## GEAR
#######

# prevent retraction of the landing gear when any of the wheels are compressed
setlistener("controls/gear/gear-down", func
 {
 var down = props.globals.getNode("controls/gear/gear-down").getBoolValue();
 if (!down and (getprop("gear/gear[0]/wow") or getprop("gear/gear[1]/wow") or getprop("gear/gear[2]/wow")))
  {
  props.globals.getNode("controls/gear/gear-down").setBoolValue(1);
  }
 });
 
 
## START PROCEDURE ON MAIN SWITCHES ###
#######################################
setlistener("controls/special/start/startercover[2]", func(open)
 {
 	var open = open.getBoolValue();
 	if(open){
	 setprop("controls/engines/engine[2]/msg", 1);
	}
 }, 0, 0); 

 
setlistener("controls/special/start/starter[0]", func
 {
 	var n2 = props.globals.getNode("engines/engine[0]/n2").getValue();
 	var run = props.globals.getNode("engines/engine[0]/running").getBoolValue();
 	var run2 = props.globals.getNode("engines/engine[1]/running").getBoolValue();
 	var run3 = props.globals.getNode("engines/engine[2]/running").getBoolValue();
 	var run4 = props.globals.getNode("engines/engine[3]/running").getBoolValue();
 	if(!run){
	 starter(0);
	}elsif(run and n2 > 35){
	 #continue start procedure if switch mod up;
	 if(run and run2 and run3 and run4) setprop("controls/engines/msg", 2);
	}else{
	 short_stop(0);
	}
 }, 0, 0);
 
setlistener("controls/special/start/starter[1]", func
 {
 	var n2 = props.globals.getNode("engines/engine[1]/n2").getValue();
 	var run = props.globals.getNode("engines/engine[1]/running").getBoolValue();
 	if(!run){
	 starter(1);
	}elsif(run and n2 > 35){
	 #continue start procedure if switch mod up;
	 setprop("controls/engines/engine[0]/msg", 1);
	}else{
	 short_stop(1);
	}
 }, 0, 0);
 
setlistener("controls/special/start/starter[2]", func
 {
 	var n2 = props.globals.getNode("engines/engine[2]/n2").getValue();
 	var run = props.globals.getNode("engines/engine[2]/running").getBoolValue();
 	if(!run){
	 starter(2);
	}elsif(run and n2 > 35){
	 #continue start procedure if switch mod up;
	 setprop("controls/engines/engine[3]/msg", 1);
	}else{
	 short_stop(2);
	}
 }, 0, 0); 
 
setlistener("controls/special/start/starter[3]", func
 {
 	var n2 = props.globals.getNode("engines/engine[3]/n2").getValue();
 	var run = props.globals.getNode("engines/engine[3]/running").getBoolValue();
 	if(!run){
	 starter(3);
	}elsif(run and n2 > 35){
	 #continue start procedure if switch mod up;
	 setprop("controls/engines/engine[1]/msg", 1);
	}else{
	 short_stop(3);
	}
 }, 0, 0);
 
 
var starter = func(nr)
 {
	setprop("controls/engines/engine["~nr~"]/throttle", 0);
	setprop("controls/APU/off-start-run", 2);
	setprop("engines/APU/rpm", 100);
	setprop("controls/electric/battery-switch", 1);
	setprop("controls/electric/APU-generator", 1);
	setprop("controls/electric/external-power", 1);
	setprop("controls/electric/engine["~nr~"]/generator", 1);
	setprop("controls/engines/engine["~nr~"]/cutoff", 1);
	setprop("consumables/fuel/tank[0]/selected", 1);
	setprop("consumables/fuel/tank[2]/selected", 1);
	setprop("consumables/fuel/tank[1]/selected", 1);
	setprop("controls/engines/engine["~nr~"]/starter", 1);

	settimer(func
	{
		setprop("controls/engines/engine["~nr~"]/cutoff", 0);
	}, 1);
		
 };
 
var short_stop = func(nr){
	setprop("controls/electric/engine["~nr~"]/generator", 0);
	setprop("controls/engines/engine["~nr~"]/cutoff", 1);
	setprop("controls/engines/engine["~nr~"]/starter", 0);
	setprop("controls/engines/engine["~nr~"]/msg", 0);
};

 
 
