# eximagent installer (Windows) — pins v0.1.700.
$ErrorActionPreference = 'Stop'
if (-not [System.Environment]::Is64BitOperatingSystem) { throw 'eximagent: 64-bit Windows required' }
$dir = if ($env:EXIMAGENT_INSTALL_DIR) { $env:EXIMAGENT_INSTALL_DIR } else { Join-Path $env:USERPROFILE '.eximagent\bin' }
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$bin = Join-Path $dir 'eximagent.exe'
$tmp = "$bin.download"
$asset = 'eximagent-windows-amd64.exe'
$url = "https://github.com/EximAgent/cli/releases/download/v0.1.700/$asset"
$tag = 'v0.1.700'
Write-Host "[eximagent] downloading v0.1.700 for windows-amd64..."
try { Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing } catch {
  # only the newest release is kept, so a cached copy of this script outlives its pin
  $url = "https://github.com/EximAgent/cli/releases/latest/download/$asset"
  $tag = ''
  Write-Host "[eximagent] v0.1.700 is no longer published; falling back to the latest release"
  Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing
}
Invoke-WebRequest -Uri "$url.sha256" -OutFile "$tmp.sha256" -UseBasicParsing
$want = (Get-Content "$tmp.sha256" -Raw).Trim().ToLower()
$got = (Get-FileHash -Algorithm SHA256 $tmp).Hash.ToLower()
if ($want -ne $got) {
  Remove-Item -Force $tmp, "$tmp.sha256"
  throw 'eximagent: checksum mismatch — refusing tampered download'
}
Remove-Item -Force "$tmp.sha256"
Move-Item -Force -Path $tmp -Destination $bin
$env:EXIMAGENT_INSTALL_DIR = $dir
$env:EXIMAGENT_EXPECTED_TAG = $tag
$env:EXIMAGENT_BACKEND = 'https://cli.eximagent.ai'
& $bin install
if (Get-Command eximagent -ErrorAction SilentlyContinue) {
  Write-Host "[eximagent] ready on PATH: $((Get-Command eximagent).Source)"
} else {
  Write-Host "[eximagent] installed to $dir; open a new terminal to use eximagent (PATH was updated for new shells)"
}
