package Business::PayPal;

use 5.6.1;
use strict;
use warnings;

our $VERSION = '0.12';

use Net::SSLeay 1.14;
use Digest::MD5 qw(md5_hex);

our $Cert;
our $Certcontent;

my @certificates;
push @certificates, <<'CERT';
-----BEGIN CERTIFICATE-----
MIIGSzCCBTOgAwIBAgIQLjOHT2/i1B7T//819qTJGDANBgkqhkiG9w0BAQUFADCB
ujELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQL
ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2Ug
YXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykwNjE0MDIGA1UEAxMr
VmVyaVNpZ24gQ2xhc3MgMyBFeHRlbmRlZCBWYWxpZGF0aW9uIFNTTCBDQTAeFw0x
MTAzMjMwMDAwMDBaFw0xMzA0MDEyMzU5NTlaMIIBDzETMBEGCysGAQQBgjc8AgED
EwJVUzEZMBcGCysGAQQBgjc8AgECEwhEZWxhd2FyZTEdMBsGA1UEDxMUUHJpdmF0
ZSBPcmdhbml6YXRpb24xEDAOBgNVBAUTBzMwMTQyNjcxCzAJBgNVBAYTAlVTMRMw
EQYDVQQRFAo5NTEzMS0yMDIxMRMwEQYDVQQIEwpDYWxpZm9ybmlhMREwDwYDVQQH
FAhTYW4gSm9zZTEWMBQGA1UECRQNMjIxMSBOIDFzdCBTdDEVMBMGA1UEChQMUGF5
UGFsLCBJbmMuMRowGAYDVQQLFBFQYXlQYWwgUHJvZHVjdGlvbjEXMBUGA1UEAxQO
d3d3LnBheXBhbC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCd
szetUP2zRUbaN1vHuX9WV2mMq0IIVQ5NX2kpFCwBYc4vwW/CHiMr+dgs8lDduCfH
5uxhyRxKtJa6GElIIiP8qFB5HFWf1uUgoDPC1he4HaxUkowCnVEqjEowOy9R9Cr4
yyrmqmMEDccVsx4d3dOY2JF1FrLDHT7qH/GCBnyYw+nZJ88ci6HqnVJiNM+NX/D/
d7Y3r3V1bp7y1DaJwK/z/uMwNCC+lcM59w+nwAvLutgCW6WitFHMB+HpSsOSJlIZ
ydpj0Ox+javRR1FIdhRUFMK4wwcbD8PvULi1gM+sYsJIzP0mHDlhWRIDImG1zmy2
x7ZLp0HA5WayjI5aSn9fAgMBAAGjggHzMIIB7zAJBgNVHRMEAjAAMB0GA1UdDgQW
BBQxqt0MVbSO4lWE5aB52xc8nEq5RTALBgNVHQ8EBAMCBaAwQgYDVR0fBDswOTA3
oDWgM4YxaHR0cDovL0VWU2VjdXJlLWNybC52ZXJpc2lnbi5jb20vRVZTZWN1cmUy
MDA2LmNybDBEBgNVHSAEPTA7MDkGC2CGSAGG+EUBBxcGMCowKAYIKwYBBQUHAgEW
HGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9ycGEwHQYDVR0lBBYwFAYIKwYBBQUH
AwEGCCsGAQUFBwMCMB8GA1UdIwQYMBaAFPyKULqeuSVae1WFT5UAY4/pWGtDMHwG
CCsGAQUFBwEBBHAwbjAtBggrBgEFBQcwAYYhaHR0cDovL0VWU2VjdXJlLW9jc3Au
dmVyaXNpZ24uY29tMD0GCCsGAQUFBzAChjFodHRwOi8vRVZTZWN1cmUtYWlhLnZl
cmlzaWduLmNvbS9FVlNlY3VyZTIwMDYuY2VyMG4GCCsGAQUFBwEMBGIwYKFeoFww
WjBYMFYWCWltYWdlL2dpZjAhMB8wBwYFKw4DAhoEFEtruSiWBgy70FI4mymsSweL
IQUYMCYWJGh0dHA6Ly9sb2dvLnZlcmlzaWduLmNvbS92c2xvZ28xLmdpZjANBgkq
hkiG9w0BAQUFAAOCAQEAisdjAvky8ehg4A0J3ED6+yR0BU77cqtrLUKqzaLcLL/B
wuj8gErM8LLaWMGM/FJcoNEUgSkMI3/Qr1YXtXFvdqo3urqMhi/SsuUJU85Gnoxr
Vr0rWoBqOOnmcsVEgtYeusK0sQbxq5JlE1eq9xqYZrKuOuA/8JS1V7Ss1iFrtA5i
pwotaEK3k5NEJOQh9/Zm+fy1vZfUyyX+iVSlmyFHC4bzu2DlzZln3UzjBJeXoEfe
YjQyLpdUhUhuPslV1qs+Bmi6O+e6htDHvD05wUaRzk6vsPcEQ3EqsPbdpLgejb5p
9YDR12XLZeQjO1uiunCsJkDIf9/5Mqpu57pw8v1QNA==
-----END CERTIFICATE-----
CERT

push @certificates, <<'CERT';
-----BEGIN CERTIFICATE-----
MIIF9zCCBN+gAwIBAgIQE793e1MYa7/UOM7AWAq1djANBgkqhkiG9w0BAQUFADCB
ujELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQL
ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2Ug
YXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykwNjE0MDIGA1UEAxMr
VmVyaVNpZ24gQ2xhc3MgMyBFeHRlbmRlZCBWYWxpZGF0aW9uIFNTTCBDQTAeFw0x
MjA3MjUwMDAwMDBaFw0xNDA3MjYyMzU5NTlaMIIBDTETMBEGCysGAQQBgjc8AgED
EwJVUzEZMBcGCysGAQQBgjc8AgECEwhEZWxhd2FyZTEdMBsGA1UEDxMUUHJpdmF0
ZSBPcmdhbml6YXRpb24xEDAOBgNVBAUTBzMwMTQyNjcxCzAJBgNVBAYTAlVTMRMw
EQYDVQQRFAo5NTEzMS0yMDIxMRMwEQYDVQQIEwpDYWxpZm9ybmlhMREwDwYDVQQH
FAhTYW4gSm9zZTEWMBQGA1UECRQNMjIxMSBOIDFzdCBTdDEVMBMGA1UEChQMUGF5
UGFsLCBJbmMuMRgwFgYDVQQLFA9Ib3N0aW5nIFN1cHBvcnQxFzAVBgNVBAMUDnd3
dy5wYXlwYWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAppUu
PoT6YFWB8pFt8zRlOsXR9oiqkFI4QNwUw2P4n9XKsecMr6N41dbbKYz6jo1iwQRF
d1bF+Jhc8Me9LhSugvGmN0idSZkLKyGSC+npiVki28NBu7/bHjdM8A3Soj6r8z0w
VmhA7nyd0icIcPvtyK1lUA3oBw96B+RpA2q5WWXFkpFS7b0827rnJSy8Ymdmb3nb
7I2vMLNl+EP1oy6cXL+6hqRun7dJ2hBhf+PbXn82AOWry6kdaMh8lS7GaFhVi+3e
4MqBq7aAxB3dHTT0FE0nrcGDUKLi1G0mNZ3MC8kE73Gw4LOWbRSOwHwM6cKSYROJ
LW5h4RRoDumqqBcRLwIDAQABo4IBoTCCAZ0wGQYDVR0RBBIwEIIOd3d3LnBheXBh
bC5jb20wCQYDVR0TBAIwADAdBgNVHQ4EFgQU1jn61Uw9IMzAhBDGhhRQ272uHxgw
DgYDVR0PAQH/BAQDAgWgMEIGA1UdHwQ7MDkwN6A1oDOGMWh0dHA6Ly9FVlNlY3Vy
ZS1jcmwudmVyaXNpZ24uY29tL0VWU2VjdXJlMjAwNi5jcmwwRAYDVR0gBD0wOzA5
BgtghkgBhvhFAQcXBjAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy52ZXJpc2ln
bi5jb20vY3BzMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAfBgNVHSME
GDAWgBT8ilC6nrklWntVhU+VAGOP6VhrQzB8BggrBgEFBQcBAQRwMG4wLQYIKwYB
BQUHMAGGIWh0dHA6Ly9FVlNlY3VyZS1vY3NwLnZlcmlzaWduLmNvbTA9BggrBgEF
BQcwAoYxaHR0cDovL0VWU2VjdXJlLWFpYS52ZXJpc2lnbi5jb20vRVZTZWN1cmUy
MDA2LmNlcjANBgkqhkiG9w0BAQUFAAOCAQEAUuBmKY9TPpsM7OYaP6lu1Vu+koMp
vjr6rtj1CRqi3/LMRQv2IBiZgcvhJ4MtHlXlLX4/AZD7SlLi4ufPlcVCms7I53To
QcfdkDxjCPJ87yswfUWsrs/2r4I8Ov11hjEqrHtKYFeNylOEwY3ebXdUP0dKzF7T
ojUnh2wrXCQ209jm6z+XP0f90C9SuTe93gAv1PUhYISdvmjxnCLe5+yu3maQB4dV
+IwWEw0icKMfxU848hF/X2wqXd6pelXnox2eAFgW/OYm7kNrUvJxyvI+1YXAoQOG
yV9cU3oSGzyTfllBTZWTzvPT1rzG40AL3OQXk8qgWUKfpEhsZVAnMBa2Xg==
-----END CERTIFICATE-----
CERT

push @certificates, <<'CERT';
-----BEGIN CERTIFICATE-----
MIIGFTCCBP2gAwIBAgIQNlFL9KRy51iD/qafxhevQDANBgkqhkiG9w0BAQUFADCB
ujELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQL
ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2Ug
YXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykwNjE0MDIGA1UEAxMr
VmVyaVNpZ24gQ2xhc3MgMyBFeHRlbmRlZCBWYWxpZGF0aW9uIFNTTCBDQTAeFw0x
MzA2MjAwMDAwMDBaFw0xNTA0MDIyMzU5NTlaMIIBCTETMBEGCysGAQQBgjc8AgED
EwJVUzEZMBcGCysGAQQBgjc8AgECEwhEZWxhd2FyZTEdMBsGA1UEDxMUUHJpdmF0
ZSBPcmdhbml6YXRpb24xEDAOBgNVBAUTBzMwMTQyNjcxCzAJBgNVBAYTAlVTMRMw
EQYDVQQRFAo5NTEzMS0yMDIxMRMwEQYDVQQIEwpDYWxpZm9ybmlhMREwDwYDVQQH
FAhTYW4gSm9zZTEWMBQGA1UECRQNMjIxMSBOIDFzdCBTdDEVMBMGA1UEChQMUGF5
UGFsLCBJbmMuMRQwEgYDVQQLFAtDRE4gU3VwcG9ydDEXMBUGA1UEAxQOd3d3LnBh
eXBhbC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDZje1RuIc0
ZTQmFw9evOsbre5ARBELvpAh9zVIgemHpQtECv0D8IUaYA9adxCdfw7L4kh6hCnK
zpUdVMyIAZJmJJHiGLdpPPN5NDQdA7KUjfWXWmXGnmiH17afV0NkJkh2MXEAZyQs
bnd8BWP740X7SDFemI6FVnjbH8JAE9ItOCOcISghdzblXafVGbrshqbXlYWCYfKR
o3Y606vmgR9hVROYWgqIogdh8SO9injq/wtjzNGFRZvShVGuUCxrN3MLgPQ/MMk1
Aj2J9eavxIu9Y6cPMO3cGQGNncsUG4PcaIaTGhA5rKLE8hgPlngswrFt8KLbc7MD
xq3rCwfSpuAzAgMBAAGjggHDMIIBvzA7BgNVHREENDAygg53d3cucGF5cGFsLmNv
bYISaGlzdG9yeS5wYXlwYWwuY29tggx0LnBheXBhbC5jb20wCQYDVR0TBAIwADAO
BgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMEQG
A1UdIAQ9MDswOQYLYIZIAYb4RQEHFwYwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93
d3cudmVyaXNpZ24uY29tL2NwczAdBgNVHQ4EFgQUGApL2hPrOnyphg7eRbdMj1CZ
oacwHwYDVR0jBBgwFoAU/IpQup65JVp7VYVPlQBjj+lYa0MwQgYDVR0fBDswOTA3
oDWgM4YxaHR0cDovL0VWU2VjdXJlLWNybC52ZXJpc2lnbi5jb20vRVZTZWN1cmUy
MDA2LmNybDB8BggrBgEFBQcBAQRwMG4wLQYIKwYBBQUHMAGGIWh0dHA6Ly9FVlNl
Y3VyZS1vY3NwLnZlcmlzaWduLmNvbTA9BggrBgEFBQcwAoYxaHR0cDovL0VWU2Vj
dXJlLWFpYS52ZXJpc2lnbi5jb20vRVZTZWN1cmUyMDA2LmNlcjANBgkqhkiG9w0B
AQUFAAOCAQEAOEWwhuTokV821X0QOG+dhhG6+byaz4exGrvrwyvN90BXPiuqN4Me
alagNOhVqVcAv73XufXrX/CzYsJtL++4UZeJl2ysjxyYA7kpjhfwq51RYz6iOlKF
DaxNLYKaY+cmA+cflvkiqxigOZnKxyzl2Jp0ttobSLGGMvnXW7BI6fhdZfLe32g4
MesCwybF7PYDixvIe6/cW1TUcg5Vs3ZOhMUde4LFlmUDpMZ/HX8ffQ8esVN+sgIh
y2mt5QRfmWiJmazmAZIaAAgfF/HJW9DuSJbjylrHklkrbip20iOlEbomy5Eq9If7
O7ugV9tPvj01jhp3LXSQH9KDSo0QXD0a6g==
-----END CERTIFICATE-----
CERT

push @certificates, <<'CERT';
-----BEGIN CERTIFICATE-----
MIIF+TCCBOGgAwIBAgIQJ5YBtzGVFcWhgQF5HesilzANBgkqhkiG9w0BAQUFADCB
ujELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQL
ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2Ug
YXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykwNjE0MDIGA1UEAxMr
VmVyaVNpZ24gQ2xhc3MgMyBFeHRlbmRlZCBWYWxpZGF0aW9uIFNTTCBDQTAeFw0x
MzAxMTAwMDAwMDBaFw0xNTA0MDIyMzU5NTlaMIIBDzETMBEGCysGAQQBgjc8AgED
EwJVUzEZMBcGCysGAQQBgjc8AgECEwhEZWxhd2FyZTEdMBsGA1UEDxMUUHJpdmF0
ZSBPcmdhbml6YXRpb24xEDAOBgNVBAUTBzMwMTQyNjcxCzAJBgNVBAYTAlVTMRMw
EQYDVQQRFAo5NTEzMS0yMDIxMRMwEQYDVQQIEwpDYWxpZm9ybmlhMREwDwYDVQQH
FAhTYW4gSm9zZTEWMBQGA1UECRQNMjIxMSBOIDFzdCBTdDEVMBMGA1UEChQMUGF5
UGFsLCBJbmMuMRowGAYDVQQLFBFQYXlQYWwgUHJvZHVjdGlvbjEXMBUGA1UEAxQO
d3d3LnBheXBhbC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDX
DWQiB+XDFkua7H7qtwaxDDrkNiR376if+UNgRcK/0DjG6oCJGWxVvzgJ5dIlab7s
hM1QpKXmpxM+vzUwQE441t1yZXQdsG5U+pAXoCki3gb9ZIJAvSy+KVIzs1BLR38u
/WFunABQloY0Uw+9Q1rrul67MnCeQ+Y5CybIXy6UXSgn1tssLIK5EKO26vOj7t6O
3+ouNfUPAIozv56sEOmlQB25BGqafEVn+MHIyl1Ks4toG3Im97f+5LoBnI6tvdVM
/kndq5tIkTQBhY8vKKPajQei8odD75eP7SYDQyrNeGO7C5j71GOa6EILv+kqyMqs
btNNjngHeQmEDHjg1VEZAgMBAAGjggGhMIIBnTAZBgNVHREEEjAQgg53d3cucGF5
cGFsLmNvbTAJBgNVHRMEAjAAMB0GA1UdDgQWBBTIhlfkmAqzuJ2oqOPsGBtJ6sn2
2TAOBgNVHQ8BAf8EBAMCBaAwQgYDVR0fBDswOTA3oDWgM4YxaHR0cDovL0VWU2Vj
dXJlLWNybC52ZXJpc2lnbi5jb20vRVZTZWN1cmUyMDA2LmNybDBEBgNVHSAEPTA7
MDkGC2CGSAGG+EUBBxcGMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LnZlcmlz
aWduLmNvbS9jcHMwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMB8GA1Ud
IwQYMBaAFPyKULqeuSVae1WFT5UAY4/pWGtDMHwGCCsGAQUFBwEBBHAwbjAtBggr
BgEFBQcwAYYhaHR0cDovL0VWU2VjdXJlLW9jc3AudmVyaXNpZ24uY29tMD0GCCsG
AQUFBzAChjFodHRwOi8vRVZTZWN1cmUtYWlhLnZlcmlzaWduLmNvbS9FVlNlY3Vy
ZTIwMDYuY2VyMA0GCSqGSIb3DQEBBQUAA4IBAQBe0V9KFlzAPdMxrTrBe8QHEICg
xUkz8DQG3EN8WpBXC2Vaucd/lNDELv6pCmn6Ejg8UwRTNWQRWbDQxa4kcgkkDGAL
CkglOXtqWHyA9nCZftjRSRDpswH0KlbSx1fES1zrlvWbhJzejuI+AO5E1HMKm4rO
Kk0O/l78spIffhU6SurTk7WGbr/YzCB2YBC9L0qYFcNUcJBMU5LKV/4XXWMzVQW0
aPyuvAIIrmXLRtXxxi7TlBOxeUsXAz/DQt72FJnHllzSkDEPEG11+xjAL6i33hzi
SZeqm2fJ6m8lDPoDdSp5TlSzkRRZQ0FcAc8BAdxfS1dd34Fa+6p59HM6XM6J
-----END CERTIFICATE-----
CERT

# added to 0.12 on 2014.04.19
push @certificates, <<'CERT';
-----BEGIN CERTIFICATE-----
MIIGCDCCBPCgAwIBAgIQCDTkU9Q6aFcjr/uxM85FfDANBgkqhkiG9w0BAQUFADCB
ujELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQL
ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2Ug
YXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykwNjE0MDIGA1UEAxMr
VmVyaVNpZ24gQ2xhc3MgMyBFeHRlbmRlZCBWYWxpZGF0aW9uIFNTTCBDQTAeFw0x
NDA0MTUwMDAwMDBaFw0xNTA0MDIyMzU5NTlaMIIBCTETMBEGCysGAQQBgjc8AgED
EwJVUzEZMBcGCysGAQQBgjc8AgECEwhEZWxhd2FyZTEdMBsGA1UEDxMUUHJpdmF0
ZSBPcmdhbml6YXRpb24xEDAOBgNVBAUTBzMwMTQyNjcxCzAJBgNVBAYTAlVTMRMw
EQYDVQQRFAo5NTEzMS0yMDIxMRMwEQYDVQQIEwpDYWxpZm9ybmlhMREwDwYDVQQH
FAhTYW4gSm9zZTEWMBQGA1UECRQNMjIxMSBOIDFzdCBTdDEVMBMGA1UEChQMUGF5
UGFsLCBJbmMuMRQwEgYDVQQLFAtDRE4gU3VwcG9ydDEXMBUGA1UEAxQOd3d3LnBh
eXBhbC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+rkZNmW5t
bDVLiDI4u9zQCZXQmuQ2558KsPLX0jBiAx+txvRtEIT3eRu8dMCo44L+1AqTLj1L
EiStrV9d7RzJHG8Te+LBJU5GX087LlrLwVq0gs+to2XohjO17R14mafH1foQLvsR
TiNYBpaHcXVRc4wP9Mp8j5EleRPcsPDeCAcBC2TMV2oShmIXPl25Yj1Yeypu9qYw
QQL87GRyM9XVP2ttl/PBYb84O6tBR9TCA9c7WVed4aEq1njog1093apdF/2U1uV6
7wJjxqPGLVszCIv1pQO0/vIdq79enrh4OSAraGFP5JnyqsJNS0jLaMIQP/qausVq
U48i89fJ7aTVAgMBAAGjggG2MIIBsjBnBgNVHREEYDBegg53d3cucGF5cGFsLmNv
bYISaGlzdG9yeS5wYXlwYWwuY29tggx0LnBheXBhbC5jb22CDGMucGF5cGFsLmNv
bYIOdG1zLnBheXBhbC5jb22CDHRtcy5lYmF5LmNvbTAJBgNVHRMEAjAAMA4GA1Ud
DwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwZgYDVR0g
BF8wXTBbBgtghkgBhvhFAQcXBjBMMCMGCCsGAQUFBwIBFhdodHRwczovL2Quc3lt
Y2IuY29tL2NwczAlBggrBgEFBQcCAjAZGhdodHRwczovL2Quc3ltY2IuY29tL3Jw
YTAfBgNVHSMEGDAWgBT8ilC6nrklWntVhU+VAGOP6VhrQzArBgNVHR8EJDAiMCCg
HqAchhpodHRwOi8vc2Euc3ltY2IuY29tL3NhLmNybDBXBggrBgEFBQcBAQRLMEkw
HwYIKwYBBQUHMAGGE2h0dHA6Ly9zYS5zeW1jZC5jb20wJgYIKwYBBQUHMAKGGmh0
dHA6Ly9zYS5zeW1jYi5jb20vc2EuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQB2CKtk
9vQL5IG9WbI+pPz1A3UEWWq1/hI0KgScic3L4TxsIDnU6m8nNH9iHEVyETnARaoq
NVy2BuMIp48Ir4CyEM6lKFscSVUR62sqgMEJ7YJySMoZi+U0lDxQJndrGmO6b2PR
WO0rHbenbgQlmcOUA5DsD0yTgzWG43CEDTzOr06AStORP1UzLx9nhy8JokHAEEos
xIigb5Ms7zjSYcfs8zd9yTKlXB5IDoVsRyp/xjBewvYu3eNNrP/vSCbHUXRHMkYL
zXoKXVvFje0XvN4JvOmTqXyFnIimg7zW5R8FEN+yT6LFlwCLV8cN58dXV4d9E59c
XPfzzQCJDYWaonDa
-----END CERTIFICATE-----
CERT

chomp(@certificates);

my @cert_contents;
push @cert_contents, <<'CERTCONTENT';
Subject Name: /1.3.6.1.4.1.311.60.2.1.3=US/1.3.6.1.4.1.311.60.2.1.2=Delaware/businessCategory=Private Organization/serialNumber=3014267/C=US/postalCode=95131-2021/ST=California/L=San Jose/street=2211 N 1st St/O=PayPal, Inc./OU=PayPal Production/CN=www.paypal.com
Issuer  Name: /C=US/O=VeriSign, Inc./OU=VeriSign Trust Network/OU=Terms of use at https://www.verisign.com/rpa (c)06/CN=VeriSign Class 3 Extended Validation SSL CA
CERTCONTENT

push @cert_contents, <<'CERTCONTENT';
Subject Name: /1.3.6.1.4.1.311.60.2.1.3=US/1.3.6.1.4.1.311.60.2.1.2=Delaware/businessCategory=Private Organization/serialNumber=3014267/C=US/postalCode=95131-2021/ST=California/L=San Jose/street=2211 N 1st St/O=PayPal, Inc./OU=Hosting Support/CN=www.paypal.com
Issuer  Name: /C=US/O=VeriSign, Inc./OU=VeriSign Trust Network/OU=Terms of use at https://www.verisign.com/rpa (c)06/CN=VeriSign Class 3 Extended Validation SSL CA
CERTCONTENT

push @cert_contents, <<'CERTCONTENT';
Subject Name: /1.3.6.1.4.1.311.60.2.1.3=US/1.3.6.1.4.1.311.60.2.1.2=Delaware/2.5.4.15=Private Organization/serialNumber=3014267/C=US/postalCode=95131-2021/ST=California/L=San Jose/streetAddress=2211 N 1st St/O=PayPal, Inc./OU=PayPal Production/CN=www.paypal.com
Issuer  Name: /C=US/O=VeriSign, Inc./OU=VeriSign Trust Network/OU=Terms of use at https://www.verisign.com/rpa (c)06/CN=VeriSign Class 3 Extended Validation SSL CA
CERTCONTENT

push @cert_contents, <<'CERTCONTENT';
Subject Name: /1.3.6.1.4.1.311.60.2.1.3=US/1.3.6.1.4.1.311.60.2.1.2=Delaware/2.5.4.15=Private Organization/serialNumber=3014267/C=US/postalCode=95131-2021/ST=California/L=San Jose/streetAddress=2211 N 1st St/O=PayPal, Inc./OU=Hosting Support/CN=www.paypal.com
Issuer  Name: /C=US/O=VeriSign, Inc./OU=VeriSign Trust Network/OU=Terms of use at https://www.verisign.com/rpa (c)06/CN=VeriSign Class 3 Extended Validation SSL CA
CERTCONTENT

push @cert_contents, <<'CERTCONTENT';
Subject Name: /1.3.6.1.4.1.311.60.2.1.3=US/1.3.6.1.4.1.311.60.2.1.2=Delaware/businessCategory=Private Organization/serialNumber=3014267/C=US/postalCode=95131-2021/ST=California/L=San Jose/street=2211 N 1st St/O=PayPal, Inc./OU=CDN Support/CN=www.paypal.com
Issuer  Name: /C=US/O=VeriSign, Inc./OU=VeriSign Trust Network/OU=Terms of use at https://www.verisign.com/rpa (c)06/CN=VeriSign Class 3 Extended Validation SSL CA
CERTCONTENT

push @cert_contents, <<'CERTCONTENT';
Subject Name: /1.3.6.1.4.1.311.60.2.1.3=US/1.3.6.1.4.1.311.60.2.1.2=Delaware/2.5.4.15=Private Organization/serialNumber=3014267/C=US/postalCode=95131-2021/ST=California/L=San Jose/streetAddress=2211 N 1st St/O=PayPal, Inc./OU=CDN Support/CN=www.paypal.com
Issuer  Name: /C=US/O=VeriSign, Inc./OU=VeriSign Trust Network/OU=Terms of use at https://www.verisign.com/rpa (c)06/CN=VeriSign Class 3 Extended Validation SSL CA
CERTCONTENT

chomp(@cert_contents);

# creates new PayPal object.  Assigns an id if none is provided.
sub new {
    my $class = shift;

    my $self = {
        id => undef,
        address => 'https://www.paypal.com/cgi-bin/webscr',
        @_,
    };
    bless $self, $class;
    $self->{id} = md5_hex(rand()) unless $self->{id};

    return $self;
}

# returns current PayPal id
sub id {
    my ($self) = @_;

    return $self->{id};
}

#creates a PayPal button
sub button {
    my $self = shift;

    my %buttonparam = (
        cmd                 => '_ext-enter',
        redirect_cmd        => '_xclick',
        button_image        => qq{<input type="image" name="submit" src="http://images.paypal.com/images/x-click-but01.gif" alt="Make payments with PayPal" />},
        business            => undef,
        item_name           => undef,
        item_number         => undef,
        image_url           => undef,
        no_shipping         => 1,
        return              => undef,
        cancel_return       => undef,
        no_note             => 1,
        undefined_quantity  => 0,
        notify_url          => undef,
        first_name          => undef,
        last_name           => undef,
        shipping            => undef,
        shipping2           => undef,
        quantity            => undef,
        amount              => undef,
        address1            => undef,
        address2            => undef,
        city                => undef,
        state               => undef,
        zip                 => undef,
        night_phone_a       => undef,
        night_phone_b       => undef,
        night_phone_c       => undef,
        day_phone_a         => undef,
        day_phone_b         => undef,
        day_phone_c         => undef,
        receiver_email      => undef,
        invoice             => undef,
        currency_code       => undef,
        custom              => $self->{id},
        @_,
    );
    my $key;
    my $content = qq{<form method="post" action="$self->{address}" enctype="multipart/form-data">\n};

    foreach my $param (sort keys %buttonparam) {
        next if not defined $buttonparam{$param};
        next if $param eq 'button_image';
        $content .= qq{<input type="hidden" name="$param" value="$buttonparam{$param}" />\n};
    }
    $content .= "$buttonparam{button_image}\n";
    $content .= qq{</form>\n};

    return $content;
}


# takes a reference to a hash of name value pairs, such as from a CGI query
# object, which should contain all the name value pairs which have been
# posted to the script by PayPal's Instant Payment Notification
# posts that data back to PayPal, checking if the ssl certificate matches,
# and returns success or failure, and the reason.
sub ipnvalidate {
    my ($self, $query) = @_;

    $query->{cmd} = '_notify-validate';
    my $id = $self->{id};
    my ($succ, $reason) = $self->postpaypal($query);

    return (wantarray ? ($id,   $reason) : $id  ) if $succ;
    return (wantarray ? (undef, $reason) : undef);
}

# this method should not normally be used unless you need to test, or if
# you are overriding the behaviour of ipnvalidate.  It takes a reference
# to a hash containing the query, posts to PayPal with the data, and returns
# success or failure, as well as PayPal's response.
sub postpaypal {
    my ($self, $query) = @_;

    my $address = $self->{address};
    my ($site, $port, $path);

    #following code splits an url into site, port and path components
    my @address = split /:\/\//, $address, 2;
    @address = split /(?=\/)/, $address[1], 2;
    if ($address[0] =~ /:/) {
        ($site, $port) = split /:/, $address[0];
    }
    else {
        ($site, $port) = ($address[0], '443');
    }
    $path = $address[1];
    my ($page,
        $response,
        $headers,
        $ppcert,
        ) = Net::SSLeay::post_https3($site,
                                         $port,
                                         $path,
                                         '',
                                         Net::SSLeay::make_form(%$query));

    return (wantarray ? (undef, "No PayPal cert found") : undef)
        unless $ppcert;

    my $ppx509 = Net::SSLeay::PEM_get_string_X509($ppcert);
    my $ppcertcontent =
    'Subject Name: '
        . Net::SSLeay::X509_NAME_oneline(
               Net::SSLeay::X509_get_subject_name($ppcert))
            . "\nIssuer  Name: "
                . Net::SSLeay::X509_NAME_oneline(
                       Net::SSLeay::X509_get_issuer_name($ppcert))
                    . "\n";

    chomp $ppx509;
    chomp $ppcertcontent;

	my @certs = @certificates;
	if ($Cert) {
		# TODO added in 0.12
		warn "The global variable \$Cert is deprecated and will be removed soon. Pass a certificate to the constructor using the 'cert' parameter.\n";
		push @certs, $Cert;
	}
	my @cert_cont = @cert_contents;
	if ($Certcontent) {
		# TODO added in 0.12
		warn "The global variable \$Certcontent is deprecated and will be removed soon. Pass a certificate to the constructor using the 'certcontent' parameter.\n";
		push @cert_cont, $Certcontent;
	}

	if ($self->{addcert}) {
		push @certs, $self->{cert};
	}
	if ($self->{addcertcontent}) {
		push @certs, $self->{certcontent};
	}

	if ($self->{cert}) {
		@certs = $self->{cert};
	}
	if ($self->{certcontent}) {
		@certs = $self->{certcontent};
	}

    return (wantarray ? (undef, "PayPal cert failed to match: $ppx509") : undef)
        unless grep {$_ eq $ppx509} @certs;
    return (wantarray ? (undef, "PayPal cert contents failed to match $ppcertcontent") : undef)
        unless grep { $_ eq $ppcertcontent } @cert_cont;
    return (wantarray ? (undef, 'PayPal says transaction INVALID') : undef)
        if $page eq 'INVALID';
    return (wantarray ? (1, 'PayPal says transaction VERIFIED') : 1)
        if $page eq 'VERIFIED';
    warn "Bad stuff happened\n$page";
    return (wantarray ? (undef, "Bad stuff happened") :undef);
}



1;

=head1 NAME

Business::PayPal - Perl extension for automating PayPal transactions

=head1 ABSTRACT

Business::PayPal makes the automation of PayPal transactions as simple
as doing credit card transactions through a regular processor.  It includes
methods for creating PayPal buttons and for validating the Instant Payment
Notification that is sent when PayPal processes a payment.

=head1 SYNOPSIS

To generate a PayPal button for use on your site
Include something like the following in your CGI

  use Business::PayPal;
  my $paypal = Business::PayPal->new;
  my $button = $paypal->button(
      business => 'dr@dursec.com',
      item_name => 'CanSecWest Registration Example',
      return => 'http://www.cansecwest.com/return.cgi',
      cancel_return => 'http://www.cansecwest.com/cancel.cgi',
      amount => '1600.00',
      quantity => 1,
      notify_url => http://www.cansecwest.com/ipn.cgi
  );
  my $id = $paypal->id;

Store $id somewhere so we can get it back again later

Store current context with $id.

Print button to the browser.

Note, button is an HTML form, already enclosed in <form></form> tags



To validate the Instant Payment Notification from PayPal for the
button used above include something like the following in your
'notify_url' CGI.

  use CGI;
  my $query = CGI->new;
  my %query = $query->Vars;
  my $id = $query{custom};
  my $paypal = Business::PayPal->new(id => $id);
  my ($txnstatus, $reason) = $paypal->ipnvalidate(\%query);
  die "PayPal failed: $reason" unless $txnstatus;
  my $money = $query{payment_gross};
  my $paystatus = $query{payment_status};

Check if paystatus eq 'Completed'.
Check if $money is the amount you expected.
Save payment status information to store as $id.


To tell the user if their payment succeeded or not, use something like
the following in the CGI pointed to by the 'return' parameter in your
PayPal button.

  use CGI;
  my $query = CGI->new;
  my $id = $query{custom};

  #get payment status from store for $id
  #return payment status to customer


=head1 DESCRIPTION

=head2 new()

Creates a new Business::PayPal object, it can take the
following parameters:

=over 2

=item id

The Business::PayPal object id, if not specified a new
id will be created using md5_hex(rand())

=item address

The address of PayPal's payment server, currently:
https://www.paypal.com/cgi-bin/webscr

=item cert

The x509 certificate for I<address>, see source for default.

=item certcontent

The contents of the x509 certificate I<cert>, see source for
default.

=item addcert

The x509 certificate for I<address>.
This is added to the default values.

=item addcertcontent

The contents of the x509 certificate I<cert>,
This is added to the default values.

=back

=head2 id()

Returns the id for the Business::PayPal object.

=head2 button()

Returns the HTML for a PayPal button.  It takes a large number of
parameters, which control the look and function of the button, some
of which are required and some of which have defaults.  They are
as follows:

=over 2

=item cmd

required, defaults to '_ext-enter'

This allows the user information to be pre-filled in.
You should never need to specify this, as the default should
work fine.

=item redirect_cmd

required, defaults to '_xclick'

This allows the user information to be pre-filled in.
You should never need to specify this, as the default should
work fine.

=item button_image

required, defaults to:

    CGI::image_button(-name => 'submit',
                      -src  => 'http://images.paypal.com/x-click-but01.gif'
                      -alt  => 'Make payments with PayPal',
                     )

You may wish to change this if the button is on an https page
so as to avoid the browser warnings about insecure content on a
secure page.

=item business

required, no default

This is the name of your PayPal account.

=item item_name

This is the name of the item you are selling.

=item item_number

This is a numerical id of the item you are selling.

=item image_url

A URL pointing to a 150 x 50 image which will be displayed
instead of the name of your PayPal account.

=item no_shipping

defaults to 1

If set to 1, does not ask customer for shipping info, if
set to 0 the customer will be prompted for shipping information.

=item return

This is the URL to which the customer will return to after
they have finished paying.

=item cancel_return

This is the URL to which the customer will be sent if they cancel
before paying.

=item no_note

defaults to 1

If set to 1, does not ask customer for a note with the payment,
if set to 0, the customer will be asked to include a note.

=item currency_code

Currency the payment should be taken in, e.g. EUR, GBP.
If not specified payments default to USD.

=item address1

=item undefined_quantity

defaults to 0

If set to 0 the quantity defaults to 1, if set to 1 the user
can edit the quantity.

=item notify_url

The URL to which PayPal Instant Payment Notification is sent.

=item first_name

First name of customer, used to pre-fill PayPal forms.

=item last_name

Last name of customer, used to pre-fill PayPal forms.

=item shipping

I don't know, something to do with shipping, please tell me if
you find out.

=item shipping2

I don't know, something to do with shipping, please tell me if you
find out.

=item quantity

defaults to 1

Number of items being sold.

=item amount

Price of the item being sold.

=item address1

Address of customer, used to pre-fill PayPal forms.

=item address2

Address of customer, used to pre-fill PayPal forms.

=item city

City of customer, used to pre-fill PayPal forms.

=item state

State of customer, used to pre-fill PayPal forms.

=item zip

Zip of customer, used to pre-fill PayPal forms.

=item night_phone_a

Phone

=item night_phone_b

Phone

=item night_phone_c

Phone

=item day_phone_a

Phone

=item day_phone_b

Phone

=item day_phone_c

Phone

=item receiver_email

Email address of customer - I think

=item invoice

Invoice number - I think

=item custom

defaults to the Business::PayPal id

Used by Business::PayPal to track which button is associated
with which Instant Payment Notification.

=back

=head2 ipnvalidate()

Takes a reference to a hash of name value pairs, such as from a
CGI query object, which should contain all the name value pairs
which have been posted to the script by PayPal's Instant Payment
Notification posts that data back to PayPal, checking if the ssl
certificate matches, and returns success or failure, and the
reason.

=head2 postpaypal()

This method should not normally be used unless you need to test,
or if you are overriding the behaviour of ipnvalidate.  It takes a
reference to a hash containing the query, posts to PayPal with
the data, and returns success or failure, as well as PayPal's
response.

=head1 MAINTAINER

Gabor Szabo, L<http://szabgab.com/>, L<http://perlmaven.com/>

phred, E<lt>fred@redhotpenguin.comE<gt>

=head1 AUTHOR

mock, E<lt>mock@obscurity.orgE<gt>

=head1 SEE ALSO

L<CGI>, L<perl>, L<Apache::Session>.

Explanation of the fields: L<http://www.paypalobjects.com/en_US/ebook/subscriptions/html.html>
See also in the pdf here: L<https://www.paypal.com/cgi-bin/webscr?cmd=p/xcl/rec/subscr-manual-outside>


=head1 LICENSE

Copyright (c) 2010, phred E<lt>fred@redhotpenguin.comE<gt>. All rights reserved.

Copyright (c) 2002, mock E<lt>mock@obscurity.orgE<gt>.  All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
