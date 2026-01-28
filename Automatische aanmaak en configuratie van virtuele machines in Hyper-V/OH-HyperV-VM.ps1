# =================================================
# Hyper-V VM Deployment Script (v16)
# Fully CSV-driven
# =================================================

$vmPath     = "C:\vms"
$switchName = "OH-switch"
$isoPath    = "C:\vm\Win11_22H2_Dutch_x64v1.iso"
$csvPath    = ".\vmlist.csv"

$vms = Import-Csv $csvPath

$maxCPU = (Get-VMHost).LogicalProcessorCount

foreach ($vm in $vms) {

    $name       = $vm.Name
    $generation = [int]$vm.Generation
    $cpu        = [int]$vm.CPU

    Write-Host "➡️  VM aanmaken: $name" -ForegroundColor Cyan

    # -------------------------------
    # Validatie
    # -------------------------------
    if ($generation -notin 1,2) {
        throw "❌ Ongeldige Generation voor $name (1 of 2)"
    }

    if ($cpu -lt 1 -or $cpu -gt $maxCPU) {
        throw "❌ Ongeldig CPU aantal voor $name (1 - $maxCPU)"
    }

    # -------------------------------
    # VM aanmaken
    # -------------------------------
    New-VM `
        -Name $name `
        -Generation $generation `
        -MemoryStartupBytes $vm.RAM `
        -Path $vmPath `
        -NewVHDPath "$vmPath\$name\$name.vhdx" `
        -NewVHDSizeBytes $vm.HDsize `
        -SwitchName $switchName

    # CPU
    Set-VM -Name $name -ProcessorCount $cpu

    # -------------------------------
    # Generation-specifieke opties
    # -------------------------------
    if ($generation -eq 2) {

        # Secure Boot
        if ($vm.SecureBoot -eq "true") {
            Set-VMFirmware -VMName $name -EnableSecureBoot On
        } else {
            Set-VMFirmware -VMName $name -EnableSecureBoot Off
        }

        # vTPM
        if ($vm.vTPM -eq "true") {

            if (-not (Get-HgsGuardian -Name UntrustedGuardian -ErrorAction SilentlyContinue)) {
                New-HgsGuardian -Name UntrustedGuardian -GenerateCertificates
            }

            $guardian = Get-HgsGuardian -Name UntrustedGuardian

            $kp = New-HgsKeyProtector `
                -Owner $guardian `
                -AllowUntrustedRoot

            Set-VMKeyProtector `
                -VMName $name `
                -KeyProtector $kp.RawData

            Enable-VMTPM -VMName $name
        }

    } else {

        if ($vm.vTPM -eq "true" -or $vm.SecureBoot -eq "true") {
            Write-Warning "⚠️  $name is Generation 1 → vTPM & Secure Boot genegeerd"
        }
    }

    # -------------------------------
    # ISO koppelen
    # -------------------------------
    Add-VMDvdDrive -VMName $name -Path $isoPath

    # -------------------------------
    # Geen automatische checkpoints
    # -------------------------------
    Set-VM -VMName $name -AutomaticCheckpointsEnabled $false

    Write-Host "✅ VM $name succesvol aangemaakt" -ForegroundColor Green
}

Write-Host "🎉 Alle VM's zijn aangemaakt" -ForegroundColor Green

