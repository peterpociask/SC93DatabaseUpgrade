$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$VerbosePreference = 'SilentlyContinue'
$WarningPreference = 'Continue'
$DebugPreference = 'SilentlyContinue'

Function Invoke-GetSettingsFromFile {
    Param ([string]$SettingsPath)

    If($SettingsPath -and (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) {
        Return . $SettingsPath
    }

    Return @{}
}

Function Invoke-MergeSettings {
    Param ([HashTable[]]$Settings)
    $FinalSettings = @{}
    ForEach ($SettingsHash in $Settings) {
        #$SettingsHash.keys | ? {$_ -notin $FinalSettings.keys} | % {$FinalSettings[$_] = $SettingsHash[$_]}
        $SettingsHash.keys | % {$FinalSettings[$_] = $SettingsHash[$_]}
    }
    Return $FinalSettings
}

Function Invoke-GetSettings {
    Param
    (
        [string]$SettingsPath,
        [string]$UserSettingsPath,
        [HashTable]$CustomSettings = @{}
    )

    $DefaultSettings = Invoke-GetSettingsFromFile -SettingsPath $SettingsPath

    $UserSettings = Invoke-GetSettingsFromFile -SettingsPath $UserSettingsPath

    Return Invoke-MergeSettings @($DefaultSettings, $UserSettings, $CustomSettings)
}