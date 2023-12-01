# How to create Root Certificate

## Using Powershell: 

The following shall create a Self Signed Root Certificate. You need to **run Powershell in Administrator Mode**

```pwsh
$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature -Subject "CN=VPNRoot" -KeyExportPolicy Exportable -HashAlgorithm sha256 -KeyLength 2048 -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign
```

The certificate is than stored in CertStoreLocation. Also `$cert` variable has the certificate now. We shall use this to create a Client Certificate


```pwsh
New-SelfSignedCertificate -Type Custom -DnsName VPNCert -KeySpec Signature -Subject "CN=VPNCert" -KeyExportPolicy Exportable -HashAlgorithm sha256 -KeyLength 2048 -CertStoreLocation "Cert:\CurrentUser\My" -Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")
```