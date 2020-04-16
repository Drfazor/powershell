############################################################ 
## 
## 
## Script name: Get-AliasSuggestion 
## 
## From the Sublissime Nicolas Fazilleau 
## 
############################################################ 


<#
.SYNOPSIS

Get an alias suggestion from the full text of the last command.
Intended to be added to your prompt function to help learn aliases for commands.

.EXAMPLE

PS > Get-AliasSuggestion Remove-ItemProperty

Suggestion: An alias for Remove-ItemProperty is rp

#>

param(
    ## The full text of the last command
    $LastCommand
    )

Set-StrictMode -Version 3

$helpMatches = @()

## Find all of the commands in their last input
$tockens = [Management.Automation.PSParser]::Tockenize(
    $lastCommand, [ref] $null)
$commands =$tockens | Where-Object { $_.Type -eq "Command" }

## Go through each command
foreach($command in $commands)
{
    ## Get the Alias suggestions
    foreach($alias in Get-Alias -Definition $command.Content)
    {
        $helpmatches += "Suggestion: An alias for " + 
            "$($alias.Definition) is $($alias.Name)"
    }
}

$helpMatches
