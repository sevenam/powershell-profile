Set-Alias touch New-Item
Set-Alias grep sls
Set-Alias newguid New-Guid
Set-Alias scaleui Set-UiScaling

function goto {
    param($directory)
    if ($directory -eq "jotta") {
        Set-Location "C:\Users\$env:USERNAME\Jottacloud"
    } elseif ($directory -eq "git") {
        Set-Location "C:\git"
    } elseif ($directory -eq "notes") {
        Set-Location "C:\Users\$env:USERNAME\Jottacloud\notes"
    } else {
        Set-Location $directory
    }k
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

    $registryMonitorPath = "HKCU:\Control Panel\Desktop\PerMonitorSettings\DELA0F45KC0303L0E5L_0C_07E4_FF^0D32DB76FF51CE434420A8249440545F"
    Set-ItemProperty -Path $registryMonitorPath -Name "DpiValue" -Value $scaling -Type DWord
    Write-Output "Scaling for monitor DELL-U3818DW set to $scaling ($percentage%)."

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
