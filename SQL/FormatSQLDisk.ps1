# ----------------------------------------------------------------------------------
# Powershell function that is used to format disks that shall be used as DATA, LOG
# TEMPDB or local BACKUP. This disk types should be formatted with 64K block size.
# This should be done due to reduction number of disk interactions SQL server need
# to perform when it needs to read/write disk to access pages.
# ----------------------------------------------------------------------------------
function FormatSQLDisk([string]$driveletter, [string]$drivelabel)
{
    Format-Volume 	`
			-DriveLetter $driveletter `
			-NewFileSystemLabel $drivelabel `
            -FileSystem NTFS `
			-AllocationUnitSize 65536 –Force -Confirm:$false
}
