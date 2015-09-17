---
title: Building and Installing MongoDB on Ubuntu 10.04
date: 2012-01-05 05:01 MDT
tags: mongodb, ubuntu
---

Install debs required to build Mongo:

READMORE

```bash
$ sudo aptitude install tcsh git-core scons g++ libpcre++-dev libboost-dev libreadline-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-date-time-dev
```

Checkout mongo sourcecode:

```bash
git clone git://github.com/mongodb/mongo.git
```

Download and Build Spidermonkey

```bash
$ wget ftp://ftp.mozilla.org/pub/mozilla.org/js/js-1.7.0.tar.gz
$ tar zxvf js-1.7.0.tar.gz
$ mv js/src mongo/js
$ cd mongo/js
$ export CFLAGS="-DJS_C_STRINGS_ARE_UTF8"
$ make -f Makefile.ref
$ sudo env JS_DIST=/usr make -f Makefile.ref export
$ cd ..
```

Build and install MongoDB

```bash
$ scons all
$ sudo scons --prefix=/opt/mongo install
```

Mongo is now ready to run under `/opt/mongo/bin/mongod`
