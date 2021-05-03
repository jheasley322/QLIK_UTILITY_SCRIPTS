Get-PfxCertificate "C:\Users\JoeEasley\OneDrive - Odyssey Logistics & Technology Corporation\Desktop\NC-JEASLY1\client.pfx" | Connect-Qlik -computername t1prd-qlik01.odysseylogistics.COM -username odysseylogistic\QlikServiceProd -TrustAllCerts -verbose
$myserver = "t1prd-qlik01.odysseylogistics.COM"
$folder = "C:\Users\JoeEasley\OneDrive - Odyssey Logistics & Technology Corporation\Desktop\Archive_Unused_5_3_21"
$username = "Joe Easley (NC)"

Get-QlikApp -filter "owner.name eq '$username' and Published eq False"
## Get-QlikApp -filter "published eq False"
foreach($qvf in $(Get-QlikApp -filter "owner.name eq '$username' and Published eq False"))
    {
    If(!(test-path "$folder\$username")) # Create a folder if it does not exists
        {
            New-Item -ItemType Directory -Force -Path "$folder\$username"
        }
    else 
        {
            $username = ""
        }
    Export-QlikApp -id $qvf.id -filename "$($folder)\$($username)\$($qvf.name).qvf" #dumps the qvf
}
