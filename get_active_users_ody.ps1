Get-PfxCertificate C:\qlik_files\cert\client.pfx | Connect-Qlik -computername t1prd-qlik01.odysseylogistics.com -username INTERNAL\sa-api -TrustAllCerts -verbose

$nodes = @('qlik01','qlik02','qlik03','qlik04','qlik05','qlik06')
$cluster = 't1prd'
## $storepath = '\\p10nas01\departments\Analytics\qlik_log\'
$storepath = '\\p10nas01.odysseylogistics.com\departments\Analytics\qlik_log\'
$timeval =  get-date -format "MMddyyyyHHmm"

[System.Collections.ArrayList]$sessions = @()
foreach ($i in $nodes) {
    foreach ($user in Invoke-QlikGet -path https://$cluster-$i.odysseylogistics.com:4747/engine/sessions | select-object -property userid,state,appid ) {
        $s = [PSCustomObject]@{
            Index              = "[$($sessions.Count+1)]" 
            ## UserId          = $user.UserId
            directory          = (($user.UserId.Split(";"))[0].Split("="))[1]
            user               = (($user.UserId.Split(";"))[1].Split("="))[1]
            state              = $user.state
            App                = $user.appid
            Server             = $i
            CallTime           = get-date -format "MM/dd/yyyy HH:mm"
        }
        $sessions.Add($s) | Out-Null
    } 
}

$updated_sessions = $sessions | Where-Object {$_.directory -notlike "*INTERNAL"}
$updated_sessions.count

if ( $updated_sessions.count -ne 0 )
{
    $updated_sessions | export-csv -path $storepath\Sessions_$timeval.csv
}

$updated_sessions | Format-Table

