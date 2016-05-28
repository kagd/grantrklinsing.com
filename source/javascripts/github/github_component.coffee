#= require ./github_service

Controller = (githubService, $sce, activityService) ->
  ctrl = @
  ctrl.activity = activityService.init()
  ctrl.activity.start()
  githubService.get()
    .then ( response ) ->
      ctrl.stats = response.data

    .finally ->
      ctrl.activity.stop()

  ctrl.shortSha = (sha) ->
    sha.slice(0, 10) if sha

  ctrl.lastCommitMessage = ->
    $sce.trustAsHtml("\"#{ctrl.stats.lastCommit.message}\"")

  return

Controller.$inject = ['githubService', '$sce', 'activityService']
angular.module('kagd').component('kagdGithub', {
  templateUrl: '/templates/github/github_component.html',
  controller: Controller
});
