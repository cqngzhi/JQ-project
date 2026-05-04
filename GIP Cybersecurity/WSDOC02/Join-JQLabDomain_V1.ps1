# Configure static IP
Get-NetAdapter
New-NetIPAddress -InterfaceAlias Ethernet -IPAddress 10.38.100.22 -PrefixLength 24 -DefaultGateway 10.38.100.254
# Configure DNS
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses 1("10.38.100.21", "127.0.0.1")
# Joining a domain
Add-Computer -DomainName JQLab.local -NewName WSDOC02 -Restart -Force
