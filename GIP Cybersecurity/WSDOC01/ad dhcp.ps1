# DHCP Scope aanmaken
Add-DhcpServerv4Scope `
-Name "Clients" `
-StartRange 10.38.1.1 `
-EndRange 10.38.1.249 `
-SubnetMask 255.255.255.0 `
-State Active

# DHCP opties instellen
Set-DhcpServerv4OptionValue `
-ScopeId 10.38.1.0 `
-Router 10.38.1.254 `
-DnsServer 8.8.8.8,1.1.1.1 `
-DnsDomain "localdomain"

# Exclusion range toevoegen
Add-DhcpServerv4ExclusionRange `
-ScopeId 10.38.1.0 `
-StartRange 10.38.1.250 `
-EndRange 10.38.1.253

# DHCP Scope aanmaken
Add-DhcpServerv4Scope `
-Name "Wireless" `
-StartRange 10.38.1.10 `
-EndRange 10.38.1.200 `
-SubnetMask 255.255.255.0 `
-State Active

# DHCP opties instellen
Set-DhcpServerv4OptionValue `
-ScopeId 10.38.1.0 `
-Router 10.38.1.254 `
-DnsServer 8.8.8.8,1.1.1.1 `
-DnsDomain "localdomain"

# Exclusion range toevoegen
Add-DhcpServerv4ExclusionRange `
-ScopeId 10.38.1.0 `
-StartRange 10.38.1.250 `
-EndRange 10.38.1.253
