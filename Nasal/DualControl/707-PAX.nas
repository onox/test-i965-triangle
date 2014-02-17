#######################################################################################
#		Lake of Constance Hangar :: M.Kraus
#		Boeing 707 for Flightgear February 2014
#		This file is licenced under the terms of the GNU General Public Licence V2 or later
#######################################################################################

setlistener("sim/current-view/view-number", func (n){
  var n = n.getValue() or 0;
  if (n == 0){
    setprop("sim/current-view/view-number",2);
  }elsif (n == 1){
  	setprop("sim/current-view/view-number",2);
  }elsif (n == 2){
  	setprop("sim/current-view/view-number",5);
  }elsif (n == 5){
  	setprop("sim/current-view/view-number",7);
  }elsif (n == 6){
  	setprop("sim/current-view/view-number",7);
  }elsif (n == 7){
  	setprop("sim/current-view/view-number",7);
  }elsif (n == 8){
  	setprop("sim/current-view/view-number",12);
  }elsif (n == 9){
  	setprop("sim/current-view/view-number",12);
  }elsif (n == 11){
  	setprop("sim/current-view/view-number",12);
  }else{
  	setprop("sim/current-view/view-number",12);
  }
});
