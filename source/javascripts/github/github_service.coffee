#= require ../modules/service_helpers

Service = ($http, API_HOST) ->
  service = @

  service.get = ->
    $http.get "#{ API_HOST }api/github"

  return service

angular.module('kagd').service 'githubService', Service
Service.$inject = ['$http', 'API_HOST']
