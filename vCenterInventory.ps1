$dc = Get-Datacenter
foreach ($d in $dc) {
$dc_vm = Get-VM -Location $d.name
foreach ($vm in $dc_vm) {
Clear-Variable obj
$obj = [PSCustomObject]@{
Location = $d.name
VMName = $vm.name
vCPU = $vm.numcpu
RAMGB = $vm.memorygb
}
$obj | Export-Csv -Path $env:USERPROFILE\Downloads\vcenter_inventory.csv -NoTypeInformation -Append
}
}

$csv = Import-Csv -Path $env:USERPROFILE\Downloads\vcenter_inventory.csv
foreach ($c in $csv) {
Clear-Variable obj
[string]$filter = "name -eq `"$($c.vmname)`""
if (Get-ADComputer -Filter $filter -ErrorAction SilentlyContinue) {
$os = (Get-ADComputer -Identity $c.vmname -Properties operatingsystem).operatingsystem
} else {
$os = ""
}
$obj = [PSCustomObject]@{
Location = $c.location
VMName = $c.vmname
vCPU = $c.vcpu
RAMGB = $c.ramgb
OperatingSystem = $os
}
$obj | Export-Csv -Path $env:USERPROFILE\Downloads\vcenter_inventory_with_os.csv -NoTypeInformation -Append
}
