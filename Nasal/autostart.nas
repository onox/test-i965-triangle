# Lake of Constance Hangar :: M.Kraus
# May 2013
# This file is licenced under the terms of the GNU General Public Licence V2 or later
## ENGINES
##########
var run1 = props.globals.getNode("engines/engine[0]/running");
var run2 = props.globals.getNode("engines/engine[1]/running");
var run3 = props.globals.getNode("engines/engine[2]/running");
var run4 = props.globals.getNode("engines/engine[3]/running");

# startup/shutdown functions
var startup = func
 {
 	setprop("b707/battery-switch", 1);
 	setprop("b707/apu/off-start-run", 0);
	setprop("b707/generator/gen-drive[4]", 0);
	setprop("b707/load-volt-selector", 1);
	setprop("b707/external-power-connected", 1);
	setprop("b707/ess-power-switch", 5);
	setprop("b707/ac/ac-para-select", 6);
	setprop("b707/ground-connect", 1);
	setprop("b707/generator/gen-bus-tie[0]", 0);
	setprop("b707/generator/gen-bus-tie[1]", 0);
	setprop("b707/generator/gen-bus-tie[2]", 0);
	setprop("b707/generator/gen-bus-tie[3]", 0);
	setprop("b707/generator/gen-drive[0]", 1);
	setprop("b707/generator/gen-drive[1]", 1);
	setprop("b707/generator/gen-drive[2]", 1);
	setprop("b707/generator/gen-drive[3]", 1);
	setprop("controls/engines/engine[0]/throttle", 0.25);
	setprop("controls/engines/engine[1]/throttle", 0.25);
	setprop("controls/engines/engine[2]/throttle", 0.25);
	setprop("controls/engines/engine[3]/throttle", 0.25);
	setprop("controls/engines/engine[0]/cutoff", 1);
	setprop("controls/engines/engine[1]/cutoff", 1);
	setprop("controls/engines/engine[2]/cutoff", 1);
	setprop("controls/engines/engine[3]/cutoff", 1);
	setprop("controls/engines/engine[0]/starter", 1);
	setprop("controls/engines/engine[1]/starter", 1);
	setprop("controls/engines/engine[2]/starter", 1);
	setprop("controls/engines/engine[3]/starter", 1);
	
	setprop("consumables/fuel/tank[0]/selected", 1);
	setprop("consumables/fuel/tank[2]/selected", 1);
	setprop("consumables/fuel/tank[1]/selected", 1);
	
	setprop("consumables/fuel/tank[0]/selected", 1);
	setprop("consumables/fuel/tank[2]/selected", 1);
	setprop("consumables/fuel/tank[1]/selected", 1);
	screen.log.write("External Power is connected - Engines start for all engines, now.", 1, 1, 1);
	
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
			setprop("/b707/generator/gen-breaker[0]", 1);			
			setprop("/b707/generator/gen-breaker[1]", 1);			
			setprop("/b707/generator/gen-breaker[2]", 1);			
			setprop("/b707/generator/gen-breaker[3]", 1);
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
 			
	setprop("/b707/generator/gen-bus-tie[0]", 0);
	setprop("/b707/generator/gen-bus-tie[1]", 0);
	setprop("/b707/generator/gen-bus-tie[2]", 0);
	setprop("/b707/generator/gen-bus-tie[3]", 0);
	setprop("controls/engines/engine[0]/cutoff", 1);
	setprop("controls/engines/engine[1]/cutoff", 1);
	setprop("controls/engines/engine[2]/cutoff", 1);
	setprop("controls/engines/engine[3]/cutoff", 1);			
	setprop("/b707/generator/gen-breaker[0]", 0);			
	setprop("/b707/generator/gen-breaker[1]", 0);			
	setprop("/b707/generator/gen-breaker[2]", 0);			
	setprop("/b707/generator/gen-breaker[3]", 0);
	setprop("/controls/wiper/degrees",0);
	setprop("b707/apu/off-start-run", 0);
	screen.log.write("The Aircraft Engines have been shut down.", 1, 1, 1);
 };

# listener to activate these functions accordingly
setlistener("sim/model/start-idling", func(idle)
 {
 var autorun = idle.getBoolValue();
 
 if (autorun and !run1.getBoolValue() and !run2.getBoolValue() and !run3.getBoolValue() and !run4.getBoolValue())
  {
  startup();
  }
 else
  {
  shutdown();
  }
 }, 0, 0);
 
## START PROCEDURE ON MAIN SWITCHES ###
#######################################
var starter = func(nr)
 {
 	var s_bat = getprop("b707/battery-switch") or 0;
	var s_ext_con = getprop("b707/external-power-connected") or 0;
	var s_ess_pwr = getprop("b707/ess-power-switch") or 0;
	var s_ess_bus = getprop("b707/ess-bus") or 0;
	var s_ground_c = getprop("b707/ground-connect") or 0;
	var s_par_sel = getprop("b707/ac/ac-para-select") or 0;
	var s_apu_start = getprop("b707/apu/off-start-run") or 0;
	var s_apu_gen = getprop("b707/generator/gen-drive[4]") or 0;			
	var s_bus_tie = getprop("/b707/generator/gen-bus-tie["~nr~"]") or 0;
	var s_gen_bre = getprop("/b707/generator/gen-breaker["~nr~"]") or 0;
	
	if(s_bat and s_ess_bus > 20 and s_gen_bre and !s_bus_tie and 
			((s_par_sel == 6 and s_ext_con and s_ess_pwr == 5 and s_ground_c == 1) or
		 	 (s_par_sel == 0 and s_apu_start == 2 and s_apu_gen))
		){
	
			# not supported the fuel system for the moment
			setprop("consumables/fuel/tank[0]/selected", 1);
			setprop("consumables/fuel/tank[2]/selected", 1);
			setprop("consumables/fuel/tank[1]/selected", 1);
			setprop("controls/engines/engine["~nr~"]/cutoff", 1);
			settimer(func
			{
				setprop("controls/engines/engine["~nr~"]/cutoff", 0);
			}, 1.2);
	
	}else{
		setprop("controls/engines/engine["~nr~"]/starter", 0);
	}
		
};

setlistener("b707/start/startercover[2]", func(open)
 {
 	var open = open.getBoolValue();
 	if(open){
	 setprop("controls/engines/engine[2]/msg", 1);
	}
 }, 0, 0); 

setlistener("controls/engines/engine[0]/starter", func
 {
 	if(!run1.getBoolValue()){
	 starter(0);
	}
 }, 0, 0);
 
setlistener("controls/engines/engine[1]/starter", func
 {

 	if(!run2.getBoolValue()){
	 starter(1);
	}
 }, 0, 0);
 
setlistener("controls/engines/engine[2]/starter", func
 {
 	if(!run3.getBoolValue()){
	 starter(2);
	}
 }, 0, 0); 
 
setlistener("controls/engines/engine[3]/starter", func
 {
 	if(!run4.getBoolValue()){
	 starter(3);
	}
 }, 0, 0);

setlistener("engines/engine[0]/running", func
 {
 	if(run1.getBoolValue()){
	 setprop("controls/engines/msg", 2);
	}else{
	 setprop("controls/engines/engine[0]/msg", 0);
	 setprop("controls/engines/engine[1]/msg", 0);
	 setprop("controls/engines/engine[2]/msg", 0);
	 setprop("controls/engines/engine[3]/msg", 0);
	 setprop("controls/engines/msg", 0);
	}
 }, 0, 0);
 
setlistener("engines/engine[1]/running", func
 {
 	if(run2.getBoolValue()){
	 setprop("controls/engines/engine[0]/msg", 1);
	}else{
	 setprop("controls/engines/engine[0]/msg", 0);
	 setprop("controls/engines/engine[1]/msg", 0);
	 setprop("controls/engines/engine[2]/msg", 0);
	 setprop("controls/engines/engine[3]/msg", 0);
	 setprop("controls/engines/msg", 0);
	}
 }, 0, 0);
 
setlistener("engines/engine[2]/running", func
 {
 	if(run3.getBoolValue()){
	 setprop("controls/engines/engine[3]/msg", 1);
	}else{
	 setprop("controls/engines/engine[0]/msg", 0);
	 setprop("controls/engines/engine[1]/msg", 0);
	 setprop("controls/engines/engine[2]/msg", 0);
	 setprop("controls/engines/engine[3]/msg", 0);
	 setprop("controls/engines/msg", 0);
	}
 }, 0, 0); 
 
setlistener("engines/engine[3]/running", func
 {
 	if(run4.getBoolValue()){
	 setprop("controls/engines/engine[1]/msg", 1);
	}else{
	 setprop("controls/engines/engine[0]/msg", 0);
	 setprop("controls/engines/engine[1]/msg", 0);
	 setprop("controls/engines/engine[2]/msg", 0);
	 setprop("controls/engines/engine[3]/msg", 0);
	 setprop("controls/engines/msg", 0);
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

 
