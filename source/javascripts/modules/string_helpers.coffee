'use strict'

Helpers = ->
  # Capitalize the first letter of the string
  capitalize = (word) ->
    word.charAt(0).toUpperCase() + word.slice(1)

  # Convert the first char to losercase
  uncapitalize = (word) ->
    word.charAt(0).toLowerCase() + word.slice(1)

  # Titleize a string
  ## foo_bar => Foo Bar
  ## BarFoo => Bar Foo
  titleize = (string) ->
    cleanTitle = string.replace(/[ \-_]+/g, ' ');
    words = cleanTitle.replace(/([A-Z])/g, " $&").trim().split(' ')
    capitalizedWords = words.map (word) ->
      capitalize(word)

    capitalizedWords.join(' ')

  # Converts CamelCase to snake_case
  ## FooBar => foo_bar
  ## fooBar => foo_bar
  underscore = (string) ->
    newString = string.replace /([A-Z])/g, ($1) ->
      "_#{ $1.toLowerCase() }"
    newString.replace(/^_/, '').replace(/-/g, '_')

  return {
    capitalize: capitalize
    uncapitalize: uncapitalize
    titleize: titleize
    underscore: underscore
  }

angular.module('stringHelpers', [])
  .factory 'stringHelpers', Helpers
