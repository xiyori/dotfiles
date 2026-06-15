import QtQuick

Item {
    id: root

    // --- Geometry ---
    property int size: 280
    width: size
    height: size

    // --- Face / border ---
    property color faceColor: "#00000000" // transparent by default
    property color borderColor: "#d8dee9"
    property real borderWidth: 3

    // --- Markings ---
    property color markingColor: "#d8dee9"
    property int totalMarkings: 60
    property real minuteMarkLength: size * 0.045
    property real hourMarkLength: size * 0.085
    property real markingWidth: Math.max(1, size * 0.008)

    // --- Numerals ---
    property bool showNumerals: true
    property string numeralStyle: "arabic" // "arabic" | "roman"
    property bool rotateNumerals: false
    property real numeralRadiusFactor: 0.78 // relative to outer radius
    property color numeralColor: markingColor
    property int numeralFontSize: Math.max(10, Math.round(size * 0.09))
    property string numeralFontFamily: "Sans Serif"
    property int numeralFontWeight: Font.DemiBold
    property bool numeralItalic: false

    // --- Hands ---
    property color hourHandColor: "#eceff4"
    property color minuteHandColor: "#88c0d0"
    property color secondHandColor: "#bf616a"

    property real hourHandLengthFactor: 0.50
    property real minuteHandLengthFactor: 0.72
    property real secondHandLengthFactor: 0.82

    property real hourHandWidth: Math.max(3, size * 0.024)
    property real minuteHandWidth: Math.max(2, size * 0.016)
    property real secondHandWidth: Math.max(1, size * 0.008)

    property color centerDotColor: "#d8dee9"
    property real centerDotRadius: Math.max(2, size * 0.018)

    // --- Time source ---
    property date currentTime: new Date()
    property bool smoothSeconds: true

    readonly property real radius: Math.min(width, height) / 2

    function numeralText(hour) {
        if (numeralStyle === "roman") {
            const roman = ["XII", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI"]
            return roman[hour % 12]
        }
        return hour === 0 ? "12" : String(hour)
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            const ctx = getContext("2d")
            const w = width
            const h = height
            const cx = w / 2
            const cy = h / 2
            const r = Math.min(w, h) / 2

            ctx.reset()
            ctx.clearRect(0, 0, w, h)

            // Face
            if (root.faceColor.a > 0) {
                ctx.beginPath()
                ctx.arc(cx, cy, r - root.borderWidth / 2, 0, Math.PI * 2)
                ctx.fillStyle = root.faceColor
                ctx.fill()
            }

            // Border
            if (root.borderWidth > 0) {
                ctx.beginPath()
                ctx.arc(cx, cy, r - root.borderWidth / 2, 0, Math.PI * 2)
                ctx.strokeStyle = root.borderColor
                ctx.lineWidth = root.borderWidth
                ctx.stroke()
            }

            // Markings
            ctx.strokeStyle = root.markingColor
            ctx.lineCap = "round"
            for (let i = 0; i < root.totalMarkings; i++) {
                const isHour = (i % 5 === 0)
                const angle = (i / root.totalMarkings) * Math.PI * 2 - Math.PI / 2
                const markLen = isHour ? root.hourMarkLength : root.minuteMarkLength

                const outer = r - root.borderWidth - 1
                const inner = outer - markLen

                ctx.beginPath()
                ctx.lineWidth = root.markingWidth
                ctx.moveTo(cx + Math.cos(angle) * outer, cy + Math.sin(angle) * outer)
                ctx.lineTo(cx + Math.cos(angle) * inner, cy + Math.sin(angle) * inner)
                ctx.stroke()
            }

            const now = root.currentTime
            const hours = now.getHours() % 12
            const minutes = now.getMinutes()
            const seconds = now.getSeconds() + (root.smoothSeconds ? now.getMilliseconds() / 1000 : 0)

            const hourAngle = ((hours + minutes / 60 + seconds / 3600) / 12) * Math.PI * 2 - Math.PI / 2
            const minuteAngle = ((minutes + seconds / 60) / 60) * Math.PI * 2 - Math.PI / 2
            const secondAngle = (seconds / 60) * Math.PI * 2 - Math.PI / 2

            function drawHand(angle, length, width, color) {
                ctx.beginPath()
                ctx.lineWidth = width
                ctx.lineCap = "round"
                ctx.strokeStyle = color
                ctx.moveTo(cx, cy)
                ctx.lineTo(cx + Math.cos(angle) * length, cy + Math.sin(angle) * length)
                ctx.stroke()
            }

            drawHand(hourAngle, r * root.hourHandLengthFactor, root.hourHandWidth, root.hourHandColor)
            drawHand(minuteAngle, r * root.minuteHandLengthFactor, root.minuteHandWidth, root.minuteHandColor)
            drawHand(secondAngle, r * root.secondHandLengthFactor, root.secondHandWidth, root.secondHandColor)

            // Center dot
            ctx.beginPath()
            ctx.arc(cx, cy, root.centerDotRadius, 0, Math.PI * 2)
            ctx.fillStyle = root.centerDotColor
            ctx.fill()
        }
    }

    Repeater {
        model: showNumerals ? 12 : 0

        delegate: Text {
            required property int index

            readonly property int hour: index + 1
            readonly property real angle: (hour / 12) * Math.PI * 2 - Math.PI / 2
            readonly property real nr: root.radius * root.numeralRadiusFactor

            text: root.numeralText(hour % 12)
            color: root.numeralColor
            font.pixelSize: root.numeralFontSize
            font.family: root.numeralFontFamily
            font.weight: root.numeralFontWeight
            font.italic: root.numeralItalic

            x: root.width / 2 + Math.cos(angle) * nr - width / 2
            y: root.height / 2 + Math.sin(angle) * nr - height / 2

            rotation: root.rotateNumerals ? (hour * 30) : 0
            transformOrigin: Item.Center
        }
    }

    // Smooth repaint (for second hand); can be disabled via smoothSeconds
    Timer {
        interval: root.smoothSeconds ? 16 : 1000
        running: true
        repeat: true
        onTriggered: {
            root.currentTime = new Date()
            canvas.requestPaint()
        }
    }

    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    onCurrentTimeChanged: canvas.requestPaint()
}
