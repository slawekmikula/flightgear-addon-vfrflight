#
# VFRFlight addon
#
# Author: Slawek Mikula
# Started on December 2019

var main = func( addon ) {
    var root = addon.basePath;
    var my_addon_id  = addon.id;
    var my_settings_root_path = "/addons/by-id/" ~ my_addon_id ~ "/addon-devel/";

    var udpHostNode = props.globals.getNode(my_settings_root_path ~ "/udp-host", 1);
    udpHostNode.setAttribute("userarchive", "y");
    if (udpHostNode.getValue() == nil) {
      udpHostNode.setValue("localhost");
    }
    var udpPortNode = props.globals.getNode(my_settings_root_path ~ "/udp-port", 1);
    udpPortNode.setAttribute("userarchive", "y");
    if (udpPortNode.getValue() == nil) {
      udpPortNode.setValue("3333");
    }

    var initProtocol = func() {
      var refresh = "10"; # refresh rate
      var udphost = getprop(my_settings_root_path ~ "udp-host") or "localhost";
      var udpport = getprop(my_settings_root_path ~ "udp-port") or "3333";
      var protocolstring = "generic,socket,out," ~ refresh ~ "," ~ udphost ~ "," ~ udpport ~ ",udp,vfrflight";

      fgcommand("add-io-channel",
        props.Node.new({
            "config" : protocolstring,
            "name" : "vfrflight"
        })
      );
    }

    var init = setlistener("/sim/signals/fdm-initialized", func() {
        removelistener(init); # only call once
        initProtocol();
    });

    var reinit_listener = _setlistener("/sim/signals/reinit", func {
        removelistener(reinit_listener); # only call once
        initProtocol();
    });

    var exit = setlistener("/sim/signals/exit", func() {
      removelistener(exit); # only call once

      fgcommand("remove-io-channel",
        props.Node.new({ 
            "name" : "vfrflight"
        })
      );
    });
}
