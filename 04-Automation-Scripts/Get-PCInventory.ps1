# Script: Get-PCInventory.ps1
# Muc dich: Tu dong thu thap thong so phan cung PC phuc vu kiem ke tai san IT (ITAM)

$sys = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_Bios
$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$disk = Get-PhysicalDisk | Select-Object -First 1

$inventory = [PSCustomObject]@{
    Hostname        = $env:COMPUTERNAME
    Username        = $env:USERNAME
    Manufacturer    = $sys.Manufacturer
    Model           = $sys.Model
    SerialNumber    = $bios.SerialNumber
    OS_Name         = $os.Caption
    CPU             = $cpu.Name
    RAM_GB          = [math]::Round($sys.TotalPhysicalMemory / 1GB, 0)
    Disk_Model      = $disk.FriendlyName
    Disk_BusType    = $disk.BusType
    Disk_Size_GB    = [math]::Round($disk.Size / 1GB, 0)
    Disk_Health     = $disk.HealthStatus
    Audit_Date      = (Get-Date -Format "yyyy-MM-dd HH:mm")
}

$inventory | Export-Csv -Path ".\PC_Inventory_Report.csv" -NoTypeInformation -Encoding UTF8
Write-Host "Da xuat thong tin cau hinh may ra file PC_Inventory_Report.csv!" -ForegroundColor Green
