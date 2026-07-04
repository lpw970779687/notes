param(
  [string]$TargetDir = ".",
  [string]$OutputFile = "content.json"
)

$ErrorActionPreference = "Stop"

function Get-TitleFromMd {
  param([string]$Path)
  try {
    $reader = [System.IO.StreamReader]::new($Path, [System.Text.Encoding]::UTF8)
    $line = $null
    for ($i = 0; $i -lt 10 -and ($line = $reader.ReadLine()) -ne $null; $i++) {
      if ($line -match '^#\s+(.+)') {
        $reader.Close()
        return $matches[1].Trim()
      }
    }
    $reader.Close()
  } catch {}
  return $null
}

function Build-Tree {
  param(
    [string]$DirPath,
    [string]$RelativePath
  )
  $children = [System.Collections.ArrayList]::new()
  $items = Get-ChildItem -Path $DirPath | Sort-Object Name
  foreach ($item in $items) {
    if ($item.Name -eq '.git') { continue }
    if ($item.Name -eq 'node_modules') { continue }
    if ($item.Name -eq '.opencode') { continue }
    if ($item.PSIsContainer) {
      $subDirPath = Join-Path $DirPath $item.Name
      $subRelPath = if ($RelativePath) { "$RelativePath/$($item.Name)" } else { $item.Name }
      $sub = Build-Tree -DirPath $subDirPath -RelativePath $subRelPath
      if ($sub.Children.Count -gt 0) {
        [void]$children.Add($sub)
      }
    } elseif ($item.Extension -eq '.md') {
      $path = if ($RelativePath) { "$RelativePath/$($item.Name)" } else { $item.Name }
      $title = Get-TitleFromMd -Path $item.FullName
      if (-not $title) {
        $title = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
      }
      $entry = @{
        name = $item.Name
        type = "file"
        title = $title
      }
      if ($item.Name -ieq 'readme.md') {
        [void]$children.Insert(0, $entry)
      } else {
        [void]$children.Add($entry)
      }
    }
  }
  return @{
    name = Split-Path $DirPath -Leaf
    type = "directory"
    children = $children
  }
}

$resolvedDir = Resolve-Path $TargetDir
$tree = Build-Tree -DirPath $resolvedDir -RelativePath ""
$json = $tree | ConvertTo-Json -Depth 10

$outputPath = [System.IO.Path]::GetFullPath((Join-Path $resolvedDir $OutputFile))
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.Encoding]::UTF8)
Write-Host "Generated $outputPath"
