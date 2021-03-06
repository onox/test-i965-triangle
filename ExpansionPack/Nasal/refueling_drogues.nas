# Copyright (C) 2016  onox
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

io.include("Aircraft/onox-tanker/ExpansionPack/Nasal/init.nas");

with("math_ext");
with("updateloop");

var version = {
    major: 2,
    minor: 2
};

# Period of displaying message containing the distance to the closest callsign
var callsign_distance_update_period = 4.0;

# Extra margin to prevent bouncing between contact and lost-contact states
var track_margin_m = 2.0;

var get_time = func (time) {
    var seconds = math.mod(time, 60);
    var minutes = (time - seconds) / 60;
    return [minutes, seconds];
};

var get_drogue_end_point = func (callback_pose, index) {
    var (line_heading_deg, line_pitch_deg, line_distance) = callback_pose();

    var z = -line_distance * math_ext.sin(line_pitch_deg);
    var a =  line_distance * math_ext.cos(line_pitch_deg);

    var x =  a * math_ext.cos(line_heading_deg);
    var y = -a * math_ext.sin(line_heading_deg);

    x = x + getprop("/refueling/drogues/drogue", index, "origin/x-m");
    y = y + getprop("/refueling/drogues/drogue", index, "origin/y-m");
    z = z + getprop("/refueling/drogues/drogue", index, "origin/z-m");

    var pitch_deg = getprop("/orientation/pitch-deg");
    var roll_deg  = getprop("/orientation/roll-deg");
    var heading_deg = getprop("/orientation/heading-deg");

    # Calculate the actual end point of the refueling droge in the inertial frame
    var (end_point_2d, end_point) = math_ext.get_point(x, y, z, roll_deg, pitch_deg, heading_deg);

    return end_point;
};

var get_aar_point_mp = func (mp_node) {
    var type = mp_node.getNode("refuel/type", "").getValue();

    # Get offset of AAR point
    var x = mp_node.getNode("refuel/offset-x-m", 0);
    var y = mp_node.getNode("refuel/offset-y-m", 0);
    var z = mp_node.getNode("refuel/offset-z-m", 0);

    if (x == nil or y == nil or z == nil or type != "probe") {
        return nil;
    }

    # Get position of MP aircraft
    var lat = mp_node.getNode("position/latitude-deg").getValue();
    var lon = mp_node.getNode("position/longitude-deg").getValue();
    var alt = mp_node.getNode("position/altitude-ft").getValue();
    var mp_position = geo.Coord.new().set_latlon(lat, lon, alt * globals.FT2M);

    # Get orientation of MP aircraft
    var roll_deg = mp_node.getNode("orientation/roll-deg").getValue();
    var pitch_deg = mp_node.getNode("orientation/pitch-deg").getValue();
    var heading_deg = mp_node.getNode("orientation/true-heading-deg").getValue();

    var (fuel_point_2d, fuel_point) = math_ext.get_point(x.getValue(), y.getValue(), z.getValue(), roll_deg, pitch_deg, heading_deg, mp_position);
    return fuel_point;
};

var DrogueTrackingUpdater = {

    new: func (callback_pose, index) {
        var m = {
            parents: [DrogueTrackingUpdater]
        };
        m.loop = updateloop.UpdateLoop.new(components: [m], update_period: 0.0, enable: 0);
        m.callback_pose = callback_pose;
        m.index = index;
        m.chooser = nil;
        m.callsign = "";
        m.time_contact = nil;

        return m;
    },

    enable: func {
        me.loop.reset();
        me.loop.enable();
    },

    disable: func {
        me.loop.disable();
        me.publish_time();
    },

    reset: func {
        # Empty
    },

    set_chooser: func (chooser) {
        me.chooser = chooser;
    },

    set_receiver: func (callsign) {
        assert(callsign == nil or callsign != "");

        var contact = callsign != nil;
        var old_callsign = me.callsign;
        me.callsign = contact ? callsign : "";

        setprop("/refueling/drogues/drogue", me.index, "contact/active", contact);
        setprop("/refueling/drogues/drogue", me.index, "contact/callsign", me.callsign);

        if (contact) {
            if (me.callsign != old_callsign) {
                setprop("/sim/multiplay/chat", "Contact!");
            }
            me.time_contact = systime();

            me.chooser.disable();
            me.enable();
        }
        else {
            if (me.callsign != old_callsign) {
                setprop("/sim/multiplay/chat", "Lost contact!");
            }

            me.disable();
            me.chooser.enable();
        }
    },

    publish_time: func {
        if (me.time_contact != nil) {
            var (minutes, seconds) = get_time(systime() - me.time_contact);
            setprop("/sim/multiplay/chat", sprintf("Time: %d minutes %d seconds", minutes, seconds));
            me.time_contact = nil;
        }
    },

    update: func (dt) {
        # Assert that a user is currently being tracked
        assert(me.callsign != "");

        var mp_node = me._find_mp_aircraft(me.callsign);

        # Stop tracking if current receiver has disappeared
        if (mp_node == nil) {
            me.set_receiver(nil);
            return;
        }

        # Compute distance between end point (drogue) and
        # the AAR point of the receiver
        var fuel_point = get_aar_point_mp(mp_node);
        var distance = get_drogue_end_point(me.callback_pose, me.index).direct_distance_to(fuel_point);

        # Update the position of the receiver if it is still within maximum track distance
        # Otherwise stop tracking the current receiver
        if (distance <= getprop("/refueling/drogues/max-contact-distance-m") + track_margin_m) {
            me.receiver = fuel_point;
        }
        else {
            me.set_receiver(nil);
            return;
        }

        var origin_x = getprop("/refueling/drogues/drogue", me.index, "origin/x-m");
        var origin_y = getprop("/refueling/drogues/drogue", me.index, "origin/y-m");
        var origin_z = getprop("/refueling/drogues/drogue", me.index, "origin/z-m");

        var roll_deg  = getprop("/orientation/roll-deg");
        var pitch_deg = getprop("/orientation/pitch-deg");
        var heading   = getprop("/orientation/heading-deg");

        # Compute the actual position of the origin of the hose (Hose Drum Unit)
        var (hose_origin_2d, hose_origin) = math_ext.get_point(origin_x, origin_y, origin_z, roll_deg, pitch_deg, heading);

        var (yaw, pitch, distance) = math_ext.get_yaw_pitch_distance_inert(hose_origin_2d, hose_origin, me.receiver, heading);
        (yaw, pitch) = math_ext.get_yaw_pitch_body(roll_deg, pitch_deg, yaw, pitch);

        setprop("/refueling/drogues/drogue", me.index, "commands/heading-deg", geo.normdeg180(yaw));
        setprop("/refueling/drogues/drogue", me.index, "commands/pitch-deg", -pitch);
        setprop("/refueling/drogues/drogue", me.index, "commands/length-m", distance);

        var receiver_pitch_deg = mp_node.getNode("orientation/pitch-deg").getValue();
        var receiver_heading   = mp_node.getNode("orientation/true-heading-deg").getValue();
        setprop("/refueling/drogues/drogue", me.index, "commands/drogue-yaw-deg", heading - receiver_heading);
        setprop("/refueling/drogues/drogue", me.index, "commands/drogue-pitch-deg", receiver_pitch_deg);
    },

    _find_mp_aircraft: func (callsign) {
        # Find and return an MP aircraft that has the given callsign

        if (contains(multiplayer.model.callsign, callsign)) {
            return multiplayer.model.callsign[callsign].node;
        };
        return nil;
    }

};

var ReceiverDecisionUpdater = {

    new: func (tracker, index) {
        var m = {
            parents: [ReceiverDecisionUpdater],
            tracker: tracker
        };
        m.loop = updateloop.UpdateLoop.new(components: [m], update_period: 0.0, enable: 0);
        m.index = index;
        m.ai_models = props.globals.getNode("/ai/models", 1);

        m.callsign_timer = maketimer(callsign_distance_update_period, func {
            var distance = getprop("/refueling/drogues/drogue", index, "closest/distance-m");
            var callsign = getprop("/refueling/drogues/drogue", index, "closest/callsign");
            var message = sprintf("%s: %.1f meter", callsign, distance);
            setprop("/sim/multiplay/chat", message);
        });

        setlistener("/refueling/drogues/drogue[" ~ index ~ "]/closest/callsign", func (n) {
            var waiting = n.getValue() != "";

            if (waiting) {
                m.callsign_timer.restart(callsign_distance_update_period);
            }
            else {
                m.callsign_timer.stop();
            }
        }, 0, 0);

        return m;
    },

    enable: func {
        me.loop.reset();
        me.loop.enable();
    },

    disable: func {
        me.loop.disable();
        setprop("/refueling/drogues/drogue", me.index, "closest/callsign", "");
    },

    enable_or_disable: func (enable) {
        if (enable) {
            me.enable();
        }
        else {
            me.tracker.set_receiver(nil);
            me.disable();
        }
    },

    reset: func {
        # Empty
    },

    update: func (dt) {
        # Assert that no user is currently being tracked
        assert(me.tracker.callsign == "");

        var end_point = get_drogue_end_point(me.tracker.callback_pose, me.index);

        # Check for contact with MP aircraft
        var mp = me.ai_models.getChildren("multiplayer");

        var closest_point = [9999.0, ""];

        foreach (var a; mp) {
            if (!a.getNode("valid", 1).getValue()) {
                continue;
            }

            # Check the MP user's aircraft has a valid fuel point defined
            var fuel_point = get_aar_point_mp(a);
            if (fuel_point == nil) {
                continue;
            }

            var distance = end_point.direct_distance_to(fuel_point);
            if (distance < closest_point[0]) {
                var callsign = a.getNode("callsign").getValue();
                closest_point = [distance, callsign];
            }
        }

        var (distance, callsign) = closest_point;

        if (distance <= getprop("/refueling/drogues/max-contact-distance-m")) {
            me.tracker.set_receiver(callsign);
        }
        elsif (distance <= getprop("/refueling/drogues/max-pre-contact-distance-m")) {
            setprop("/refueling/drogues/drogue", me.index, "closest/distance-m", distance);
            setprop("/refueling/drogues/drogue", me.index, "closest/callsign", callsign);
        }
        else {
            setprop("/refueling/drogues/drogue", me.index, "closest/distance-m", 0.0);
            setprop("/refueling/drogues/drogue", me.index, "closest/callsign", "");
        }
    }

};
