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

    // Pwm speeds (RPM)
    property int cpuPwm: 0
    property int pumpPwm: 0
    property var gpuPwm: [ 0, 0 ]

    // CPU usage by core
    property var cpuUsageByCore: []

    // Memory in GB
    property real memoryUsedGB: 0
    property real memoryTotalGB: 0

    // GPU memory (GB) - per GPU
    property var gpuNames: []
    property var gpuMemoryTotalGB: []
    property var gpuMemoryUsedGB: []

    // Total GPU memory across all GPUs
    property int totalGpuMemoryPercent: -1
    property string gpuInfo: ""

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

    function parsePwm(text) {
        const v = parseInt(text);
        return isNaN(v) ? -1 : Math.round(v * 100 / 255);
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

    function parseGpuMemory(text) {
        const lines = text.trim().split("\n");
        const names = [];
        const totalMem = [];
        const usedMem = [];

        lines.forEach((line) => {
            const parts = line.split(",");
            if (parts.length >= 3) {
                const name = parts[0].trim();
                const gpuTotalMiB = parseFloat(parts[1].trim());
                const gpuUsedMiB = parseFloat(parts[2].trim());

                if (!isNaN(gpuTotalMiB) && !isNaN(gpuUsedMiB)) {
                    names.push(name);
                    totalMem.push(gpuTotalMiB / 1024);
                    usedMem.push(gpuUsedMiB / 1024);
                }
            }
        });

        root.gpuNames = names;
        root.gpuMemoryTotalGB = totalMem;
        root.gpuMemoryUsedGB = usedMem;

        const sumTotal = totalMem.reduce((a, b) => a + b, 0);
        const sumUsed = usedMem.reduce((a, b) => a + b, 0);

        root.totalGpuMemoryPercent = sumTotal > 0 ? Math.round(100 * sumUsed / sumTotal) : 0;
    }

    function updateGpuInfo() {
        const labels = []
        for (let i = 0; i < root.gpuNames.length; i++) {
            const parts = root.gpuNames[i].split(" ")
            const name = parts[parts.length - 2] + " " + parts[parts.length - 1]
            const used = Math.round(root.gpuMemoryUsedGB[i])
            const total = Math.round(root.gpuMemoryTotalGB[i])
            labels.push(`${name}: ${used}GB / ${total}GB, Fan ${root.gpuPwm[i]}%`)
        }
        labels.push(`Total memory: ${root.totalGpuMemoryPercent}%`)
        root.gpuInfo = labels.join("\n")
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
        id: cpuPwmFile
        path: "/tmp/hwmon5/pwm1"
        onLoaded: root.cpuPwm = root.parsePwm(text())
        onLoadFailed: root.cpuPwm = -1
    }

    FileView {
        id: pumpPwmFile
        path: "/tmp/hwmon5/pwm2"
        onLoaded: root.pumpPwm = root.parsePwm(text())
        onLoadFailed: root.pumpPwm = -1
    }

    FileView {
        id: gpuPwmFile
        path: "/tmp/hwmon5/pwm4"
        onLoaded: root.gpuPwm[0] = root.parsePwm(text())
        onLoadFailed: root.gpuPwm[0] = -1
    }

    FileView {
        id: intakePwmFile
        path: "/tmp/hwmon5/pwm5"
        onLoaded: root.gpuPwm[1] = root.parsePwm(text())
        onLoadFailed: root.gpuPwm[1] = -1
    }

    FileView {
        id: cpuUsageFile
        path: "/proc/stat"
        onLoaded: root.parseCpuUsageByCore(text())
    }

    Process {
        id: gpuMemoryProcess
        command: [
            "/usr/bin/nvidia-smi",
            "--query-gpu=name,memory.total,memory.used",
            "--format=csv,noheader,nounits"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                root.parseGpuMemory(text)
                root.updateGpuInfo()
            }
        }
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
            cpuPwmFile.reload();
            pumpPwmFile.reload();
            gpuPwmFile.reload();
            intakePwmFile.reload();
            cpuUsageFile.reload();
            gpuMemoryProcess.running = true;
        }
    }
}
