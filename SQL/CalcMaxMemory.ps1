function CalculateSQLMaximumMemory([int]$memtotal = 0)
{
    if ($memtotal -eq 0)
    {
        $tmp = Get-WMIObject -class Win32_PhysicalMemory `
                    | Measure-Object -Property capacity -Sum 
        $memtotal = $tmp.Sum / 1MB;
    }

    if ($memtotal -lt 3072)
    {
        Write-Host "Not recommended with less than 3GB memory";
        Return $null;
    }

    $os_mem = 2048 ;
    $tot = 4096 ;
    $inc_mb = 4096 ;

    while ($tot -lt $memtotal)
    {
        $tot += $inc_mb ;
        $os_mem += 1024 ;

        if ($tot -eq 16384)
        {
            $inc_mb = 8192;
        }
    }

    $sql_mem = $memtotal - $os_mem ;
    return $sql_mem ;
}

$mem = CalculateSQLMaximumMemory ;
Write-Host "My local max memory: " $mem ;

$mem = CalculateSQLMaximumMemory 4096 ;
Write-Host "  4GB = SQL: " $mem ;

$mem = CalculateSQLMaximumMemory 6144 ;
Write-Host "  6GB = SQL: " $mem ;

