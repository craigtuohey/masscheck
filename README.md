# masscheck
You require a shodan api key to use this tool
Using PowerShell, run `gwmi -Class Win32_Product | Select-Object -Property Name, Version | Export-Csv -NoTypeInformation <OUTPUT.csv>`  
on target host and provide as input file to masscheck.

`ShodanSoftwareCheck.ps1 -csvfile .\locallaptop.csv -apikey '<SHODAN API KEY>' -outfile softwarechecks.txt`

The tool will look at the version number based on first 3 alphanumeric chars. If you want it to be more specific, increase this number.
