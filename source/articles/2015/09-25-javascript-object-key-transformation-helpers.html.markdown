---
title: Javascript Object Key Transformation Helpers
date: 2015-09-25 16:33 MDT
tags: javascript, angular
---

There are multiple times when I get data back from the server that is snake_case
and I need it to be camelCase in my Javascript. Here are a couple of helpers I
use to transform Javascript keys.

READMORE

I should note that these helpers are using lodash and an object called StringHelpers
to manipulate the keys.

Here is the StringHelpers module

```coffee
StringHelpers =
  # Capitalize the first letter of the string
  capitalize: (word) ->
    word.charAt(0).toUpperCase() + word.slice(1)

  # Convert the first char to lowercase
  uncapitalize: (word) ->
    word.charAt(0).toLowerCase() + word.slice(1)

  # Titleize a string
  ## foo_bar => Foo Bar
  ## BarFoo => Bar Foo
  titleize: (string) ->
    cleanTitle = string.replace(/[ \-_]+/g, ' ');
    words = cleanTitle.replace(/([A-Z])/g, " $&").trim().split(' ')
    capitalizedWords = words.map (word) ->
      capitalize(word)

    capitalizedWords.join(' ')

  # Converts CamelCase to snake_case
  ## FooBar => foo_bar
  ## fooBar => foo_bar
  underscore: (string) ->
    newString = string.replace /([A-Z])/g, ($1) ->
      "_#{ $1.toLowerCase() }"
    newString.replace(/^_/, '').replace(/-/g, '_')
```

## Convert JS Object Keys to Camel Case (camelCase)

```coffee
objectKeysToCamelCase = (object) ->
  newObj = null

  if _.isArray(object)
    newObj = object.map (item) ->
      objectKeysToCamelCase item

  else if _.isObject(object)
    newObj = {}
    _.forEach object, (value, key) ->
      newKey = StringHelpers.uncapitalize(StringHelpers.titleize(key).replace(/\s+/g,''))
      newObj[newKey] = objectKeysToCamelCase(value)

  else
    newObj = object

  return newObj
```

## Convert JS Object Keys to Snake Case (snake_case)

```coffee
objectKeysToSnakeCase = (object) ->
  newObj = null

  if _.isArray(object)
    newObj = object.map (item) ->
      objectKeysToSnakeCase item

  else if _.isObject(object)
    newObj = {}
    _.forEach object, (value, key) ->
      newKey = StringHelpers.underscore(key).replace(/\s+/g,'')
      newObj[newKey] = objectKeysToSnakeCase(value)

  else
    newObj = object

  return newObj
```

## And All Together in Angular Modules

```coffee
# Lodash Module
angular.module('lodash', [])
  .factory '_', ->
    window._

# StringHelpers Module
StringHelpers = ->
  # Capitalize the first letter of the string
  capitalize = (word) ->
    word.charAt(0).toUpperCase() + word.slice(1)

  # Convert the first char to lowercase
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

angular.module('string-helpers', [])
  .factory 'StringHelpers', StringHelpers

# StringHelpers Module
JsonHelpers = (StringHelpers, _) ->

  objectKeysToCamelCase = (object) ->
    newObj = null

    if _.isArray(object)
      newObj = object.map (item) ->
        objectKeysToCamelCase item

    else if _.isObject(object)
      newObj = {}
      _.forEach object, (value, key) ->
        newKey = StringHelpers.uncapitalize(StringHelpers.titleize(key).replace(/\s+/g,''))
        newObj[newKey] = objectKeysToCamelCase(value)

    else
      newObj = object

    return newObj

  objectKeysToSnakeCase = (object) ->
    newObj = null

    if _.isArray(object)
      newObj = object.map (item) ->
        objectKeysToSnakeCase item

    else if _.isObject(object)
      newObj = {}
      _.forEach object, (value, key) ->
        newKey = StringHelpers.underscore(key).replace(/\s+/g,'')
        newObj[newKey] = objectKeysToSnakeCase(value)

    else
      newObj = object

    return newObj

  return {
    objectKeysToCamelCase: objectKeysToCamelCase,
    objectKeysToSnakeCase: objectKeysToSnakeCase
  }

angular.module('json-helpers', ['string-helpers', 'lodash'])
  .factory 'JsonHelpers', JsonHelpers

JsonHelpers.$inject = ['StringHelpers', '_']
```
