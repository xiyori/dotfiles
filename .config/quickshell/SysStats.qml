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

    // Fan speeds (RPM)
    property int cpuFanSpeed: 0
    property int pumpSpeed: 0
    property int gpuFanSpeed: 0
    property int intakeFanSpeed: 0

    // CPU usage by core
    property var cpuUsageByCore: []

    // Memory in GB
    property real memoryUsedGB: 0
    property real memoryTotalGB: 0

    function parseCpu(text) {
        const lines = text.split("\n");
        const f = lines[0].trim().split(/\s+/).slice(1, 9).map(Number);
        const total = f.reduce((a, b) => a + b, 0);
        const idle = f[3] + f[4];
        if (lastCpu && total > lastCpu.total)
            cpu = Math.round(100 * (1 - (idle - lastCpu.idle) / (total - lastCpu.total)));
        lastCpu = { total: total, idle: idle };
    }

    function parseMemory(text) {
        const kib = key => Number(text.match(new RegExp("^" + key + ":\\s+(\\d+)", "m"))?.[1] ?? 0);
        const total = kib("MemTotal");
        const available = kib("MemAvailable");
        if (total > 0) {
            memory = Math.round(100 * (total - available) / total);
            memoryTotalGB = total / 2 ** 20;
            memoryUsedGB = (total - available) / 2 ** 20;
        }
    }

    function parseTemp(text) {
        const v = parseInt(text);
        return isNaN(v) ? -1 : v / 1000;
    }

    function parseFanSpeed(text) {
        const v = parseInt(text);
        return isNaN(v) ? -1 : v;
    }

    function parseCpuUsageByCore(text) {
        const lines = text.split("\n");
        const usage = [];
        lines.forEach((line) => {
            if (line.startsWith("cpu")) {
                const parts = line.trim().split(/\s+/);
                if (parts.length > 1 && parts[0] !== "cpucpu") {
                    const values = parts.slice(1).map(Number);
                    const user = values[0] || 0;
                    const nice = values[1] || 0;
                    const system = values[2] || 0;
                    const idle = values[3] || 0;
                    const iowait = values[4] || 0;
                    const irq = values[5] || 0;
                    const softirq = values[6] || 0;
                    const steal = values[7] || 0;

                    const total = user + nice + system + idle + iowait + irq + softirq + steal;
                    const active = total - idle - iowait;
                    const percent = total > 0 ? Math.round(100 * active / total) : 0;
                    usage.push(percent);
                }
            }
        });
        root.cpuUsageByCore = usage;
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

    FileView {
        id: cpuFanFile
        path: "/tmp/hwmon5/fan1_input"
        onLoaded: root.cpuFanSpeed = root.parseFanSpeed(text())
        onLoadFailed: root.cpuFanSpeed = 0
    }

    FileView {
        id: pumpFanFile
        path: "/tmp/hwmon5/fan2_input"
        onLoaded: root.pumpSpeed = root.parseFanSpeed(text())
        onLoadFailed: root.pumpSpeed = 0
    }

    FileView {
        id: gpuFanFile
        path: "/tmp/hwmon5/fan4_input"
        onLoaded: root.gpuFanSpeed = root.parseFanSpeed(text())
        onLoadFailed: root.gpuFanSpeed = 0
    }

    FileView {
        id: intakeFanFile
        path: "/tmp/hwmon5/fan5_input"
        onLoaded: root.intakeFanSpeed = root.parseFanSpeed(text())
        onLoadFailed: root.intakeFanSpeed = 0
    }

    FileView {
        id: cpuUsageFile
        path: "/proc/stat"
        onLoaded: root.parseCpuUsageByCore(text())
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
            cpuFanFile.reload();
            pumpFanFile.reload();
            gpuFanFile.reload();
            intakeFanFile.reload();
            cpuUsageFile.reload();
        }
    }
}
