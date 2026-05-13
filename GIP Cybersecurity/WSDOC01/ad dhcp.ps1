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
-DnsServer 127.0.0.1 `
-DnsDomain "localdomain"

# Exclusion range toevoegen
Add-DhcpServerv4ExclusionRange `
-ScopeId 10.38.1.0 `
-StartRange 10.38.1.250 `
-EndRange 10.38.1.253

# DHCP Scope aanmaken
Add-DhcpServerv4Scope `
-Name "Wireless" `
-StartRange 10.38.2.1 `
-EndRange 10.38.2.249 `
-SubnetMask 255.255.255.0 `
-State Active

# DHCP opties instellen
Set-DhcpServerv4OptionValue `
-ScopeId 10.38.2.0 `
-Router 10.38.2.254 `
-DnsServer 127.0.0.1 `
-DnsDomain "localdomain"

# Exclusion range toevoegen
Add-DhcpServerv4ExclusionRange `
-ScopeId 10.38.2.0 `
-StartRange 10.38.2.250 `
-EndRange 10.38.2.253
