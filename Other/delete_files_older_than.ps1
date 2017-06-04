# Delete all Files in C:\temp older than 90 day(s)
$Path = "C:\logging"
$Daysback = "-7"

$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)
Get-ChildItem $Path -Recurse | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item
