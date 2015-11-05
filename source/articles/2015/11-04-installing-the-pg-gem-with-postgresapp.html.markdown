---
title: Installing the PG Gem with PostgresApp
date: 2015-11-04 21:46 MDT
tags: postgres, ruby
---

If you are having problem installing the pg gem and are using the Postgres app there
is a good chance that the gem can't find the correct configuration for Postgres since
the config file is not availabe in `$PATH`.

READMORE

Try installing the gem with the command below, remembering to change the version
number to your installed version.

```bash
gem install pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.4/bin/pg_config
```
