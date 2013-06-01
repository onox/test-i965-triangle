# Lake of Constance Hangar :: M.Kraus
# Avril 2013
# This file is licenced under the terms of the GNU General Public Licence V2 or later
################################ Reverser ####################################
setlistener("/instrumentation/mptcas/on", func(state) {
  var state = state.getBoolValue();  
  if(state) tcas();
}, 0, 1);

var tcas = func {

		var run = getprop("/instrumentation/mptcas/on") or 0;

		var pos_lat = getprop("/position/latitude-deg");
		var pos_lon = getprop("/position/longitude-deg");
		
		var our_pos = geo.aircraft_position();
		var my_hdg = getprop("/orientation/heading-deg");
		
		var display_factor = getprop("/instrumentation/mptcas/display-factor"); # 0.0013 is a range for about 40 - 50 nm
	
		# Multiplayer TCAS
	
		for (var n = 0; n < 20; n += 1) {
		
			var callsign = getprop("ai/models/multiplayer[" ~ n ~ "]/callsign") or 0;
	
			if (getprop("ai/models/multiplayer[" ~ n ~ "]/valid") and callsign and run) {
		
				var mp_lat = getprop("ai/models/multiplayer[" ~ n ~ "]/position/latitude-deg");
				var mp_lon = getprop("ai/models/multiplayer[" ~ n ~ "]/position/longitude-deg");

				# What is our position to the mp?		
				var mp_pos 	= geo.Coord.new();
						mp_pos.set_latlon( mp_lat, mp_lon);
				var hdg_to_mp = our_pos.course_to(mp_pos);
				var distance = our_pos.distance_to(mp_pos) * 0.0005399568034557236;
				var course_to_mp = 360 - geo.normdeg(my_hdg - hdg_to_mp);
				
				var display = distance * display_factor;
				
				# openRadar have no altitude-ft and true-airspeed-kt
				var alt_ft = getprop("ai/models/multiplayer[" ~ n ~ "]/position/altitude-ft") or 0;
			  var tas_kt = getprop("ai/models/multiplayer[" ~ n ~ "]/velocities/true-airspeed-kt") or 0;
			  
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/callsign", callsign);
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/distance-nm", distance);
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/display-nm", display);		
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/course-to-mp",course_to_mp);
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/altitude-ft", alt_ft);
				setprop("instrumentation/mptcas/mp[" ~ n ~ "]/tas-kt", tas_kt);
				
				if (display < 0.051){ 
					setprop("/instrumentation/mptcas/mp[" ~ n ~ "]/show", 1);
				}else{
					setprop("/instrumentation/mptcas/mp[" ~ n ~ "]/show", 0);				
				}
				
			}else{
			
				setprop("/instrumentation/mptcas/mp[" ~ n ~ "]/show", 0);		
			}
	
		}
	
	# AI TCAS
	
		for (var n = 0; n < 20; n += 1) {
		
			var callsign = getprop("ai/models/aircraft[" ~ n ~ "]/callsign") or 0;
	
			if (getprop("ai/models/multiplayer[" ~ n ~ "]/valid") and callsign and run13) {
		
				var ai_lat = getprop("ai/models/aircraft[" ~ n ~ "]/position/latitude-deg");
				var ai_lon = getprop("ai/models/aircraft[" ~ n ~ "]/position/longitude-deg");

				# What is our position to the mp?		
				var mp_pos 	= geo.Coord.new();
						mp_pos.set_latlon( ai_lat, ai_lon);
				var hdg_to_mp = our_pos.course_to(mp_pos);
				var distance = our_pos.distance_to(mp_pos) * 0.0005399568034557236;
				var course_to_mp = 360 - geo.normdeg(my_hdg - hdg_to_mp);
				
				var display = distance * display_factor;
			
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/callsign", callsign);
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/distance-nm", distance);
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/display-nm", display);		
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/course-to-mp",course_to_mp);
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/altitude-ft", getprop("ai/models/aircraft[" ~ n ~ "]/position/altitude-ft"));
				setprop("instrumentation/mptcas/ai[" ~ n ~ "]/tas-kt", getprop("ai/models/aircraft[" ~ n ~ "]/velocities/true-airspeed-kt"));
				
				
				if (display < 0.051){ 
					setprop("/instrumentation/mptcas/ai[" ~ n ~ "]/show", 1);
				}else{
					setprop("/instrumentation/mptcas/ai[" ~ n ~ "]/show", 0);				
				}
				
			}else{
			
				setprop("/instrumentation/mptcas/ai[" ~ n ~ "]/show", 0);		
			}
	
		}
		
	if (run) settimer(tcas, 0.7);
	
}


   

