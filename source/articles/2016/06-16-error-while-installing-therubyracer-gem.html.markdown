---
title: Error while installing therubyracer gem
date: 2016-06-16 10:03 MDT
tags: ruby
---

This article is related to [Error while installing libv8 gem](/articles/2016/06/16/error-while-installing-libv8-gem.html).

If you ran into this error `ERROR: Failed to build gem native extension` or
something the like, I found a solution.

You can use the Libv8 from the brew instead of the one from gem. You can do that by following commands:

```
$ gem uninstall libv8
$ brew install v8
$ gem install therubyracer
```

Reference:
[http://stackoverflow.com/questions/11598655/therubyracer-install-error](http://stackoverflow.com/questions/11598655/therubyracer-install-error)
