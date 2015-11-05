---
title: Simulate Cursor Typing with Angular
date: 2015-11-05 00:20 MST
tags: angular
---

Create the illusion of dynamic typing with a simple Angular directive.

READMORE

Here it is in action. (You may need to reload the page to see it fully)

<pre>
<h3 livetype="javascript"></h3>
</pre>

This can be accomplished with a simple directive

```coffee
Directive = ($timeout) ->
  getRandomMs = (min, max) ->
    Math.floor(Math.random() * (max - min)) + min

  link = (scope) ->
    scope.string = ''

    # Split the string into an array
    chars = scope.livetype.split('')

    # the loop to create the typing illusion
    chars.reduce (lastMs, currentChar, idx) ->
      newMs = lastMs + getRandomMs(50, 750)

      $timeout ->
        scope.string += currentChar
      , newMs

      return newMs
    , 0

  {
    link: link
    restrict: 'A'
    scope:
      livetype: '@livetype'
    template: '{{ string }}<span class="livetype-cursor">|</span>'
  }

angular.module('liveType', []).directive 'livetype', Directive
Directive.$inject = ['$timeout']
```

The HTML

```html
<h4 livetype="javascript"></h4>
```

And don't forget out the CSS for the cursor blink

```css
@keyframes livetype-cursor-blink {
  0%   { opacity: 0; }
  50%  { opacity: 1; }
  100% { opacity: 0; }
}
.livetype-cursor {
  animation: livetype-cursor-blink 750ms infinite;
}
```

<style type="text/css">
@keyframes livetype-cursor-loop {
  0%   { opacity: 0; }
  50%  { opacity: 1; }
  100% { opacity: 0; }
}
.livetype-cursor {
  animation: livetype-cursor-loop 750ms infinite;
}
</style>
