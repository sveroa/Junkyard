function FormatSQLDisk([string]$driveletter, [string]$drivelabel)
{
    Format-Volume 	`
			-DriveLetter $driveletter `
			-NewFileSystemLabel $drivelabel `
            -FileSystem NTFS `
			-AllocationUnitSize 65536 –Force -Confirm:$false
}
