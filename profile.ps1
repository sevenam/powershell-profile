Set-Alias touch New-Item
Set-Alias grep sls

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
    }
}
