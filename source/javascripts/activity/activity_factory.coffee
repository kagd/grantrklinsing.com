# source/javascripts/activity/activity_factory.coffee

Factory = ->
  _store = {}

  get = ( id ) ->
    return _store[id] == true

  start = ( id ) ->
    return _store[id] = true

  end = ( id ) ->
    return _store[id] = false

  return {
    get: get
    start: start
    end: end
    init: end
  }

angular.module('kagd.activity').factory('activityFactory', Factory)
