# LilyMod Meow Analyzer - Enhanced Edition
# Original Author: Tonynoh
# Enhanced by: Lily<3 with love - credits to Zedoon

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

# ASCII Art Banner migliorato con stile LilyMod
$Banner = @"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║     ███╗   ███╗███████╗ ██████╗ ██╗    ██╗  ███╗   ███╗ ██████╗ ██████╗     ║
║     ████╗ ████║██╔════╝██╔═══██╗██║    ██║  ████╗ ████║██╔═══██╗██╔══██╗    ║
║     ██╔████╔██║█████╗  ██║   ██║██║ █╗ ██║  ██╔████╔██║██║   ██║██║  ██║    ║
║     ██║╚██╔╝██║██╔══╝  ██║   ██║██║███╗██║  ██║╚██╔╝██║██║   ██║██║  ██║    ║
║     ██║ ╚═╝ ██║███████╗╚██████╔╝╚███╔███╔╝  ██║ ╚═╝ ██║╚██████╔╝██████╔╝    ║
║     ╚═╝     ╚═╝╚══════╝ ╚═════╝  ╚══╝╚══╝   ╚═╝     ╚═╝ ╚═════╝ ╚═════╝     ║
║                                                                               ║
║        █████╗ ███╗   ██╗ █████╗ ██╗   ██╗   ██╗███████╗███████╗██████╗      ║
║       ██╔══██╗████╗  ██║██╔══██╗██║   ╚██╗ ██╔╝╚══███╔╝██╔════╝██╔══██╗     ║
║       ███████║██╔██╗ ██║███████║██║    ╚████╔╝   ███╔╝ █████╗  ██████╔╝     ║
║       ██╔══██║██║╚██╗██║██╔══██║██║     ╚██╔╝   ███╔╝  ██╔══╝  ██╔══██╗     ║
║       ██║  ██║██║ ╚████║██║  ██║███████╗ ██║   ███████╗███████╗██║  ██║     ║
║       ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝ ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝     ║
║                                                                               ║
║                          ╱\    ╱                                             ║
║                         ╱  )  ( ')                                           ║
║                        (  /  )                                               ║
║                         \(__)|                                               ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
"@

Write-Host $Banner -ForegroundColor Cyan
Write-Host ""
Write-Host "                    ╭──────────────────────────────────╮" -ForegroundColor Magenta
Write-Host "                    │  " -NoNewline -ForegroundColor Magenta; Write-Host "Made with " -NoNewline -ForegroundColor White; Write-Host "♥" -NoNewline -ForegroundColor Red; Write-Host " by " -NoNewline -ForegroundColor White; Write-Host "LilyMod ❤️ Tonynoh" -NoNewline -ForegroundColor Cyan; Write-Host "  │" -ForegroundColor Magenta
Write-Host "                    ╰──────────────────────────────────╯" -ForegroundColor Magenta
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkCyan
Write-Host ""

# Funzione per il percorso del mods folder con stile migliorato
Write-Host "📂 " -NoNewline -ForegroundColor Yellow
Write-Host "ENTER MODS FOLDER PATH" -ForegroundColor White
Write-Host "   " -NoNewline; Write-Host "(press Enter to use default)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "   ╭─ " -NoNewline -ForegroundColor Cyan
$modsPath = Read-Host "PATH" 
Write-Host "   ╰────────────────" -ForegroundColor Cyan
Write-Host ""

if ([string]::IsNullOrWhiteSpace($modsPath)) {
    $modsPath = "$env:USERPROFILE\AppData\Roaming\.minecraft\mods"
    Write-Host "   ⚡ " -NoNewline -ForegroundColor Yellow
    Write-Host "Using default: " -NoNewline -ForegroundColor White
    Write-Host $modsPath -ForegroundColor Green
    Write-Host ""
}

if (-not (Test-Path $modsPath -PathType Container)) {
    Write-Host ""
    Write-Host "   ╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "   ║                      " -NoNewline -ForegroundColor Red; Write-Host "❌ ERROR" -NoNewline -ForegroundColor White -BackgroundColor Red; Write-Host "                          ║" -ForegroundColor Red
    Write-Host "   ║                                                              ║" -ForegroundColor Red
    Write-Host "   ║  Invalid Path! The directory does not exist                  ║" -ForegroundColor Red
    Write-Host "   ║  or is not accessible.                                       ║" -ForegroundColor Red
    Write-Host "   ║                                                              ║" -ForegroundColor Red
    Write-Host "   ║  Tried to access: " -NoNewline -ForegroundColor Red; Write-Host "$modsPath".PadRight(35) -ForegroundColor Yellow -NoNewline; Write-Host "║" -ForegroundColor Red
    Write-Host "   ║                                                              ║" -ForegroundColor Red
    Write-Host "   ╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host "   📁 " -NoNewline -ForegroundColor Green
Write-Host "Scanning directory: " -NoNewline -ForegroundColor White
Write-Host $modsPath -ForegroundColor Cyan
Write-Host ""

# check if minecraft is already running
$mcProcess = Get-Process javaw -ErrorAction SilentlyContinue
if (-not $mcProcess) {
    $mcProcess = Get-Process java -ErrorAction SilentlyContinue
}

if ($mcProcess) {
    try {
        $startTime = $mcProcess.StartTime
        $uptime = (Get-Date) - $startTime
        Write-Host "   ⏰ " -NoNewline -ForegroundColor DarkCyan
        Write-Host "MINECRAFT UPTIME" -ForegroundColor DarkCyan
        Write-Host "   ╭──────────────────────────────────────────────╮" -ForegroundColor DarkCyan
        Write-Host "   │  PID: " -NoNewline -ForegroundColor DarkCyan; Write-Host "$($mcProcess.Id)".PadRight(41) -ForegroundColor White -NoNewline; Write-Host "│" -ForegroundColor DarkCyan
        Write-Host "   │  Started: " -NoNewline -ForegroundColor DarkCyan; Write-Host "$startTime".PadRight(38) -ForegroundColor White -NoNewline; Write-Host "│" -ForegroundColor DarkCyan
        Write-Host "   │  Running: " -NoNewline -ForegroundColor DarkCyan; Write-Host "$($uptime.Hours)h $($uptime.Minutes)m $($uptime.Seconds)s".PadRight(38) -ForegroundColor White -NoNewline; Write-Host "│" -ForegroundColor DarkCyan
        Write-Host "   ╰──────────────────────────────────────────────╯" -ForegroundColor DarkCyan
        Write-Host ""
    } catch {
        # couldn't grab process info, no biggie
    }
}

function Get-FileSHA1 {
    param([string]$Path)
    return (Get-FileHash -Path $Path -Algorithm SHA1).Hash
}

function Get-DownloadSource {
    param([string]$Path)
    $zoneData = Get-Content -Raw -Stream Zone.Identifier $Path -ErrorAction SilentlyContinue
    if ($zoneData -match "HostUrl=(.+)") {
        $url = $matches[1].Trim()
        if ($url -match "mediafire\.com")                                        { return "MediaFire" }
        elseif ($url -match "discord\.com|discordapp\.com|cdn\.discordapp\.com") { return "Discord" }
        elseif ($url -match "dropbox\.com")                                      { return "Dropbox" }
        elseif ($url -match "drive\.google\.com")                                { return "Google Drive" }
        elseif ($url -match "mega\.nz|mega\.co\.nz")                             { return "MEGA" }
        elseif ($url -match "github\.com")                                       { return "GitHub" }
        elseif ($url -match "modrinth\.com")                                     { return "Modrinth" }
        elseif ($url -match "curseforge\.com")                                   { return "CurseForge" }
        elseif ($url -match "anydesk\.com")                                      { return "AnyDesk" }
        elseif ($url -match "doomsdayclient\.com")                               { return "DoomsdayClient" }
        elseif ($url -match "prestigeclient\.vip")                               { return "PrestigeClient" }
        elseif ($url -match "198macros\.com")                                    { return "198Macros" }
        else {
            if ($url -match "https?://(?:www\.)?([^/]+)") { return $matches[1] }
            return $url
        }
    }
    return $null
}

function Query-Modrinth {
    param([string]$Hash)
    try {
        $versionInfo = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$Hash" -Method Get -UseBasicParsing -ErrorAction Stop
        if ($versionInfo.project_id) {
            $projectInfo = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($versionInfo.project_id)" -Method Get -UseBasicParsing -ErrorAction Stop
            return @{ Name = $projectInfo.title; Slug = $projectInfo.slug }
        }
    } catch { }
    return @{ Name = ""; Slug = "" }
}

function Query-Megabase {
    param([string]$Hash)
    try {
        $result = Invoke-RestMethod -Uri "https://megabase.vercel.app/api/query?hash=$Hash" -Method Get -UseBasicParsing -ErrorAction Stop
        if (-not $result.error) { return $result.data }
    } catch { }
    return $null
}

# --- detection lists ---
$suspiciousPatterns = @(
    "AimAssist", "AnchorTweaks", "AutoAnchor", "AutoCrystal", "AutoDoubleHand",
    "AutoHitCrystal", "AutoPot", "AutoTotem", "AutoArmor", "InventoryTotem",
    "Hitboxes", "JumpReset", "LegitTotem", "PingSpoof", "SelfDestruct",
    "ShieldBreaker", "TriggerBot", "Velocity", "AxeSpam", "WebMacro",
    "FastPlace", "WalskyOptimizer", "WalksyOptimizer", "walsky.optimizer",
    "WalksyCrystalOptimizerMod", "Donut", "Replace Mod", "Reach",
    "ShieldDisabler", "SilentAim", "Totem Hit", "Wtap", "FakeLag",
    "BlockESP", "dev.krypton", "Virgin", "AntiMissClick",
    "LagReach", "PopSwitch", "SprintReset", "ChestSteal", "AntiBot",
    "ElytraSwap", "FastXP", "FastExp", "Refill", "NoJumpDelay", "AirAnchor",
    "jnativehook", "FakeInv", "HoverTotem", "AutoClicker", "AutoFirework",
    "PackSpoof", "Antiknockback", "scrim", "catlean", "Argon",
    "AuthBypass", "Asteria", "Prestige", "AutoEat", "AutoMine",
    "MaceSwap", "DoubleAnchor", "AutoTPA", "BaseFinder", "Xenon", "gypsy",
    "Grim", "grim",
    "org.chainlibs.module.impl.modules.Crystal.Y",
    "org.chainlibs.module.impl.modules.Crystal.bF",
    "org.chainlibs.module.impl.modules.Crystal.bM",
    "org.chainlibs.module.impl.modules.Crystal.bY",
    "org.chainlibs.module.impl.modules.Crystal.bq",
    "org.chainlibs.module.impl.modules.Crystal.cv",
    "org.chainlibs.module.impl.modules.Crystal.o",
    "org.chainlibs.module.impl.modules.Blatant.I",
    "org.chainlibs.module.impl.modules.Blatant.bR",
    "org.chainlibs.module.impl.modules.Blatant.bx",
    "org.chainlibs.module.impl.modules.Blatant.cj",
    "org.chainlibs.module.impl.modules.Blatant.dk",
    "imgui", "imgui.gl3", "imgui.glfw",
    "BowAim", "Criticals", "Flight", "Fakenick", "FakeItem",
    "invsee", "ItemExploit", "Hellion", "hellion",
    "LicenseCheckMixin", "ClientPlayerInteractionManagerAccessor",
    "ClientPlayerEntityMixim", "dev.gambleclient", "obfuscatedAuth",
    "phantom-refmap.json", "xyz.greaj",
    "じ.class", "ふ.class", "ぶ.class", "ぷ.class", "た.class",
    "ね.class", "そ.class", "な.class", "ど.class", "ぐ.class",
    "ず.class", "で.class", "つ.class", "べ.class", "せ.class",
    "と.class", "み.class", "び.class", "す.class", "の.class"
)

$cheatStrings = @(
    "AutoCrystal", "autocrystal", "auto crystal", "cw crystal",
    "dontPlaceCrystal", "dontBreakCrystal",
    "AutoHitCrystal", "autohitcrystal", "canPlaceCrystalServer", "healPotSlot",
    "AutoAnchor", "autoanchor", "auto anchor", "DoubleAnchor",
    "hasGlowstone", "HasAnchor", "anchortweaks", "anchor macro", "safe anchor", "safeanchor",
    "AutoTotem", "autototem", "auto totem", "InventoryTotem",
    "inventorytotem", "HoverTotem", "hover totem", "legittotem",
    "AutoPot", "autopot", "auto pot", "speedPotSlot", "strengthPotSlot",
    "AutoArmor", "autoarmor", "auto armor",
    "preventSwordBlockBreaking", "preventSwordBlockAttack",
    "AutoDoubleHand", "autodoublehand", "auto double hand",
    "AutoClicker",
    "Failed to switch to mace after axe!",
    "Breaking shield with axe...",
    "Donut", "JumpReset", "axespam", "axe spam",
    "shieldbreaker", "shield breaker", "EndCrystalItemMixin",
    "findKnockbackSword", "attackRegisteredThisClick",
    "AimAssist", "aimassist", "aim assist",
    "triggerbot", "trigger bot",
    "FakeInv", "Friends", "swapBackToOriginalSlot",
    "FakeLag", "pingspoof", "ping spoof", "velocity",
    "webmacro", "web macro",
    "lvstrng", "dqrkis", "selfdestruct", "self destruct",
    "AutoMace", "AutoFirework", "MaceSwap", "AirAnchor",
    "ElytraSwap", "FastXP", "FastExp", "NoJumpDelay",
    "PackSpoof", "Antiknockback", "scrim", "catlean",
    "AuthBypass", "obfuscatedAuth", "LicenseCheckMixin",
    "BaseFinder", "invsee", "ItemExploit",
    "NoFall", "nofall",
    "WalksyCrystalOptimizerMod", "WalksyOptimizer", "WalskyOptimizer"
)

# BYPASS / INJECTION DETECTION
function Invoke-BypassScan {
    param([string]$FilePath)

    $flags = [System.Collections.Generic.List[string]]::new()

    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $mavenPrefixes = @(
        "com_","org_","net_","io_","dev_","gs_","xyz_",
        "app_","me_","tv_","uk_","be_","fr_","de_"
    )

    function Test-SuspiciousJarName {
        param([string]$JarName)
        $base = [System.IO.Path]::GetFileNameWithoutExtension($JarName)
        if ($base -match '\d')                                          { return $false }
        foreach ($pfx in $mavenPrefixes) {
            if ($base.ToLower().StartsWith($pfx))                       { return $false }
        }
        if ($base.Length -gt 20)                                        { return $false }
        return $true
    }

    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($FilePath)

        $nestedJars   = @($zip.Entries | Where-Object { $_.FullName -match "^META-INF/jars/.+\.jar$" })
        $outerClasses = @($zip.Entries | Where-Object { $_.FullName -match "\.class$" })

        $suspiciousNestedJars = @()
        foreach ($nj in $nestedJars) {
            $njBase = [System.IO.Path]::GetFileName($nj.FullName)
            if (Test-SuspiciousJarName -JarName $njBase) {
                $suspiciousNestedJars += $njBase
            }
        }
        foreach ($sj in $suspiciousNestedJars) {
            $flags.Add("Suspicious nested JAR — no version number, not a known dependency: $sj")
        }

        if ($nestedJars.Count -eq 1 -and $outerClasses.Count -lt 3) {
            $njName = [System.IO.Path]::GetFileName(($nestedJars | Select-Object -First 1).FullName)
            $flags.Add("Hollow shell — outer JAR has only $($outerClasses.Count) own class(es) but wraps: $njName")
        }

        $outerModId = ""
        $fmje = $zip.Entries | Where-Object { $_.FullName -eq "fabric.mod.json" } | Select-Object -First 1
        if ($fmje) {
            try {
                $s = $fmje.Open()
                $r = New-Object System.IO.StreamReader($s)
                $t = $r.ReadToEnd(); $r.Close(); $s.Close()
                if ($t -match '"id"\s*:\s*"([^"]+)"') { $outerModId = $matches[1] }
            } catch { }
        }

        $allEntries = [System.Collections.Generic.List[object]]::new()
        foreach ($e in $zip.Entries) { $allEntries.Add($e) }

        $innerZips = [System.Collections.Generic.List[object]]::new()
        foreach ($nj in $nestedJars) {
            try {
                $ns = $nj.Open()
                $ms = New-Object System.IO.MemoryStream
                $ns.CopyTo($ms); $ns.Close()
                $ms.Position = 0
                $iz = [System.IO.Compression.ZipArchive]::new($ms, [System.IO.Compression.ZipArchiveMode]::Read)
                $innerZips.Add($iz)
                foreach ($ie in $iz.Entries) { $allEntries.Add($ie) }
            } catch { }
        }

        $runtimeExecFound  = $false
        $httpDownloadFound = $false
        $httpExfilFound    = $false
        $obfuscatedCount   = 0
        $totalClassCount   = 0

        foreach ($entry in $allEntries) {
            $name = $entry.FullName

            if ($name -match "\.class$") {
                $totalClassCount++
                $segs = ($name -replace "\.class$","") -split "/"
                if ($segs.Count -ge 3 -and ($segs | Where-Object { $_.Length -gt 2 }).Count -eq 0) {
                    $obfuscatedCount++
                }

                try {
                    $st = $entry.Open()
                    $rd = New-Object System.IO.StreamReader($st, [System.Text.Encoding]::Latin1)
                    $ct = $rd.ReadToEnd(); $rd.Close(); $st.Close()

                    if ($ct -match "java/lang/Runtime" -and
                        $ct -match "getRuntime" -and
                        $ct -match "\bexec\b") {
                        $runtimeExecFound = $true
                    }

                    if ($ct -match "openConnection" -and
                        $ct -match "HttpURLConnection" -and
                        $ct -match "FileOutputStream") {
                        $httpDownloadFound = $true
                    }

                    if ($ct -match "openConnection" -and
                        $ct -match "setDoOutput" -and
                        $ct -match "getOutputStream") {
                        $httpExfilFound = $true
                    }
                } catch { }
            }
        }

        foreach ($iz in $innerZips) { try { $iz.Dispose() } catch { } }
        $zip.Dispose()

        if ($runtimeExecFound) {
            $flags.Add("Runtime.exec() — mod can execute arbitrary OS commands on your machine")
        }

        if ($httpDownloadFound) {
            $flags.Add("HTTP file download — mod fetches and writes files from a remote server")
        }

        if ($httpExfilFound) {
            $flags.Add("HTTP POST exfiltration — mod sends data to an external server (possible token/session theft)")
        }

        if ($totalClassCount -ge 10 -and $obfuscatedCount -gt 0) {
            $pct = [math]::Round(($obfuscatedCount / $totalClassCount) * 100)
            if ($pct -ge 60) {
                $flags.Add("Heavy obfuscation — $pct% of classes have single-letter names (a/b/c style). Legitimate mods don't do this.")
            }
        }

        $knownLegitModIds = @(
            "vmp-fabric","vmp","lithium","sodium","iris","fabric-api",
            "modmenu","ferrite-core","lazydfu","starlight","entityculling",
            "memoryleakfix","krypton","c2me-fabric","smoothboot-fabric",
            "immediatelyfast","noisium","threadtweak"
        )
        $dangerCount = ($flags | Where-Object {
            $_ -match "Runtime\.exec|HTTP file download|HTTP POST|Heavy obfuscation|Suspicious nested JAR"
        }).Count
        if ($outerModId -and ($knownLegitModIds -contains $outerModId) -and $dangerCount -gt 0) {
            $flags.Add("Fake mod identity — outer JAR claims to be '$outerModId' but hash is not on Modrinth and dangerous code was found inside")
        }

    } catch { }

    return $flags
}

function Invoke-ModScan {
    param([string]$FilePath)

    $foundPatterns = [System.Collections.Generic.HashSet[string]]::new()
    $foundStrings  = [System.Collections.Generic.HashSet[string]]::new()

    Add-Type -AssemblyName System.IO.Compression.FileSystem

    try {
        $patternRegex = [regex]::new(
            '(?<![A-Za-z])(' + ($suspiciousPatterns -join '|') + ')(?![A-Za-z])',
            [System.Text.RegularExpressions.RegexOptions]::Compiled
        )
        $archive = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        foreach ($entry in $archive.Entries) {
            foreach ($m in $patternRegex.Matches($entry.FullName)) { [void]$foundPatterns.Add($m.Value) }
            if ($entry.FullName -match '\.(class|json)$' -or $entry.FullName -match 'MANIFEST\.MF') {
                try {
                    $stream  = $entry.Open()
                    $reader  = New-Object System.IO.StreamReader($stream)
                    $content = $reader.ReadToEnd()
                    $reader.Close(); $stream.Close()
                    foreach ($m in $patternRegex.Matches($content)) { [void]$foundPatterns.Add($m.Value) }
                } catch { }
            }
        }
        $archive.Dispose()
    } catch { }

    try {
        $stringsExe = @(
            "C:\Program Files\Git\usr\bin\strings.exe",
            "C:\Program Files\Git\mingw64\bin\strings.exe",
            "$env:ProgramFiles\Git\usr\bin\strings.exe",
            "C:\msys64\usr\bin\strings.exe",
            "C:\cygwin64\bin\strings.exe"
        ) | Where-Object { Test-Path $_ } | Select-Object -First 1

        if ($stringsExe) {
            $tmp = Join-Path $env:TEMP "meow_str_$(Get-Random).txt"
            & $stringsExe $FilePath 2>$null | Out-File $tmp -Encoding UTF8
            if (Test-Path $tmp) {
                $raw = Get-Content $tmp -Raw
                Remove-Item $tmp -Force -ErrorAction SilentlyContinue
                foreach ($s in $cheatStrings) {
                    if ($s -eq "velocity") {
                        if ($raw -match "velocity(?:hack|module|cheat|bypass|packet|horizontal|vertical|amount|factor|setting)") {
                            [void]$foundStrings.Add($s)
                        }
                    } elseif ($raw -match [regex]::Escape($s)) {
                        [void]$foundStrings.Add($s)
                    }
                }
            }
        } else {
            $rawText = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($FilePath))
            foreach ($s in $cheatStrings) {
                if ($s -eq "velocity") {
                    if ($rawText -match "velocity(?:hack|module|cheat|bypass|packet|horizontal|vertical|amount|factor|setting)") {
                        [void]$foundStrings.Add($s)
                    }
                } elseif ($rawText -match [regex]::Escape($s)) {
                    [void]$foundStrings.Add($s)
                }
            }
            try {
                $zip = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
                foreach ($entry in ($zip.Entries | Where-Object { $_.Name -like "*.class" })) {
                    try {
                        $stream    = $entry.Open()
                        $reader    = New-Object System.IO.StreamReader($stream)
                        $classText = $reader.ReadToEnd()
                        $reader.Close(); $stream.Close()
                        foreach ($s in $cheatStrings) {
                            if ($s -eq "velocity") {
                                if ($classText -match "velocity(?:hack|module|cheat|bypass|packet|horizontal|vertical|amount|factor|setting)") {
                                    [void]$foundStrings.Add($s)
                                }
                            } elseif ($classText -match [regex]::Escape($s)) {
                                [void]$foundStrings.Add($s)
                            }
                        }
                    } catch { }
                }
                $zip.Dispose()
            } catch { }
        }
    } catch { }

    return @{ Patterns = $foundPatterns; Strings = $foundStrings }
}

$verifiedMods   = @()
$unknownMods    = @()
$suspiciousMods = @()
$bypassMods     = @()

try {
    $jarFiles = Get-ChildItem -Path $modsPath -Filter *.jar -ErrorAction Stop
} catch {
    Write-Host "   ❌ Error accessing directory: $_" -ForegroundColor Red
    Write-Host "   Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

if ($jarFiles.Count -eq 0) {
    Write-Host "   ⚠️  No JAR files found in: $modsPath" -ForegroundColor Yellow
    Write-Host "   Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 0
}

$fileWord = if ($jarFiles.Count -eq 1) { "file" } else { "files" }
Write-Host "   🔍 Found " -NoNewline -ForegroundColor Green
Write-Host "$($jarFiles.Count) " -NoNewline -ForegroundColor White
Write-Host "JAR $fileWord to analyze" -ForegroundColor Green
Write-Host ""

$spinnerFrames = @("⣾","⣽","⣻","⢿","⡿","⣟","⣯","⣷")
$totalFiles    = $jarFiles.Count
$idx           = 0

Write-Host "   ╭─────────────────────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "   │                    PHASE 1: VERIFICATION                     │" -ForegroundColor Cyan
Write-Host "   ╰─────────────────────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""

foreach ($jar in $jarFiles) {
    $idx++
    $spinner = $spinnerFrames[$idx % $spinnerFrames.Length]
    Write-Host "   [$spinner] Verifying: $idx/$totalFiles - $($jar.Name)" -ForegroundColor Yellow -NoNewline
    Write-Host "`r" -NoNewline

    $hash = Get-FileSHA1 -Path $jar.FullName

    if ($hash) {
        $modrinthData = Query-Modrinth -Hash $hash
        if ($modrinthData.Slug) {
            $verifiedMods += [PSCustomObject]@{ ModName = $modrinthData.Name; FileName = $jar.Name; FilePath = $jar.FullName }
            Write-Host "   [$spinner] Verifying: $idx/$totalFiles - $($jar.Name) " -NoNewline
            Write-Host "✓ VERIFIED" -ForegroundColor Green
            continue
        }
        $megabaseData = Query-Megabase -Hash $hash
        if ($megabaseData.name) {
            $verifiedMods += [PSCustomObject]@{ ModName = $megabaseData.Name; FileName = $jar.Name; FilePath = $jar.FullName }
            Write-Host "   [$spinner] Verifying: $idx/$totalFiles - $($jar.Name) " -NoNewline
            Write-Host "✓ VERIFIED" -ForegroundColor Green
            continue
        }
    }

    $src = Get-DownloadSource $jar.FullName
    $unknownMods += [PSCustomObject]@{ FileName = $jar.Name; FilePath = $jar.FullName; DownloadSource = $src }
    Write-Host "   [$spinner] Verifying: $idx/$totalFiles - $($jar.Name) " -NoNewline
    Write-Host "? UNKNOWN" -ForegroundColor Yellow
}

Write-Host "`r$(' ' * 100)`r" -NoNewline
Write-Host ""

# pass 2 - deep scan
$modWord = if ($totalFiles -eq 1) { "mod" } else { "mods" }
Write-Host "   ╭─────────────────────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "   │                    PHASE 2: DEEP SCAN                        │" -ForegroundColor Cyan
Write-Host "   ╰─────────────────────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""
$idx = 0

foreach ($jar in $jarFiles) {
    $idx++
    $spinner = $spinnerFrames[$idx % $spinnerFrames.Length]
    Write-Host "   [$spinner] Scanning: $idx/$totalFiles - $($jar.Name)" -ForegroundColor Yellow -NoNewline
    Write-Host "`r" -NoNewline

    $result = Invoke-ModScan -FilePath $jar.FullName

    if ($result.Patterns.Count -gt 0 -or $result.Strings.Count -gt 0) {
        $suspiciousMods += [PSCustomObject]@{
            FileName = $jar.Name
            Patterns = $result.Patterns
            Strings  = $result.Strings
        }
        $verifiedMods = $verifiedMods | Where-Object { $_.FileName -ne $jar.Name }
        Write-Host "   [$spinner] Scanning: $idx/$totalFiles - $($jar.Name) " -NoNewline
        Write-Host "⚠️  SUSPICIOUS" -ForegroundColor Red
    } else {
        Write-Host "   [$spinner] Scanning: $idx/$totalFiles - $($jar.Name) " -NoNewline
        Write-Host "✓ CLEAN" -ForegroundColor Green
    }
}

Write-Host "`r$(' ' * 100)`r" -NoNewline
Write-Host ""

# pass 3 - bypass scan
Write-Host "   ╭─────────────────────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "   │                    PHASE 3: BYPASS SCAN                      │" -ForegroundColor Cyan
Write-Host "   ╰─────────────────────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""
$idx = 0

foreach ($jar in $jarFiles) {
    $idx++
    $spinner = $spinnerFrames[$idx % $spinnerFrames.Length]
    Write-Host "   [$spinner] Bypass scan: $idx/$totalFiles - $($jar.Name)" -ForegroundColor Yellow -NoNewline
    Write-Host "`r" -NoNewline

    $bypassFlags = Invoke-BypassScan -FilePath $jar.FullName

    if ($bypassFlags.Count -gt 0) {
        $bypassMods += [PSCustomObject]@{
            FileName = $jar.Name
            Flags    = $bypassFlags
        }
        $verifiedMods = $verifiedMods | Where-Object { $_.FileName -ne $jar.Name }
        Write-Host "   [$spinner] Bypass scan: $idx/$totalFiles - $($jar.Name) " -NoNewline
        Write-Host "☠️  INJECTION" -ForegroundColor Magenta
    } else {
        Write-Host "   [$spinner] Bypass scan: $idx/$totalFiles - $($jar.Name) " -NoNewline
        Write-Host "✓ SAFE" -ForegroundColor Green
    }
}

Write-Host "`r$(' ' * 100)`r" -NoNewline
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkCyan

# RESULTS SECTION - Enhanced visual style
Write-Host ""
Write-Host "   ╔══════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "   ║                            ANALYSIS RESULTS                               ║" -ForegroundColor Cyan
Write-Host "   ╚══════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($verifiedMods.Count -gt 0) {
    Write-Host "   ╭────────────────────────────────────────────────────────────────────╮" -ForegroundColor Green
    Write-Host "   │                          ✅ VERIFIED MODS                           │" -ForegroundColor Green
    Write-Host "   │                           ($($verifiedMods.Count) found)                             │" -ForegroundColor Green
    Write-Host "   ╰────────────────────────────────────────────────────────────────────╯" -ForegroundColor Green
    Write-Host ""
    foreach ($mod in $verifiedMods) {
        Write-Host "     ✓ " -NoNewline -ForegroundColor Green
        Write-Host "$($mod.ModName)" -ForegroundColor White
        Write-Host "        └─ " -NoNewline -ForegroundColor DarkGray
        Write-Host "$($mod.FileName)" -ForegroundColor DarkGray
        Write-Host ""
    }
}

if ($unknownMods.Count -gt 0) {
    Write-Host "   ╭────────────────────────────────────────────────────────────────────╮" -ForegroundColor Yellow
    Write-Host "   │                          ❓ UNKNOWN MODS                            │" -ForegroundColor Yellow
    Write-Host "   │                           ($($unknownMods.Count) found)                             │" -ForegroundColor Yellow
    Write-Host "   ╰────────────────────────────────────────────────────────────────────╯" -ForegroundColor Yellow
    Write-Host ""
    foreach ($mod in $unknownMods) {
        $name = $mod.FileName
        if ($name.Length -gt 50) { $name = $name.Substring(0,47) + "..." }
        Write-Host "     ? " -NoNewline -ForegroundColor Yellow
        Write-Host "$name" -ForegroundColor White
        if ($mod.DownloadSource) {
            Write-Host "        └─ " -NoNewline -ForegroundColor DarkGray
            Write-Host "Source: " -NoNewline -ForegroundColor DarkGray
            Write-Host "$($mod.DownloadSource)" -ForegroundColor Yellow
        }
        Write-Host ""
    }
}

if ($suspiciousMods.Count -gt 0) {
    Write-Host "   ╭────────────────────────────────────────────────────────────────────╮" -ForegroundColor Red
    Write-Host "   │                         🚨 SUSPICIOUS MODS                         │" -ForegroundColor Red
    Write-Host "   │                           ($($suspiciousMods.Count) found)                             │" -ForegroundColor Red
    Write-Host "   ╰────────────────────────────────────────────────────────────────────╯" -ForegroundColor Red
    Write-Host ""
    foreach ($mod in $suspiciousMods) {
        Write-Host "     ⚠️  " -NoNewline -ForegroundColor Red
        Write-Host "$($mod.FileName)" -ForegroundColor Yellow
        Write-Host ""
        
        if ($mod.Patterns.Count -gt 0) {
            Write-Host "        ┌─ " -NoNewline -ForegroundColor Red
            Write-Host "Detected Patterns:" -ForegroundColor Red
            foreach ($p in ($mod.Patterns | Sort-Object)) {
                Write-Host "        │   • " -NoNewline -ForegroundColor Red
                Write-Host "$p" -ForegroundColor White
            }
        }

        $uniqueStrings = $mod.Strings | Where-Object { $mod.Patterns -notcontains $_ } | Sort-Object
        if ($uniqueStrings.Count -gt 0) {
            if ($mod.Patterns.Count -gt 0) {
                Write-Host "        ├─ " -NoNewline -ForegroundColor Red
            } else {
                Write-Host "        ┌─ " -NoNewline -ForegroundColor DarkYellow
            }
            Write-Host "Detected Strings:" -ForegroundColor DarkYellow
            foreach ($s in $uniqueStrings) {
                Write-Host "        │   • " -NoNewline -ForegroundColor DarkYellow
                Write-Host "$s" -ForegroundColor DarkYellow
            }
        }
        Write-Host "        └────────────────────────────────────────────────────" -ForegroundColor DarkGray
        Write-Host ""
    }
}

if ($bypassMods.Count -gt 0) {
    Write-Host "   ╭────────────────────────────────────────────────────────────────────╮" -ForegroundColor Magenta
    Write-Host "   │                        ☠️  BYPASS DETECTED                          │" -ForegroundColor Magenta
    Write-Host "   │                           ($($bypassMods.Count) found)                             │" -ForegroundColor Magenta
    Write-Host "   ╰────────────────────────────────────────────────────────────────────╯" -ForegroundColor Magenta
    Write-Host ""
    foreach ($mod in $bypassMods) {
        Write-Host "     ☠️  " -NoNewline -ForegroundColor Magenta
        Write-Host "$($mod.FileName)" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "        ┌─ " -NoNewline -ForegroundColor Magenta
        Write-Host "Bypass Flags:" -ForegroundColor Magenta
        foreach ($flag in $mod.Flags) {
            Write-Host "        │   ⚠️  " -NoNewline -ForegroundColor Magenta
            Write-Host "$flag" -ForegroundColor White
        }
        Write-Host "        └────────────────────────────────────────────────────" -ForegroundColor DarkGray
        Write-Host ""
    }
}

# SUMMARY
Write-Host "   ╔══════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "   ║                              📊 SUMMARY                                   ║" -ForegroundColor Blue
Write-Host "   ╠══════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Blue
Write-Host ("   ║  Total files scanned: " + "$totalFiles".PadRight(37) + "║") -ForegroundColor Blue
Write-Host ("   ║  Verified mods:       " + "$($verifiedMods.Count)".PadRight(37) + "║") -ForegroundColor Blue
Write-Host ("   ║  Unknown mods:        " + "$($unknownMods.Count)".PadRight(37) + "║") -ForegroundColor Blue
Write-Host ("   ║  Suspicious mods:     " + "$($suspiciousMods.Count)".PadRight(37) + "║") -ForegroundColor Blue
Write-Host ("   ║  Bypass/Injected:     " + "$($bypassMods.Count)".PadRight(37) + "║") -ForegroundColor Blue
Write-Host "   ╚══════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

Write-Host "   ╭────────────────────────────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "   │                                                                     │" -ForegroundColor Cyan
Write-Host "   │            ✨ Analysis complete! Thanks for using! ✨               │" -ForegroundColor Cyan
Write-Host "   │                     LilyMod Meow Analyzer 🐱                       │" -ForegroundColor Cyan
Write-Host "   │                                                                     │" -ForegroundColor Cyan
Write-Host "   │                    " -NoNewline -ForegroundColor Cyan; Write-Host "Made with " -NoNewline -ForegroundColor White; Write-Host "♥" -NoNewline -ForegroundColor Red; Write-Host " by Lily<3 & Tonynoh" -NoNewline -ForegroundColor Cyan; Write-Host "               │" -ForegroundColor Cyan
Write-Host "   │                                                                     │" -ForegroundColor Cyan
Write-Host "   │    " -NoNewline -ForegroundColor Cyan; Write-Host "💬 Discord: " -NoNewline -ForegroundColor Blue; Write-Host "tonyboy90_".PadRight(47) -ForegroundColor Blue -NoNewline; Write-Host "│" -ForegroundColor Cyan
Write-Host "   │    " -NoNewline -ForegroundColor Cyan; Write-Host "🔗 GitHub:  " -NoNewline -ForegroundColor DarkGray; Write-Host "https://github.com/MeowTonynoh".PadRight(45) -ForegroundColor DarkGray -NoNewline; Write-Host "│" -ForegroundColor Cyan
Write-Host "   │    " -NoNewline -ForegroundColor Cyan; Write-Host "🎥 YouTube: " -NoNewline -ForegroundColor Red; Write-Host "tonynoh-07".PadRight(47) -ForegroundColor Red -NoNewline; Write-Host "│" -ForegroundColor Cyan
Write-Host "   │                                                                     │" -ForegroundColor Cyan
Write-Host "   ╰────────────────────────────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Blue
Write-Host ""
Write-Host "   Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
