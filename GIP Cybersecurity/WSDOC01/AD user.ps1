# --- 1. Aanmaken van de Organizational Units (OU's) ---
New-ADOrganizationalUnit -Name "IT" -Path "DC=JQLab,DC=local"
New-ADOrganizationalUnit -Name "verkoper" -Path "DC=JQLab,DC=local"
New-ADOrganizationalUnit -Name "boekhouder" -Path "DC=JQLab,DC=local"

# --- 2. Aanmaken van de Gebruikersgroepen (Groups) ---
New-ADGroup -Name "IT" -GroupScope Global -Path "OU=IT,DC=JQLab,DC=local"
New-ADGroup -Name "verkoper" -GroupScope Global -Path "OU=verkoper,DC=JQLab,DC=local"
New-ADGroup -Name "boekhouder" -GroupScope Global -Path "OU=boekhouder,DC=JQLab,DC=local"
New-ADGroup -Name "WiFi_Radut_Access" -GroupScope Global -Path "DC=JQLab,DC=local"

# --- 3. Batchgewijs aanmaken van gebruikers (Wachtwoord verloopt nooit) ---

# IT Afdeling - Verantwoordelijke: James Smith (JSmith)
"James Smith","Emily Davis","Michael Brown","Sarah Wilson" | ForEach-Object {
    $sam = $_.Split(' ')[0][0] + $_.Split(' ')[1]
    New-ADUser -Name $_ -SamAccountName $sam -Path "OU=IT,DC=JQLab,DC=local" -Enabled $true -AccountPassword (ConvertTo-SecureString "Pa55w.rd" -AsPlainText -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false
    Add-ADGroupMember -Identity "IT" -Members $sam
    Add-ADGroupMember -Identity "WiFi_Radut_Access" -Members $sam
}

# Verkoopafdeling (verkoper) - Verantwoordelijke: Robert Jones (RJones)
"Robert Jones","Linda Taylor","William Clark","Jessica White" | ForEach-Object {
    $sam = $_.Split(' ')[0][0] + $_.Split(' ')[1]
    New-ADUser -Name $_ -SamAccountName $sam -Path "OU=verkoper,DC=JQLab,DC=local" -Enabled $true -AccountPassword (ConvertTo-SecureString "Pa55w.rd" -AsPlainText -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false
    Add-ADGroupMember -Identity "verkoper" -Members $sam
    Add-ADGroupMember -Identity "WiFi_Radut_Access" -Members $sam
}

# Boekhouding (boekhouder) - Verantwoordelijke: David Miller (DMiller)
"David Miller","Karen Moore","Thomas Hall","Nancy Young" | ForEach-Object {
    $sam = $_.Split(' ')[0][0] + $_.Split(' ')[1]
    New-ADUser -Name $_ -SamAccountName $sam -Path "OU=boekhouder,DC=JQLab,DC=local" -Enabled $true -AccountPassword (ConvertTo-SecureString "Pa55w.rd" -AsPlainText -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false
    Add-ADGroupMember -Identity "boekhouder" -Members $sam
    Add-ADGroupMember -Identity "WiFi_Radut_Access" -Members $sam
}

# --- 4. Instellen van de Groepsbeheerders (Owners/ManagedBy) ---
Set-ADGroup -Identity "IT" -ManagedBy "JSmith"
Set-ADGroup -Identity "verkoper" -ManagedBy "RJones"
Set-ADGroup -Identity "boekhouder" -ManagedBy "DMiller"

# --- 5. Bevoegdheden verhogen: IT Owner toevoegen aan Domain Admins ---
Add-ADGroupMember -Identity "Domain Admins" -Members "JSmith"

Write-Host "--- JQLab Implementatie Voltooid ---" -ForegroundColor Cyan
Write-Host "1. OU's aangemaakt: IT, verkoper en boekhouder."
Write-Host "2. Gebruikers ingesteld met 'Password Never Expires'."
Write-Host "3. Beheerders (Owners) toegewezen voor elke groep."
Write-Host "4. IT-verantwoordelijke JSmith is nu Domain Admin."
