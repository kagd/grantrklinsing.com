#= require ../modules/service_helpers

Service = ($http, diabloFactory, serviceHelpers, API_HOST) ->
  service = @

  service.get = ->
    $http.get "#{ API_HOST }api/diablo"
      .then (response) ->
        serviceHelpers.populateObjectFromResponse(diabloFactory.heroes, response.data.heroes)
        serviceHelpers.populateObjectFromResponse(diabloFactory.profile, response.data.profile)

    {
      heroes: diabloFactory.heroes
      profile: diabloFactory.profile
    }

  return service

angular.module('kagd').service 'diabloService', Service
Service.$inject = ['$http', 'diabloFactory', 'serviceHelpers', 'API_HOST']
