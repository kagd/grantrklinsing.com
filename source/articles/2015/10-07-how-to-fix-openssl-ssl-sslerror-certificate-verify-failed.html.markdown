---
title: "How to fix OpenSSL::SSL::SSLError: certificate verify failed"
date: 2015-10-07 17:23 MDT
tags: rvm, ssl
---

If you are using RVM, make sure to install Ruby versions without binaries. I'm
not sure why this works, but it does. The crappy part is that you have to do this
on every version bump of Ruby... boo.

`rvm install ruby-2.2.2 --without-binaries`

## Update

*February 9, 2015*

During my last install the Rails console was finding an old cert because it was
not looking at the correct directory.

Run this in both an IRB and under your Rails console to verify that they are
the same values.

```
require "openssl"
puts OpenSSL::OPENSSL_VERSION
puts "SSL_CERT_FILE: %s" % OpenSSL::X509::DEFAULT_CERT_FILE
puts "SSL_CERT_DIR: %s" % OpenSSL::X509::DEFAULT_CERT_DIR
```

If they are different values, you may need to add this to your development environment
file:

```
SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
SSL_CERT_DIR=/usr/local/etc/openssl/certs
```
