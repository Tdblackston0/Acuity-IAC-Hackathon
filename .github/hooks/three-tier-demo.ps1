#Requires -Version 7.0
param(
    [Parameter(Mandatory)][ValidateSet('SessionStart', 'UserPromptSubmit')][string] $Event
)
$ErrorActionPreference = 'Stop'
try {
    $inputEvent = [Console]::In.ReadToEnd() | ConvertFrom-Json -AsHashtable
    if ($inputEvent -isnot [System.Collections.IDictionary]) { throw 'Expected event object.' }
    $session = if ($inputEvent.ContainsKey('sessionId')) { $inputEvent.sessionId } else { $inputEvent.session_id }
    if ([string]::IsNullOrWhiteSpace($session)) { throw 'Missing session identifier.' }
    $status = 'STARTED'
    $message = 'Hook started. Three-tier order: internal registry -> AVM -> custom. No discovery is performed by this hook.'
    if ($Event -eq 'UserPromptSubmit') {
        if ($inputEvent.prompt -isnot [string]) { throw 'Missing prompt text.' }
        if (-not $inputEvent.prompt.StartsWith('[3tier]', [StringComparison]::Ordinal)) {
            $status = 'SKIPPED'
            $message = 'Prompt event fired; no [3tier] prefix, so tier-specific checks were skipped.'
        } else {
            $resource = $inputEvent.prompt -cmatch '(?:^\[3tier\]\s*|;\s*)resource=[a-z0-9-]+(?=\s*(?:;|$))'
            $capability = $inputEvent.prompt -cmatch '(?:^\[3tier\]\s*|;\s*)capability=[a-z0-9-]+(?=\s*(?:;|$))'
            $status = if ($resource -and $capability) { 'READY' } else { 'NEEDS_DETAILS' }
            $message = if ($status -eq 'READY') {
                'Resource and capability provided. An agent could now follow internal -> AVM -> custom.'
            } else { 'Provide resource and capability: [3tier] resource=storage; capability=private-endpoint' }
        }
    }
    $logDirectory = Join-Path $PSScriptRoot 'demo-logs'
    [void][IO.Directory]::CreateDirectory($logDirectory)
    [ordered]@{
        timestamp = [DateTimeOffset]::UtcNow.ToString('o')
        session = $session
        event = $Event
        status = $status
        message = $message
    } | ConvertTo-Json -Compress | Add-Content -LiteralPath (Join-Path $logDirectory 'events.jsonl') -Encoding utf8
    if ($Event -eq 'SessionStart') {
        if ($inputEvent.ContainsKey('sessionId')) {
            @{ additionalContext = $message } | ConvertTo-Json -Compress
        } else {
            @{ hookSpecificOutput = @{ hookEventName = 'SessionStart'; additionalContext = $message } } |
                ConvertTo-Json -Depth 3 -Compress
        }
    } else { '{}' }
} catch {
    [Console]::Error.WriteLine('Three-tier demo hook failed. Check event JSON, session identifier, PowerShell 7, and demo-logs write access.')
    exit 1
}
