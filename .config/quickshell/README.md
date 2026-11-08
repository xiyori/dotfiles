# Quickshell bar and widgets

Replaces waybar (top bar) and eww (tablet-mode sound/brightness panels). Started from `~/.scripts/autostart.sh`.

## Files

- `shell.qml` – entry point: a `Bar` per screen, the touch panels, and IPC handlers.
- `Bar.qml` – module layout, ported from the old waybar config and styling.
- `Workspaces.qml` – workspace icons plus a clickable, scrollable minimap of the active workspace's niri columns.
- `AppIcons.qml` – app icon rules in waybar `window-rewrite` syntax (`class<regex> title<regex>`), used by the minimap.
- `Niri.qml` – live niri state from `niri msg event-stream`.
- `SoundPanel.qml`, `BrightnessPanel.qml` – tablet-mode widgets.

## Scripts

- `~/.scripts/bar_refresh <module>` re-runs a bar module's script (replaces `pkill -RTMIN+N waybar`).
  Modules: `sound` (1), `autogain` (2), `monitor` (3), `updates` (4), `soundprofile` (5).
- `~/.scripts/widget_toggle <sound|brightness>` toggles a touch panel (replaces `eww open/close`).

Both wrap `qs ipc call`, see the `IpcHandler`s in `shell.qml`.

# Analog clock widget

`AnalogClock.qml` is a standalone, configurable analog clock component. It is not used by the bar.

## Files

- `.config/quickshell/AnalogClock.qml` – reusable analog clock component.

## Features

- Round analog clock face with customizable:
  - Border color/width
  - Hour/minute/second hand colors and sizes
  - Hour/minute tick mark colors and lengths
- Optional numerals:
  - Arabic or Roman style
  - Configurable font family/size/weight/italic
  - Optional rotation by position (`rotateNumerals`)
- Hour markings are longer than minute markings (toward center)
- Show/hide animation via opacity (`Behavior on opacity`)

## Main settings (AnalogClock.qml)

- `size`
- `faceColor`, `borderColor`, `borderWidth`
- `markingColor`, `minuteMarkLength`, `hourMarkLength`, `markingWidth`
- `showNumerals`, `numeralStyle`, `rotateNumerals`
- `numeralFontSize`, `numeralFontFamily`, `numeralFontWeight`, `numeralItalic`, `numeralColor`
- `hourHandColor`, `minuteHandColor`, `secondHandColor`
- `hourHandLengthFactor`, `minuteHandLengthFactor`, `secondHandLengthFactor`
- `hourHandWidth`, `minuteHandWidth`, `secondHandWidth`
- `centerDotColor`, `centerDotRadius`
- `smoothSeconds`

## Visibility animation

In `shell.qml`, toggle `clockVisible`:

- `true` → clock fades in
- `false` → clock fades out

Animation is done with `Behavior on opacity`.
