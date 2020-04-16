############################################################ 
## 
## 
## Script name:  Search-Help 
## 
## From the Sublissime Nicolas Fazilleau 
## 
############################################################ 

<#
.SYNOPSIS
Search the powershell help documentation for a given keyword or regular expression.
For simple keyword searches in Powershell version 2 or 3, simply use "Get-Help <keyword>"

.EXAMPLE
PS > Search-Help hashtable
Searches the term of hashtable

.EXAMPLE
PS > Search-Help "(datetime|ticks)"
Searches help for the term datetime or ticks, using regexp syntax.

#>

param(
    ## The pattern to search for
    [Parameter(Mandatory=$true)]
    $Pattern
    )

$helpNames = $(Get-Help * | Where-Object { $_.Category -ne "Alias" })

## Go through all of the help topics
foreach($helpTopic in $helpNames)
{
    ## get their text content, and 
    $content = Get-Help -Full $helpTopic.Name | Out-String
    if($content -match "(.{0,30}$Pattern.{0,30})")
    {
        $helpTopic | Add-Member NoteProperty Match $matches[0].Trim()
        $helpTopic | Select-Object Name,Match
    }
}
