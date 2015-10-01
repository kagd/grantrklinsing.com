Controller = ($http, API_HOST, jsonHelpers) ->
  ctrl = @
  ctrl.stats = null

  ctrl.shortSha = (sha) ->
    sha.slice(0, 10) if sha

  $http.get "#{ API_HOST }api/github"
    .then (response) ->
      ctrl.stats = jsonHelpers.objectKeysToCamelCase response.data

  return

angular.module('kagd').controller 'GithubController', Controller
Controller.$inject = ['$http', 'API_HOST', 'jsonHelpers']
