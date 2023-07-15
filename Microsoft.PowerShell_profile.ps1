# C:\Users\User\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# My PowerShell profile with Kali Linux prompt and Bash like history command
# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

#Aliases - functions
function msdosCMD {
    cmd /r dir $args
    ""
}

function reset {
    Clear-Host
    [Console]::ResetColor()
    . $profile
}

# BASH like history commands
# history    : returns all PowerShell history with line numbers
# history -c : returns history only for the current shell
# `! xxxx    : where x equals line number from history command to execute
function getHistory {
    $index = 1
    # Get history only for current session
    if ( $args -match "^\d+$" ) {
        [int]$numericArgs = [convert]::ToInt32($args, 10)
        foreach( $line in (Get-Content (Get-PSReadlineOption).HistorySavePath).trim() ) {
        if ( $index -eq $numericArgs ) {
            break
        }
        $index++
    }
    Invoke-Expression $line
    }
    elseif ( $args -eq "-c" ) {
        Get-History
    }
    # Get history for all of time.
    else {
        (Get-Content (Get-PSReadlineOption).HistorySavePath).trim() | ForEach-Object { "  {0}  {1}" -f $index++, $_ }
    }
}
# ``! xxxx   : where x equals the id from current shell history
function runFromCurrentHistory {
    [int]$numericArgs = [convert]::ToInt32($args, 10) 
    Invoke-History $numericArgs
}

# My alias's.
Set-Alias dir msdosCMD -Scope Script -Option AllScope
Set-Alias history getHistory -Scope Script -Option AllScope
Set-Alias `! getHistory -Scope Script -Option AllScope
Set-Alias ``! runFromCurrentHistory -Scope Script -Option AllScope
# Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# Setup the shell prompt
figlet ByteEnable
Write-Host "                $([char]27)[1APowerShell Version - $((Get-Host).Version.ToString())"
""
# Setup color strings for the prompt
$infoclr="$([char]27)[38;5;6m"
$delimclr="$([char]27)[38;5;2m"
$promptclr="$([char]27)[38;5;6m"
$textclr="$([char]27)[38;5;7m"
function prompt {
    "${delimclr}$([char]0x250c)$([char]0x2500)$([char]0x2500)" +
    "(${infoclr}$([Environment]::UserName)$([char]27)[32m)$([char]0x2500)" +
    "[${infoclr}$((get-location).Drive.Name):${delimclr}]" +
    "$([char]0x2500)[${infoclr}$(Split-Path -Path $pwd -NoQualifier)${delimclr}]`r`n" +
    "$([char]0x2514)$([char]0x2500)${promptclr}$([char]0x276F)${textclr} "
}
