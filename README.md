# psyposquatter

psyposquatter is a PowerShell script for checking similarly named, also called
typosquatted or namesquatted, PowerShell packages on PSGallery. psyposquatter makes simple
permutations, additions or omissions to generate package names and checks if
the packages is available using the standard PowerShell command `Find-Module`.

The name psyposquatter was inspired by the [pytosquatting project and awesome
research by Benjamin Bach and Hanno Böck from 2016/2017](https://pytosquatting.overtag.dk/).

For more information about typosquatting see the repository [PackAtt&ck](https://github.com/Karneades/PackAttack).

## Usage

``` powershell
PS> . ./psyposquatter.ps1
PS> Find-TypoModule -Package test -WhatIf
PS> Find-TypoModule -Package test
PS> Find-TypoModule -List packages-top-40.txt
```


## Example

``` powershell
PS> Find-TypoModule -Package AzureRM.profile
Check Package "AzureRM.profile"
   Check AureRM.profile
   Check AuzreRM.profile
   Check AzreRM.profile
   Check AzrueRM.profile
   Check AzueRM.profile
...
```
