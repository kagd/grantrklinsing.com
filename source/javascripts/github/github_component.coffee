#= require ./github_service

Controller = (githubService, $sce) ->
  ctrl = @
  response = githubService.get()
  ctrl.stats = response.stats

  ctrl.shortSha = (sha) ->
    sha.slice(0, 10) if sha

  ctrl.lastCommitMessage = ->
    $sce.trustAsHtml("\"#{ctrl.stats.lastCommit.message}\"")

  return

Controller.$inject = ['githubService', '$sce']
angular.module('kagd').component('kagdGithub', {
  templateUrl: '/templates/github/github_component.html',
  controller: Controller
});
