<#
.SYNOPSIS
    Automatiseringsscript: Configureer IP, wijzig hostnaam en word lid van het JQLab.local domein.
    LET OP: Voer dit script uit als Administrator.
#>

# --- 1. Parameters (Aanpassen aan uw omgeving) ---
$NewComputerName = "SVR-PROD-01"
$DomainName      = "JQLab.local"
$ADAdmin         = "JQLAB\Administrator"
$ADPassword      = "Pa55w.rd" 

# Netwerkinstellingen
$StaticIP        = "10.38.100.22"
$PrefixLength    = 24
$Gateway         = "10.38.100.254"
$PrimaryDNS      = "10.38.100.21" # IP van de Domain Controller
$SecondaryDNS    = "127.0.0.1"

# --- 2. Statisch IP en DNS instellen ---
Write-Host "Bezig met configureren van netwerkinstellingen..." -ForegroundColor Cyan
$Interface = Get-NetAdapter | Where-Object Status -eq "Up" | Select-Object -First 1

if ($Interface) {
    # Nieuw IP-adres instellen
    $Interface | New-NetIPAddress -IPAddress $StaticIP -PrefixLength $PrefixLength -DefaultGateway $Gateway -Force -ErrorAction SilentlyContinue
    
    # DNS-servers instellen
    $Interface | Set-DnsClientServerAddress -ServerAddresses ($PrimaryDNS, $SecondaryDNS)
    Write-Host "Netwerk geconfigureerd: IP $StaticIP, DNS $PrimaryDNS" -ForegroundColor Green
} else {
    Write-Error "Geen actieve netwerkadapter gevonden."
    exit
}

# --- 3. Inloggegevens voor het domein voorbereiden ---
$SecurePassword = ConvertTo-SecureString $ADPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($ADAdmin, $SecurePassword)

# --- 4. Hostnaam wijzigen en toevoegen aan domein ---
Write-Host "Computernaam wijzigen naar $NewComputerName en lid worden van domein $DomainName..." -ForegroundColor Cyan

try {
    # De computer hernoemen en toevoegen aan het domein
    # -Restart: Start de computer automatisch opnieuw op om de wijzigingen te voltooien
    Add-Computer -DomainName $DomainName `
                 -NewName $NewComputerName `
                 -Credential $Credential `
                 -Restart `
                 -Force
} catch {
    Write-Error "Fout bij aanmelden bij het domein. Controleer de DNS-instellingen en netwerkverbinding."
}
