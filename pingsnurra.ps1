$date = Get-Date -Format "MM-dd_HH-mm"

$result_path = "C:\\PSResult\\"

$testcomputers = 
"localhost",
"dc1",
"dc3",
"dc4",
"dc1337",
"nonexistinguser"

$secpasswd = ConvertTo-SecureString "PASSWORD" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("USERNAME", $secpasswd)

$computers = Get-ADComputer -Filter * -Credential $mycreds | Select -Expand Name

$error_computers = @()
foreach ($computer in $computers) {
    $test = Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue

    if ($test -ne $null) {
        Write-Host "OK $computer"
    } else {
        Write-Host "ERROR $computer"
        $error_computers += $computer
    }
}

$result = "`n`Unreachable Hosts ($date) `n` `n` "

foreach ($error_computer in $error_computers) {
    $result += $error_computer
    $result += "`n` " 
}


$results_file = "$result_path" + "unreachable_hosts_$date.txt"

New-Item -Force $results_file
$result | Out-File -FilePath $results_file