[Cmdletbinding()]
param ( 
    [Parameter(Mandatory=$true)]
    [string]$Oldserver 
)

$VerbosePreference = "continue"

Write-Host "Fetching data from $Oldserver"
$Oldserver = Get-Vm $Oldserver

If ($Oldserver -ne $null)
{

    if ($Oldserver.State -ne "Off") {
        Write-Verbose "Server is running"
        $serveron = Read-Host "Do you want to stop the VM and Continue? Y/N"
        if ($serveron -eq "Y" -or "y"){
            Stop-VM $Oldserver
        }
        else {
            Exit 
            Write-Verbose "The reset was stopped because the old Server is running"
        }
    }   

    $memory = (Get-VMMemory -VMName $Oldserver.Name).Startup
    $switch = (Get-VMNetworkAdapter -VMName $Oldserver.Name).SwitchName
    $vhdx = Get-VMHardDiskDrive $Oldserver.Name
    New-VM -Name $Oldserver.Name.ToString() -Generation $Oldserver.Generation -MemoryStartupBytes $memory -SwitchName $switch -VHDPath $vhdx.Path

    Write-Verbose "The new Vm is now created with the same name as the old one. Please check that it is functional before removing the old one."

}
else {
    Write-Verbose "Sorry, That server cant be found"
}