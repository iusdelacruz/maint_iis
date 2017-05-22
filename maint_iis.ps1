<# 

.DESCRIPTION

This script helps sys admins to automate IIS maintenance specifically for servers with Microsoft Exchange installed.

Basically, it archives & delete IIS logs from different Exchange services.

I personally recommend to use the script together with Microsoft Task Scheduler.

.NOTES

Written by:	Julius dela Cruz

Find me on:

* Github:	https://github.com/iusdelacruz

.CHANGELOG

v1.00, 05/22/2017 - Initial version

#>


#------------------------------------------------
# MODIFY THE FOLLOWING VARIABLES (OPTIONAL)
#------------------------------------------------

$dir_bin = 'C:\iis_temp'
$bin_files = $dir_bin + "\*.*"
$chk_bin = Test-Path -path $dir_bin

$date = (Get-Date).ToString('MM-dd-yyyy hh:mm')
$iis_dir = 'C:\scripts\iis_dir.txt'
$chk_iis_dir = Test-Path -path $iis_dir

$dir_scrlogs = 'C:\Scripts\logs'
$scrlogs = $dir_sclogs+"\maint_iis.log"
$chk_scrlogs = Test-Path -path $dir_scrlogs

#------------------------------------------------
# PREREQUISITES
#  1. list of folders to maintain (iis_dir.txt)
#  2. bin folder
#  3. empty bin folder
#  4. script logs
#------------------------------------------------

if ($chk_iis_dir -eq $false) {
  
  $path1 = 'C:\Program Files\Microsoft\Exchange Server\V15\Logging\HTTPProxy\Mapi'
  $path2 = 'C:\Program Files\Microsoft\Exchange Server\V15\Logging\HTTPProxy\Ews'
  $path3 = 'C:\Program Files\Microsoft\Exchange Server\V15\Logging\HTTPProxy\PowerShell'
  $path4 = 'C:\Program Files\Microsoft\Exchange Server\V15\Logging\HTTPProxy\Eas'
  $path5 = 'C:\inetpub\logs\LogFiles\W3SVC1'
  $path6 = 'C:\inetpub\logs\LogFiles\W3SVC2'

  Echo $path1 $path2 $path3 $path4 $path5 $path6 > $iis_dir
  
  }

if ($chk_bin -eq $false) {
  
  mkdir $dir_bin
  
  }

rm $bin_files

if ($chk_scrlogs -eq $false) {
  
  mkdir $dir_scrlogs
  
  }

#------------------------------------------------
# BEGIN
#------------------------------------------------

Start-Transcript "$dir_scrlogs\maint_iis-transcript $date.log"

$dir = Get-Content $iis_dir
$dir -split '\n'

for ($i=0; $i -lt $dir.length; $i++) {

  $fname = $dir[$i] -split '\\' | select -Last 1
  
  Add-Type -Assembly System.IO.Compression.FileSystem
  [System.IO.Compression.ZipFile]::CreateFromDirectory($dir[$i], "$dir_bin\$fname.zip", [System.IO.Compression.CompressionLevel]::Optimal, $false)

  if ($? -eq $true) {
   
    $old_files = $dir[$i] + "\*.txt"
    rm $old_files
    echo "$date : Archiving $fname is successfully completed." >> $scrlogs
   
    }

  else {

    echo "$date : Failed to zip $fname." >> $scrlogs
    
    }

  }

Stop-Transcript

Exit
