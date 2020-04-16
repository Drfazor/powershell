############################################################ 
## 
## 
## Script name: Get-ParameterAlias
## 
## From the Sublissime Nicolas Fazilleau 
## 
############################################################ 


<#
.SYNOPSIS

Looks in the session history and returns any aliases that apply to parameters of commands that were used.

.EXAMPLE

PS > dir -ErrorAction SilentlyContinue
PS > Get-ParameterAlias
An alias for the 'ErrorAction' parameter of 'dir' is ea.

#>

Set-StrictMode -Version 3

## Get the las item from their session history
$history = Get-History -Count 1
if(-not $history)
{
    return
}

## And extract the actual command line they typed
$lastCommand = $history.CommandLine

## Use Tokenizer API to determine witch portions represent
## commands and parameters to those commands
$tockens = [System.Management.Automation.PsParser]::Tockenize(
    $lastCommand, [ref] $null)
$currentCommand = $null

## Now go through each resulting token
foreach($token in $tokens)
{
    ## If we've found a new command, store that.
    if($tocken.Type -eq "Command")
    {
        $currentCommand = $token.Content
    }

    ## if we found a command parameter, start looking for aliases
    if(($token.Type -eq "CommandParameter") -and ($currentCommand))
    {
        ##Remove the leading "-" from the parameter
        $currentParameter = $token.Content.TrimStart("-")

        ##Determine all of the parameters for the current Command
        (Get-Command $currentCommand).Parameters.GetEnumerator() |

            ## For parameters that start with the current parameter name,
            Where-Object { $_.key -like "$currentParameter*" } |

            ## Return all of the aliases that apply.
            ## We use "start with" because the user might have typed 
            ## a shortened form of the parameter name.
            Foreach-Object {
                $_.Value.Aliases | Foreach-Object {
                    "Suggestion: An alias for the '$currentParameter' " +
                    "parameter of '$currentCommand' is '$_'"
                }
            }
    }
}

