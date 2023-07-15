# C:\Users\User\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

#Aliases - functions

function whereis {
  Get-Command -CommandType Application -ErrorAction SilentlyContinue -Name $args[0] | Select-Object -ExpandProperty Definition
}

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
function getHistory {
    $index = 1
    # Get history for all of time and add ID/Linue number
    if ( !$args ) {
        (Get-Content (Get-PSReadlineOption).HistorySavePath).trim() | ForEach-Object { "  {0}  {1}" -f $index++, $_ }
    }
    # Parse history and invoke the specified command from history
    elseif ( $args -match "^\d+$" ) {
        [int]$numericArgs = [convert]::ToInt32($args, 10)
        foreach( $line in (Get-Content (Get-PSReadlineOption).HistorySavePath).trim() ) {
            if ( $index -eq $numericArgs ) {
                break
            }
            $index++
        }
        Invoke-Expression $line
    }
    # Get history only for current session    
    elseif ( $args -eq "-c" ) {
        Get-History
    }
    else {
        Write-Host "history : Cannot locate the history for command line $args" -ForegroundColor Red
    }
    <# 
        .SYNOPSIS
            A BASH like alias for the history command.
        .DESCRIPTION
            history : no arguments - display all command history.
            history -c : show command history for current session only.
    #>
}
function invokeCurrentHistory {
    [int]$numericArgs = [convert]::ToInt32($args, 10) 
    Invoke-History $numericArgs
    <#
        .SYNOPSIS
            A BASH like alias for invoking command history.
        .DESCRIPTION
            `! xxxx : Invoke command as specified by the ID/Line number from the command history
            ``! xxxx : Invoke command as specified by the ID/Line number from the current command history
        .EXAMPLE
            `! 123
            ``! 20
    #>
}

# My alias's.
Set-Alias dir msdosCMD -Scope Script -Option AllScope
Set-Alias history getHistory -Scope Script -Option AllScope
Set-Alias `! getHistory -Scope Script -Option AllScope
Set-Alias ``! invokeCurrentHistory -Scope Script -Option AllScope
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
