function GetDiskAllocUnitSizeKB([char[]]$driveLetter = $null)
{
    $wql = "SELECT BlockSize FROM Win32_Volume WHERE FileSystem='NTFS' and DriveLetter = '" + $driveLetter + ":'"
    $BytesPerCluster = Get-WmiObject -Query $wql -ComputerName '.' | Select-Object BlockSize
    return $BytesPerCluster.BlockSize / 1024;
}


# CHEKC THE DATA DISK/DRIVE/LUN IF IT HAS 64K BLOCK SIZE
$dataSize = GetDiskAllocUnitSizeKB 'C';
if ($dataSize -eq $null -or $dataSize -ne 64)
{
    Write-Host "Data disk 'c' should have allocation unit size of 64K"
    return;
}
