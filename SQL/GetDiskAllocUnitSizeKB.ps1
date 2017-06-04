# -----------------------------------------------------------------------------------------------------------------
# This script is used during automatic installation of SQL Server. The powershell function GetDiskAllocUnitSizeKB
# will return blocksize of the disk that is passed in parameter '$driveLetter'. When you install a SQL server
# instans the data, log, backup, and tempdb should be located on LUNs formatted with 64K blocksize, and not 4K 
# that is default on Windows Server.
#
# The DOS command "fsutil fsinfo ntfsinfo C:" will return the same value in the "Bytes Per Cluster :"
#
# I use this function in my silent install
# -----------------------------------------------------------------------------------------------------------------

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
