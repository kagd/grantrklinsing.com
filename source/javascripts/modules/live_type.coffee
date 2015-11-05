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
    template: '{{ string }}<span class="livetype-cursor">|</span>'
    scope: {
      livetype: '@livetype'
    }
  }

angular.module('liveType', []).directive 'livetype', Directive
Directive.$inject = ['$timeout']
