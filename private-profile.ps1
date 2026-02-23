# Remove default aliases to avoid conflicts
Remove-Item Alias:cat -ErrorAction SilentlyContinue
Remove-Item Alias:cd -ErrorAction SilentlyContinue
Remove-Item Alias:kill -ErrorAction SilentlyContinue

Set-Alias touch ni
Set-Alias grep sls
Set-Alias § Invoke-History
Set-Alias hist Get-History
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
Set-Alias edit editprofile
Set-Alias lg lazygit
Set-Alias gittree Git-Tree
Set-Alias gitlog Git-Tree

# ensure user and machine path are combined correctly
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine")

# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression
starship init powershell | Invoke-Expression
zoxide init powershell | Out-String | Invoke-Expression

function ff($pattern) {
    # Get-ChildItem -Recurse -Filter "*$pattern*"
    gci -r -filter "*$pattern*"
}

function katt {
    bat -p @args
}

function cd {
    try {
        z @args
    } catch {
        Set-Location @args
    }
}

function editprofile {
    code $PROFILE.CurrentUserAllHosts
}

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
    $env:Path -split ';'
}

function dotnetversions {
    dotnet --list-sdks
}

function Git-Tree {
    git log --graph --all --color=always --decorate --pretty=medium
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
    param($processNameOrId)
    if ($processNameOrId -match '^\d+$') {
        Stop-Process -Id $processNameOrId -Force
    } else {
        Stop-Process -Name $processNameOrId -Force
    }
}

function New-Guid {
    [guid]::NewGuid().ToString()
}
