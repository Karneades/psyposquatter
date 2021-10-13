# psyposquatter

<!-- vim-markdown-toc GFM -->

* [Usage](#usage)
* [Example](#example)
* [Background on typosquatting package managers](#background-on-typosquatting-package-managers)
* [Related projects](#related-projects)

<!-- vim-markdown-toc -->

psyposquatter is a PowerShell script for checking similarly named, also called
typosquatted or namesquatted, PowerShell packages. psyposquatter makes simple
permutations, additions or omissions to generate package names and checks if
the packages is available using the standard PowerShell command `Find-Module`.

> The attack does not exploit a new technical vulnerability, it rather tries to
> trick people into installing packages that they not intended to run on their
> systems.

The problem arises due to the nature of community repositories used to provide
an easy way for publishing and installing packages. Such package managers are
for example PyPi for Python, rubygems.org for Ruby or npmjs.com for Node.js and
Javascript. For PowerShell the PowerShell Gallery is the default PowerShell
package manager.

The name psyposquatter was inspired by the [pytosquatting project and awesome
research by Benjamin Bach and Hanno Böck from 2016/2017](https://pytosquatting.overtag.dk/).
For people seeking for numbers: look at the section "Stdlib installations".

Despite the [well-known attack vector against programming language package
managers](http://incolumitas.com/2016/06/08/typosquatting-package-managers/) I
do not know of any analysis made to check if there are any typosquatted
packages in PSGallery. Nor is it known to me what the administrators of
PowerShell Gallery do to prevent such attacks.

This is [an awesome and in-depth blog post about that
topic](http://incolumitas.com/2016/06/08/typosquatting-package-managers/). For
people seeking for more numbers: look at the "Results" section.

After the npm typosquatting incident in 2017 [Chester Burbidge made further
research about the problem of typosquatted
packages](https://blog.scottlogic.com/2018/02/27/hunting-typosquatters-on-npm.html).
He used the levenshtein distance to search for malicious packages. And now for
the last time for people seeking yet another time for numbers: look at section
"results" once more.

Instead of searching for similarly named packages we could use an offline list
of all packages and use levenshtein to get the typosquatted name. I didn't find
an offline list.

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

## Background on typosquatting package managers

Bad stories are well-known for targeted PyPI or npm packages. Popular packages
were targeted through similarly named (typosquatted) packages which spread
backdoored version of them.

In September 2017 for example was the `urllib3` package targeted by using the
package named `urllib`.

> Protect yourself from Python typosquatting attacks with pipsec
> https://www.pytosquatting.org/  #supplychain #attack #Python

https://twitter.com/x0rz/status/910057711391399938

> SK-CSIRT identified malicious software libraries in the official Python
> package repository, PyPI, posing as well known libraries. A prominent example
> is a fake package urllib-1.21.1.tar.gz, based upon a well known package
> urllib3-1.21.1.tar.gz.

See good write up by the SK-CSIRT at http://www.nbu.gov.sk/skcsirt-sa-20170909-pypi/.

A [thorough write up after the notification of malicious packages by the PyPI
administrators is found on the mailing
list](https://mail.python.org/pipermail/security-announce/2017-September/000000.html).

[Other](https://thenewstack.io/python-package-repository-struggles-deal-typosquatting/) [articles](https://nakedsecurity.sophos.com/2017/09/19/pypi-python-repository-hit-by-typosquatting-sneak-attack/) [writing](https://arstechnica.com/information-technology/2017/09/devs-unknowingly-use-malicious-modules-put-into-official-python-repository) [about](https://www.golem.de/news/pypi-boesartige-python-pakete-entdeckt-1709-130098.html) [the](https://www.reddit.com/r/netsec/comments/4n4w2h/taking_over_17000_hosts_by_typosquatting_package/) [incident](https://www.bleepingcomputer.com/news/security/ten-malicious-libraries-found-on-pypi-python-package-index/) also exists.

Besides real attacks, [research for finding and preventing malicious actors
uploading typosquatted packages was also made](https://pytosquatting.overtag.dk/).

In August 2017 an [incident occurred regarding the npm package
cross-env](https://twitter.com/kentcdodds/status/892372685048627200). The name
`crossenv` (without the dash) was used to steal information from users. 
> it looks like this npm package is stealing env variables on install, using
> your cross-env package as bait

The same [user which uploaded the typosquatted cross-env packages also
published several other
packages](https://twitter.com/iamakulov/status/892485192883073024). [The
administrators of npmjs wrote an article about the incident](https://blog.npmjs.org/post/163723642530/crossenv-malware-on-the-npm-registry.)

> On August 1, a user notified us via Twitter that a package with a name very
> similar to the popular cross-env package was sending environment variables
> from its installation context out to npm.hacktask.net. We investigated this
> report immediately and took action to remove the package. Further
> investigation led us to remove about 40 packages in total.

Further [in-depth research was made and
published](https://blog.scottlogic.com/2018/02/27/hunting-typosquatters-on-npm.html)
and [different](https://www.theregister.co.uk/2017/08/02/typosquatting_npm/)
[articles](https://medium.com/@liran.tal/fighting-npm-typosquatting-attacks-and-naming-rules-for-npm-modules-a0b7a86344aa)
[wrote](https://thenewstack.io/npm-cleans-typosquatting-malware/)
[about](https://threatpost.com/attackers-use-typo-squatting-to-steal-npm-credentials/127235/)
the incident.

An example from 2019 - there's a typo package for dateutil in PyPI ([Github issue](https://github.com/dateutil/dateutil/issues/984))

> There is a fake version of this package called python3-dateutil on PyPI that contains additional imports of the jeIlyfish package (itself a fake version of the jellyfish package, that first L is an I). That package in turn contains malicious code starting at line 313 in jeIlyfish/_jellyfish.py

In April 2020, _The Hacker News_ published a story about [Over 700 Malicious Typosquatted Libraries Found On RubyGems Repository](https://thehackernews.com/2020/04/rubygem-typosquatting-malware.html), citation from the blog post:

> As developers increasingly embrace off-the-shelf software components 
into their apps and services, threat actors are abusing open-source 
repositories such as RubyGems to distribute malicious packages, intended
 to compromise their computers or backdoor software projects they work 
on.
>
>In the latest research shared with The Hacker News, cybersecurity experts at ReversingLabs revealed over 700 malicious gems
 — packages written in Ruby programming language — that supply chain 
attackers were caught recently distributing through the RubyGems 
repository.

In October 2021, a typo package for mitmproxy was in PyPI which includes an RCE ([Tweet](https://twitter.com/maximilianhils/status/1447525552370458625), [article on bleepingcomputer](https://www.bleepingcomputer.com/news/security/pypi-removes-mitmproxy2-over-code-execution-concerns/)).

> Copycat package could trick devs into falling for 'newer' version

## Related projects

* [https://incolumitas.com/2016/06/08/typosquatting-package-managers/](https://incolumitas.com/2016/06/08/typosquatting-package-managers/)
* [https://pytosquatting.overtag.dk/](https://pytosquatting.overtag.dk/)
* [http://www.nbu.gov.sk/skcsirt-sa-20170909-pypi/](http://www.nbu.gov.sk/skcsirt-sa-20170909-pypi/)
* [https://github.com/benjaoming/pytosquatting](https://github.com/benjaoming/pytosquatting)
* [https://blog.scottlogic.com/2018/02/27/hunting-typosquatters-on-npm.html](https://blog.scottlogic.com/2018/02/27/hunting-typosquatters-on-npm.html)
* [https://www.npmjs.com/package/check-typosquatters](https://www.npmjs.com/package/check-typosquatters)
* [https://github.com/chestercodes/RepoHunt](https://github.com/chestercodes/RepoHunt)
