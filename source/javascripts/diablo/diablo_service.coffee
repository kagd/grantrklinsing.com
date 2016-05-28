#= require ../modules/service_helpers

Service = ($http, API_HOST) ->
  service = @

  service.get = ->
    $http.get "#{ API_HOST }api/diablo"

  return service

angular.module('kagd').service 'diabloService', Service
Service.$inject = ['$http', 'API_HOST']
