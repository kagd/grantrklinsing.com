---
title: Adding 3rd Party Assets to a Rails Gem
date: 2013-01-10 04:54 UTC
tags: ruby, rails, javascript, css
---

I recently began creating a ruby gem that served up my frequently used Javascript and CSS snippets ([utility_box](https://github.com/digitalopera/utility_box)).
Included in those snippets are 3rd party frameworks/libraries dependancies. Queue my problem.

READMORE

Adding my custom CSS and Javascript to the
asset pipeline was pretty simple, but the minute I tried to `//= require` a 3rd pary asset within a file, I would get a *File not found* error.
It drove me nuts. No matter what I tried, it didn't work. I figured that the asset path was relative and I wasn't adding the correct path.
That was not the case. After checking out a few other gems that included 3rd party assets, I discovered the problem. Turns out that,
even though I was adding the dependancy to the gemspec, it still wasn't being included in the pipeline for compilation. It needed to
be required in `lib/utility_box.rb`. The minute I did that, all the `//= require` and `#= require` started to work.
