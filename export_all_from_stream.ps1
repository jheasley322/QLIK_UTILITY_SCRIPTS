Get-PfxCertificate "C:\Users\JoeEasley\OneDrive - Odyssey Logistics & Technology Corporation\Desktop\NC-JEASLY1\client.pfx" | Connect-Qlik -computername t1prd-qlik01.odysseylogistics.COM -username odysseylogistic\QlikServiceProd -TrustAllCerts -verbose
$myserver = "t1prd-qlik01.odysseylogistics.COM"
$folder = "C:\Users\JoeEasley\OneDrive - Odyssey Logistics & Technology Corporation\Desktop\Archive_Unused_5_3_21"
$streamname = "UTIL - Out of Service"

Connect-Qlik $myserver ## check https://github.com/ahaydon/Qlik-Cli for details

foreach($qvf in $(Get-QlikApp -filter "stream.name eq '$streamname'")) {
    if ($qvf.published -and $qvf.stream.name) { # Is it published?
        $streamfolder = $qvf.stream.name
        If(!(test-path "$folder\$streamfolder")) # Create a folder if it does not exists
        {
              New-Item -ItemType Directory -Force -Path "$folder\$streamfolder"
        }
    } else {
        $streamfolder = ""
    }
    Export-QlikApp -id $qvf.id -filename "$($folder)\$($streamfolder)\$($qvf.name).qvf" #dumps the qvf
}
