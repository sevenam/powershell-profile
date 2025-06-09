Set-Alias touch ni
Set-Alias grep sls
Set-Alias § Invoke-History
Set-Alias hist Get-History
Set-Alias cat bat
Set-Alias newguid New-Guid
Set-Alias killps KillProcess
Set-Alias kill KillProcess
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
        Set-Location "D:\git"
    } elseif ($directory -eq "notes") {
        Set-Location "C:\Users\$env:USERNAME\Jottacloud\notes"
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
