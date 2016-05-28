# source/javascripts/activity/activity_service.coffee

Service = ( activityFactory, ACTIVITY_EVENTS, $rootScope ) ->
  _service = @

  ActivityIndicator = ( id ) ->
    indicator = @
    indicator.id = id
    indicator.start = ->
      _service.start( id )
    indicator.stop = ->
      _service.end( id )
    indicator.isActive = ->
      _service.isActive( id )

    return @

  _service.init = ( id ) ->
    _id = id || (Math.random() * (100000 - 10000) + 10000).toString()
    activityFactory.init( _id )
    return new ActivityIndicator( _id )

  _service.start = ( id ) ->
    activityFactory.start( id )
    _broadcast( ACTIVITY_EVENTS.init, id )

  _service.isActive = ( id ) ->
    activityFactory.get( id )

  _service.end = ( id ) ->
    activityFactory.end( id )
    _broadcast( ACTIVITY_EVENTS.complete, id )

  # PRIVATE #############################################################

  _broadcast = ( eventName, id ) ->
    $rootScope.$broadcast eventName, { id: id  }

  return _service

Service.$inject = ['activityFactory', 'ACTIVITY_EVENTS', '$rootScope']

angular.module('kagd.activity').service 'activityService', Service
