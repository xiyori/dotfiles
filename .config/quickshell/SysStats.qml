pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Replacements for waybar's cpu, memory, and temperature modules.
Singleton {
    id: root

    property int cpu: 0
    property int memory: 0
    property real cpuTemp: -1
    property real gpuTemp: -1

    property var lastCpu: null

    function parseCpu(text) {
        const f = text.split("\n")[0].trim().split(/\s+/).slice(1, 9).map(Number);
        const total = f.reduce((a, b) => a + b, 0);
        const idle = f[3] + f[4];
        if (lastCpu && total > lastCpu.total)
            cpu = Math.round(100 * (1 - (idle - lastCpu.idle) / (total - lastCpu.total)));
        lastCpu = { total: total, idle: idle };
    }

    function parseMemory(text) {
        const kib = key => Number(text.match(new RegExp("^" + key + ":\\s+(\\d+)", "m"))?.[1] ?? 0);
        const total = kib("MemTotal");
        if (total > 0)
            memory = Math.round(100 * (total - kib("MemAvailable")) / total);
    }

    function parseTemp(text) {
        const v = parseInt(text);
        return isNaN(v) ? -1 : v / 1000;
    }

    FileView {
        id: statFile
        path: "/proc/stat"
        onLoaded: root.parseCpu(text())
    }

    FileView {
        id: meminfoFile
        path: "/proc/meminfo"
        onLoaded: root.parseMemory(text())
    }

    FileView {
        id: cpuTempFile
        path: "/tmp/hwmon4/temp1_input"
        onLoaded: root.cpuTemp = root.parseTemp(text())
        onLoadFailed: root.cpuTemp = -1
    }

    FileView {
        id: gpuTempFile
        path: "/tmp/monitor-temp/temp_max_gpu"
        onLoaded: root.gpuTemp = root.parseTemp(text())
        onLoadFailed: root.gpuTemp = -1
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            statFile.reload();
            meminfoFile.reload();
            cpuTempFile.reload();
            gpuTempFile.reload();
        }
    }
}
