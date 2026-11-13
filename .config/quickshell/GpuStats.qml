pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Replacements for waybar's cpu, memory, and temperature modules.
Singleton {
    id: root

    property real gpuTemp: -1

    // Pwm speeds (RPM)
    property int cpuPwm: 0
    property int pumpPwm: 0
    property var gpuPwm: [ 0, 0 ]

    // GPU memory (GB) - per GPU
    property var gpuNames: []
    property var gpuMemoryTotalGB: []
    property var gpuMemoryUsedGB: []

    // Total GPU memory across all GPUs
    property int totalGpuMemoryPercent: -1
    property string gpuInfo: ""

    function parseTemp(text) {
        const v = parseInt(text);
        return isNaN(v) ? -1 : v / 1000;
    }

    function parsePwm(text) {
        const v = parseInt(text);
        return isNaN(v) ? -1 : Math.round(v * 100 / 255);
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
            gpuTempFile.reload();
            cpuPwmFile.reload();
            pumpPwmFile.reload();
            gpuPwmFile.reload();
            intakePwmFile.reload();
            gpuMemoryProcess.running = true;
        }
    }
}
