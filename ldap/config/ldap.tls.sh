#!/bin/sh
#
# Configure LDAP server to use TLS with cn=config

## Generate certificates for CA + LDAP server

## Adding TLS server suit
cat > ldap.tls.certificates.ldif << EOF
dn: cn=config
add: olcTLSCACertificateFile
olcTLSCACertificateFile: /etc/ssl/certs/cacert.pem
-
add: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/ssl/private/server-key.pem
-
add: olcTLSCertificateFile
olcTLSCertificateFile: /etc/ssl/certs/server-cert.pem
EOF

## Change authorized protocols (Only TLS 256, no SSLv3)
##
## cf. http://gnutls.org/manual/html_node/Priority-Strings.html
##
## SECURE256:
## Means all the known to be secure ciphersuites that offer a security level
## 192-bit or more. The message authenticity security level is of 128 bits or
## more, and the certificate verification profile is set to
## GNUTLS_PROFILE_HIGH (128-bits).
cat > ldap.tls.protocols.ldif << EOF
dn: cn=config
changetype: modify
add: olcTLSCipherSuite
olcTLSCipherSuite: SECURE256:-VERS-SSL3.0
EOF
