# The purpose of this script is to take a CSV file of installed packages and check against Shodan Exploit DB for vulnerable software.
# You will require a Shodan API key to perform bulk searches
# Script to take list of installed software and check against Shodan Exploit-DB for vulnerable software
# Run Following command on target system and generated CSV is used as input in this script
# With PowerShell, run gwmi -Class Win32_Product | Select-Object -Property Name, Version | Export-Csv -NoTypeInformation <OUTPUT.csv>

Param( 
        [string]$csvfile,
        [string]$apikey,
        [string]$outfile
     )

if(-not($csvfile))
    { 
        write-host -ForeGroundColor Red "Please provide the instlled packages CSV file, run following on target system and provide the output csv as argument here"
        write-host -ForeGroundColor DarkYellow "gwmi -Class Win32_Product | Select-Object -Property Name, Version | Export-Csv -NoTypeInformation <OUTPUT.csv>" 
        exit
     }
if(-not($apikey))
    { 
        write-host -ForeGroundColor Red "Please provide the Shodan API key"
        exit
    }
if(-not($outfile))
    { 
        write-host -ForeGroundColor Red "Please provide an output file"
        exit
    }




$softwareList = import-csv  $csvfile -Delimiter ','

$shodanhost = 'https://exploits.shodan.io/api/search?query='
foreach($app in $softwareList)
{
    $q = $shodanhost+$app.Name+' '+$app.Version.Substring(0,3)+'&key='+$apikey+'&platform=windows'
    Try
        {
            $r = Invoke-RestMethod -Uri $q -Method POST
            if ($r.total -gt 0)
            {
                'Product: ' + $app.Name + ' Version: ' + $app.Version | Out-file -Append $outfile 
                $r.matches | Select-Object source,_id,cve,description | Out-file -Append $outfile
                write-host -ForegroundColor Red $app.Name "may be interesting, check results"
            }
        }
    Catch
        {
        write-host -Foregroundcolor Green "Searching" $app.Name
        }
}
           