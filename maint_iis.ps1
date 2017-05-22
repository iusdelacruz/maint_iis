$date = (Get-Date).ToString('MM-dd-yyyy hh:mm')
$junk = 'D:\sample'
$junk_files = $junk + "\*.*"
$to_delete = Test-Path -Path D:\Test\to_delete

Start-Transcript "C:\Scripts\Logs\Transcript $date.log"

if ($to_delete -eq $false) {
  mkdir $junk -Verbose
  }

rm $junk_files

$dir = Get-Content D:\Test\list.txt
$dir -split '\n'

for ($i=0; $i -lt $dir.length; $i++) {.

  $filename = $dir[$i] -split '\\' | select -Last 1
  
  Add-Type -Assembly System.IO.Compression.FileSystem
  [System.IO.Compression.ZipFile]::CreateFromDirectory($dir[$i], "D:\Test\to_delete\$filename.zip", [System.IO.Compression.CompressionLevel]::Optimal, $false)

  if ($? -eq $true) {
    $logs = $dir[$i] + "\*.txt"
    rm $logs
    echo "$date : Zipped logs successfully." >> D:\Test\logs.txt
    }

  else {
    echo "$date : Failed to zip." >> D:\Test\logs.txt
    }

  }

Stop-Transcript

Exit