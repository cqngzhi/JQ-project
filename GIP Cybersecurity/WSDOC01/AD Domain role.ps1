# Install the AD role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Define the DSRM password
$dsrmPassword = ConvertTo-SecureString "Pa55w.rd" -AsPlainText -Force

# Automated installation forest
Install-ADDSForest `
    -DomainName "JQLab.local" `
    -DomainNetbiosName "JQLAB" `
    -InstallDns `
    -SafeModeAdministratorPassword $dsrmPassword `
    -Force
