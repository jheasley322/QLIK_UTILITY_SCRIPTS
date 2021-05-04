$certloc = "C:\Users\JoeEasley\OneDrive - Odyssey Logistics & Technology Corporation\Desktop\NC-JEASLY1\client.pfx"
$myserver = "t1prd-qlik01.odysseylogistics.com"
$archive = "Archive_Unused_5_3_21"
$streamname = "CORP - IT Services"
$folder = "C:\Users\JoeEasley\OneDrive - Odyssey Logistics & Technology Corporation\Desktop\$archive"
$domainname = "ODYSSEYLOGISTIC"
$serviceacct = "QlikServiceProd"

Get-PfxCertificate "$certloc" | Connect-Qlik -computername "$myserver" -username "$domainname\$serviceacct" -TrustAllCerts -verbose
Connect-Qlik $myserver ## check https://github.com/ahaydon/Qlik-Cli for details

##show list of apps to be exported
[System.Collections.ArrayList]$apps = @()
foreach($qvf in $(Get-QlikApp -filter "stream.name eq '$streamname'" -full))
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
foreach($qvf in $(Get-QlikApp -filter "stream.name eq '$streamname'" -full)) {
    if ($qvf.published -and $qvf.stream.name) { # Is it published?
        $streamfolder = $qvf.stream.name
        If(!(test-path "$folder\$streamfolder")) # Create a folder if it does not exists
        {
              New-Item -ItemType Directory -Force -Path "$folder\$streamfolder"
        }
    } else {
        $streamfolder = ""
    }
    $s = [PSCustomObject]@{
        Name                = $qvf.name
        Fileize_kb          = $qvf.Filesize/1000
    }
    $s  
    Export-QlikApp -id $qvf.id -filename "$($folder)\$($streamfolder)\$($qvf.name).qvf" 
}
