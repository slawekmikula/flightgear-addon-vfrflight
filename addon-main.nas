#
# VFRFlight addon
#
# Author: Slawek Mikula
# Started on December 2019

var main = func( addon ) {
    var root = addon.basePath;
    var my_addon_id  = "com.slawekmikula.flightgear.VfrFlight";
    var my_version   = getprop("/addons/by-id/" ~ my_addon_id ~ "/version");
    var my_root_path = getprop("/addons/by-id/" ~ my_addon_id ~ "/path");
    var my_settings_root_path = "/addons/by-id/" ~ my_addon_id ~ "/addon-devel/";
    
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

    var initProtool = func() {
      var refresh = "10"; # refresh rate
      var udphost = getprop(settings ~ "udp-host", "localhost");
      var udpport = getprop(settings ~ "udp-port", "3333");
      var protocolstring = "generic,socket,out," ~ refresh ~ "," ~ host ~ "," ~ udpport ~ ",udp,[addon=" ~ my_addon_id ~ "]/Protocol/vfrflight";

      fgcommand("add-io-channel",
        props.Node.new({
            "config" : protocolstring,
            "name" : "vfrflight"
        })
      );
    }
}
