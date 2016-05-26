#= require ./github_service

Controller = (githubService) ->
  ctrl = @
  response = githubService.get()
  ctrl.stats = response.stats

  ctrl.shortSha = (sha) ->
    sha.slice(0, 10) if sha

  return

Controller.$inject = ['githubService']
angular.module('kagd').component('kagdGithub', {
  templateUrl: '/templates/github/github_component.html',
  controller: Controller
});
