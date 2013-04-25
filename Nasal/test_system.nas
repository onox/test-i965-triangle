## ENGINES
##########

# explanation of engine properties
# controls/engines/engine[X]/throttle-lever	When the engine isn't running, this value is constantly set to 0; otherwise, we transfer the value of controls/engines/engine[X]/throttle to it
# controls/engines/engine[X]/starter		Triggering it fires up the engine
# engines/engine[X]/running			Set based on the engine state
# engines/engine[X]/rpm				Used in place of the n1 value for the animations and set dynamically based on the engine state
# engines/engine[X]/failed			When triggered the engine is "failed" and cannot be restarted
# engines/engine[X]/on-fire			Self-explanatory

# APU loop function

var apuLoop = func
 {

	if (getprop("engines/APU/rpm") >= 80) {
		setprop("engines/APU/serviceable",1);
	} else {
		setprop("engines/APU/serviceable",0);
	}

 var setting = getprop("controls/APU/off-start-run");

 if (setting != 0)
  {
  if (setting == 1)
   {
   var rpm = getprop("engines/APU/rpm");
   rpm += getprop("sim/time/delta-realtime-sec") * 7;
   if (rpm >= 100)
    {
    rpm = 100;
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
    
   #settimer(func
		#{
		#	setprop("controls/engines/engine[2]/msg", 1);
		#}, 1);
    
   #settimer(func
		#{
		#	setprop("controls/engines/msg", 2);
		#}, 20);
		
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
 var run = idle.getBoolValue();
 if (run)
  {
  startup();
  }
 else
  {
  shutdown();
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
