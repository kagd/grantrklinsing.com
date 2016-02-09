#= require ./string_helpers
'use strict'

Helpers = (stringHelpers) ->

  objectKeysToCamelCase = (object) ->
    newObj = null

    if Array.isArray(object)
      newObj = object.map (item) ->
        objectKeysToCamelCase item

    else if object instanceof(Object)
      newObj = {}

      for own key, value of object
        newKey = stringHelpers.uncapitalize(stringHelpers.titleize(key).replace(/\s+/g,''))
        newObj[newKey] = objectKeysToCamelCase(value)

    else
      newObj = object

    return newObj

  objectKeysToSnakeCase = (object) ->
    newObj = null

    if Array.isArray(object)
      newObj = object.map (item) ->
        objectKeysToSnakeCase item

    else if _.isObject(object)
      newObj = {}
      for own key, value of object
        newKey = stringHelpers.underscore(key).replace(/\s+/g,'')
        newObj[newKey] = objectKeysToSnakeCase(value)

    else
      newObj = object

    return newObj

  return {
    objectKeysToCamelCase: objectKeysToCamelCase,
    objectKeysToSnakeCase: objectKeysToSnakeCase
  }

angular.module('jsonHelpers', ['stringHelpers'])
  .factory 'jsonHelpers', Helpers
Helpers.$inject = ['stringHelpers']
