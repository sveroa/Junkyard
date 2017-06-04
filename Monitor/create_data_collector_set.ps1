$name = "SystemWatch";
$datacollectorset = New-Object -COM Pla.DataCollectorSet
$datacollectorset.DisplayName = $name;
$datacollectorset.Duration = 50400 ;
$datacollectorset.SubdirectoryFormat = 1 ;
$datacollectorset.SubdirectoryFormatPattern = "yyyy\-MM";
$datacollectorset.RootPath = "%systemdrive%\PerfLogs\Admin\" + $name ;

$DataCollector = $datacollectorset.DataCollectors.CreateDataCollector(0) 
#$DataCollector.name = $name + " Collector";
$DataCollector.FileName = $name + "_";
$DataCollector.FileNameFormat = 0x1 ;
$DataCollector.FileNameFormatPattern = "yyyy\-MM\-dd";
$DataCollector.SampleInterval = 15
$DataCollector.LogAppend = $true;

$counters = @(
    "\PhysicalDisk\Avg. Disk Sec/Read",
    "\PhysicalDisk\Avg. Disk Sec/Write",
    "\PhysicalDisk\Avg. Disk Queue Length",
    "\Memory\Available MBytes", 
    "\Processor(_Total)\% Processor Time", 
    "\System\Processor Queue Length"
) ;

$DataCollector.PerformanceCounters = $counters

$StartDate = [DateTime]('2013-01-01 06:00:00');

$NewSchedule = $datacollectorset.schedules.CreateSchedule()
$NewSchedule.Days = 127
$NewSchedule.StartDate = $StartDate
$NewSchedule.StartTime = $StartDate

$group = [ADSI]"WinNT://./Performance Log Users,group"
$group.Add("WinNT://SYSTEM,user");

$group = [ADSI]"WinNT://./Performance Monitor Users,group"
$group.Add("WinNT://SYSTEM,user");

try
{
    $datacollectorset.schedules.Add($NewSchedule)
    $datacollectorset.DataCollectors.Add($DataCollector) 
    $datacollectorset.Commit("$name" , $null , 0x0003) | Out-Null
    $datacollectorset.start($false);
}
catch [Exception] 
{ 
    Write-Host "Exception Caught: " $_.Exception -ForegroundColor Red 
    return 
} 

