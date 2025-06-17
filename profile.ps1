Set-Alias touch New-Item
Set-Alias grep sls
Set-Alias § Invoke-History
Set-Alias hist Get-History
Set-Alias newguid New-Guid
Set-Alias scaleui Set-UiScaling
Set-Alias kill KillProcess
Set-Alias killps KillProcess
Set-Alias dotnetversion dotnetversions
Set-Alias dotnetsdks dotnetversions
# Test connection example: test-connection google.com -TcpPort 80
Set-Alias nc Test-Connection
Set-Alias test-port Test-Connection
Set-Alias codei "C:\Users\$env:USERNAME\AppData\Local\Programs\Microsoft VS Code Insiders\Code - Insiders.exe"
Set-Alias echopath Print-Path
Set-Alias echo-path Print-Path
Set-Alias path Print-Path
Set-Alias printpath Print-Path
Set-Alias listpath Print-Path
Set-Alias listenvs Print-Envs
Set-Alias printenvs Print-Envs
Set-Alias envs Print-Envs
Set-Alias echoenvs Print-Envs
Set-Alias echo-envs Print-Envs
Set-Alias fzfrg fzfgrep

Set-Alias petrel2024 "C:\BuildAgentSoftware\Petrel 2024.1 x64\Petrel.exe"
Set-Alias petrel2023 "C:\BuildAgentSoftware\Petrel 2023.1 x64\Petrel.exe"
Set-Alias petrel2022 "C:\BuildAgentSoftware\Petrel 2022.1 x64\Petrel.exe"

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression

function §§ {
    Invoke-History (Get-History -Count 1)
}

function fzfgrep {
    param (
        [string]$query
    )

    $rg_prefix = "rg --files-with-matches"
    $file = fzf --sort --preview "rg --pretty --context 5 {q} {}" --phony -q $query --bind "change:reload:$rg_prefix {q}" --preview-window="70%:wrap"

    if ($file) {
        Start-Process $file
    }
}

function fzfp {
    fzf --preview "powershell -c Get-Content -Path {}"
}

function fzfv {
    fzf --preview "powershell -c Get-Content -Path {}" --bind "enter:execute(nvim {})"
}

function fzfc {
    fzf --preview "powershell -c Get-Content -Path {}" --bind "enter:execute(code {})"
}

function Print-Envs {
    dir env:
}

function Print-Path {
    $env:path
}

function dotnetversions {
    dotnet --list-sdks
}

function watch {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    if ($Args.Count -eq 0) {
        Write-Host "Usage: watch <command> [args ...] <interval>"
        return
    }

    $lastArg = $Args[-1]
    if ($lastArg -as [int]) {
        $Interval = [int]$lastArg
        $Command = $Args[0..($Args.Count - 2)] -join ' '
    } else {
        $Interval = 2
        $Command = $Args -join ' '
    }

    $iteration = 0
    while ($true) {
        $iteration++
        $dots = "." * $iteration
        $output = Invoke-Expression $Command
        if ($output) {
            $iteration = 0
            Clear-Host
            Write-Host "Current Date and Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor DarkCyan
            Write-Output $output
        } else {
            Clear-Host
            Write-Host "Current Date and Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor DarkCyan
            Write-Output "No output from command$dots"
        }
        Start-Sleep -Seconds $Interval
    }
}

function goto {
    param($directory)
    if ($directory -eq "jotta") {
        Set-Location "C:\Users\$env:USERNAME\Jottacloud"
    } elseif ($directory -eq "git") {
        Set-Location "C:\git"
    } elseif ($directory -eq "notes") {
        Set-Location "C:\Users\$env:USERNAME\Jottacloud\notes"
    } elseif ($directory -eq "ptp") {
        Set-Location "C:\git\PythonTool\PythonTool"
    } elseif ($directory -eq "pwr") {
        Set-Location "C:\git\Scripting\RemoteScripting"
    } else {
        Set-Location $directory
    }
}

function KillProcess {
    param($processName)
    Stop-Process -Name $processName -Force
}

function New-Guid {
    [guid]::NewGuid().ToString()
}

function Set-UiScaling {
    param($percentage)
    $scaling = switch ($percentage) {
        100 { 0 }
        125 { 1 }
        150 { 2 }
        175 { 3 }
        200 { 4 }
        default { throw "Unsupported scaling percentage. Please use one of the following: 100, 125, 150, 175, 200." }
    }
    # get the monitors registry keys and list them:
    # $baseRegistryPath = "HKCU:\Control Panel\Desktop\PerMonitorSettings"
    # $subKeys = Get-ChildItem -Path $baseRegistryPath
    # Write-Host $subKeys

    $registryMonitorPath = "HKCU:\Control Panel\Desktop\PerMonitorSettings\GSM774E403NTGYEP279_03_07E8_4A^42EA6365E0D36F1D9DD7B742F0AF9200"
    Set-ItemProperty -Path $registryMonitorPath -Name "DpiValue" -Value $scaling -Type DWord
    Write-Output "Scaling for monitor LG-38WN95CP-W set to $scaling ($percentage%)."

    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class DisplaySettings {
        [DllImport("user32.dll")]
        public static extern bool EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE devMode);
        [DllImport("user32.dll")]
        public static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);

        [StructLayout(LayoutKind.Sequential)]
        public struct DEVMODE {
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
            public string dmDeviceName;
            public short dmSpecVersion;
            public short dmDriverVersion;
            public short dmSize;
            public short dmDriverExtra;
            public int dmFields;
            public int dmPositionX;
            public int dmPositionY;
            public int dmDisplayOrientation;
            public int dmDisplayFixedOutput;
            public short dmColor;
            public short dmDuplex;
            public short dmYResolution;
            public short dmTTOption;
            public short dmCollate;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
            public string dmFormName;
            public short dmLogPixels;
            public int dmBitsPerPel;
            public int dmPelsWidth;
            public int dmPelsHeight;
            public int dmDisplayFlags;
            public int dmDisplayFrequency;
            public int dmICMMethod;
            public int dmICMIntent;
            public int dmMediaType;
            public int dmDitherType;
            public int dmReserved1;
            public int dmReserved2;
            public int dmPanningWidth;
            public int dmPanningHeight;
        }

        public static void UpdateScreenSettings() {
            DEVMODE devMode = new DEVMODE();
            devMode.dmSize = (short)Marshal.SizeOf(typeof(DEVMODE));
            EnumDisplaySettings(null, -1, ref devMode);
            ChangeDisplaySettings(ref devMode, 0);
        }
    }
"@

    [DisplaySettings]::UpdateScreenSettings()
}
