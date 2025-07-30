#!/bin/python

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

# Custom command to run on play/pause event
CUSTOM_COMMAND = "echo 'Play/Pause event detected'"

def run_command(command):
    # Run the custom command
    import subprocess
    print(command)
    subprocess.run(command, shell=True)

def on_properties_changed(interface_name, changed_properties, invalidated_properties):
    if interface_name == "org.mpris.MediaPlayer2.Player":
        for key, properties in changed_properties.items():
            # print(key)
            if key == "PlaybackStatus":
                if properties == "Playing":
                    run_command('echo "1" > /tmp/player_status && ~/.scripts/audio/youtube_volume.sh')
                elif properties == "Paused":
                    run_command('echo 2 > /tmp/player_status')
                else:
                    run_command('echo 0 > /tmp/player_status')
                run_command('pkill -RTMIN+1 waybar')
            elif key == "Metadata":
                # print(properties)
                metadata = properties.get("xesam:artist", [""])[0]
                if metadata != "":
                    metadata += " - "
                metadata += properties.get("xesam:title", "")
                if metadata == "":
                    run_command('echo 0 > /tmp/player_status && echo > /tmp/player_metadata')
                else:
                    run_command(f'echo "{metadata}" | jq -R . > /tmp/player_metadata')
                run_command(f'~/.scripts/audio/player_status.sh && pkill -RTMIN+1 waybar && sleep 0.5 && ~/.scripts/audio/youtube_volume.sh')
    # Detect audio sink disconnect
    if interface_name == "org.freedesktop.systemd1.Device":
        for key, properties in changed_properties.items():
            if key == "SysFSPath" and properties == "":
                run_command('~/.scripts/audio/detect_sink_change.sh')

def on_name_owner_changed(bus_name, old_owner, new_owner):
    if bus_name.startswith('org.mpris.MediaPlayer2'):
        # print(f"MPRIS player {bus_name} is now owned by {new_owner}")
        run_command('~/.scripts/audio/player_status.sh && ~/.scripts/audio/whatsong.sh')
        # session_bus = dbus.SessionBus()
        # media_player_iface = 'org.mpris.MediaPlayer2.Player'
        #
        # try:
        #     player_proxy = session_bus.get_object(bus_name, '/org/mpris/MediaPlayer2')
        #     player_iface = dbus.Interface(player_proxy, media_player_iface)
        #
        #     # Connect to the PropertiesChanged signal
        #     player_iface.connect_to_signal('PropertiesChanged', on_properties_changed)
        # except dbus.DBusException as e:
        #     print(f"Error connecting to MPRIS player: {e}")

def main():
    DBusGMainLoop(set_as_default=True)

    session_bus = dbus.SessionBus()
    session_bus.add_signal_receiver(on_name_owner_changed, 'NameOwnerChanged', 'org.freedesktop.DBus')

    try:
        session_bus.add_signal_receiver(on_properties_changed,
                                        dbus_interface='org.freedesktop.DBus.Properties',
                                        signal_name='PropertiesChanged')
    except dbus.DBusException as e:
        print(f"Error setting up signal receiver: {e}")
        return

    mainloop = GLib.MainLoop()
    try:
        mainloop.run()
    except KeyboardInterrupt:
        pass

if __name__ == "__main__":
    main()
