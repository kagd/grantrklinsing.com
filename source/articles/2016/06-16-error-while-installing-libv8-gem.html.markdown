---
title: Error while installing libv8 gem
date: 2016-06-16 09:55 MDT
tags: ruby
---

While installing libv8 gem during a bundle install I ran into this error:

```
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.
```

This is due to the fact that OS X 10.9+ is using version 4.8 of GCC. This is not
supported officially in older versions of libv8.

Here is the fix:

`gem install libv8 -v '3.16.14.13' -- --with-system-v8`

Reference: [http://stackoverflow.com/questions/19577759/installing-libv8-gem-on-os-x-10-9](http://stackoverflow.com/questions/19577759/installing-libv8-gem-on-os-x-10-9)
