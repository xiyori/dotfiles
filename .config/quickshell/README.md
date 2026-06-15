# Quickshell Analog Clock Widget

This adds a configurable analog clock widget for Quickshell.

## Files

- `.config/quickshell/AnalogClock.qml` – reusable analog clock component.
- `.config/quickshell/shell.qml` – minimal popup usage example with opacity appear/disappear animation.

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
