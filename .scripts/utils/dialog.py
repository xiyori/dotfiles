#!/usr/bin/python

import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk


class MonitorDialog(Gtk.Dialog):
    def __init__(self):
        super().__init__(title="xfce4-notifyd", flags=0)
        self.add_buttons(
            "Mirror", 42, "External only", 43
        )

        self.set_default_size(150, 100)

        main_label = Gtk.Label()
        main_label.set_markup("<span size=\"large\"><b>External monitor connected</b></span>")
        main_label.set_margin_top(15)

        question = Gtk.Label()
        question.set_markup("<span size=\"medium\">Select display mode</span>")
        question.set_margin_top(5)
        question.set_margin_bottom(15)

        box = self.get_content_area()
        box.add(main_label)
        box.add(question)
        self.show_all()


dialog = MonitorDialog()
response = dialog.run()

if response == 42:
    print("mirror")
elif response == 43:
    print("external")

dialog.destroy()
