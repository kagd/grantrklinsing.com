---
title: "How to fix OpenSSL::SSL::SSLError: certificate verify failed"
date: 2015-10-07 17:23 MDT
tags: rvm, ssl
---

If you are using RVM, make sure to install Ruby versions without binaries. I'm
not sure why this works, but it does. The crappy part is that you have to do this
on every version bump of Ruby... boo.

`rvm install ruby-2.2.2 --without-binaries`
