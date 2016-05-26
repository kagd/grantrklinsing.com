#= require ../modules/service_helpers

Service = ($http, githubFactory, serviceHelpers, API_HOST) ->
  service = @

  service.get = ->
    $http.get "#{ API_HOST }api/github"
      .then (response) ->
        serviceHelpers.populateObjectFromResponse(githubFactory.stats, response.data)

    {
      stats: githubFactory.stats
    }

  return service

angular.module('kagd').service 'githubService', Service
Service.$inject = ['$http', 'githubFactory', 'serviceHelpers', 'API_HOST']
