$certloc = "C:\Users\JoeEasley\OneDrive - Odyssey Logistics & Technology Corporation\Desktop\NC-JEASLY1\client.pfx"
$myserver = "t1prd-qlik01.odysseylogistics.com"
$archive = "Archive_Unused_5_3_21"
$folder = "C:\Users\JoeEasley\OneDrive - Odyssey Logistics & Technology Corporation\Desktop\$archive"
$username = "Joe Easley (NC)"
$domainname = "ODYSSEYLOGISTIC"
$serviceacct = "QlikServiceProd"


Get-PfxCertificate "$certloc" | Connect-Qlik -computername "$myserver" -username "$domainname\$serviceacct" -TrustAllCerts -verbose

##show list of apps to be exported
[System.Collections.ArrayList]$apps = @()
foreach($qvf in $(Get-QlikApp -filter "owner.name eq '$username' and Published eq False" -full))
{
    $s = [PSCustomObject]@{
        Name                = $qvf.name 
        Fileize_kb          = $qvf.Filesize/1000
        Reloaded            = $qvf.lastReloadTime
    }
    $apps.Add($s)
}
$apps | Format-Table

##export each app to the specified directory
foreach($qvf in $(Get-QlikApp -filter "owner.name eq '$username' and Published eq False" -full))
{
    New-Item -ItemType Directory -Force -Path "$folder\$username"
    $s = [PSCustomObject]@{
        Name                = $qvf.name 
        Fileize             = $qvf.Filesize/1000
        Reloaded            = $qvf.lastReloadTime
    }
    $s  
    Export-QlikApp -id $qvf.id -filename "$($folder)\$($username)\$($qvf.name).qvf" 
}

