Controller = ($http, $sce, activityService) ->
  ctrl = @
  ctrl.answers = []
  ctrl.questions = []
  ctrl.activity = activityService.init()

  ctrl.toHTML = ( str ) ->
    $sce.trustAsHtml( str )

  ctrl.activity.start()
  $http.get('https://api.stackexchange.com/2.2/users/1329299/answers?key=U4DMV*8nvpm3EOpvf69Rxw((&site=stackoverflow&order=desc&sort=activity&filter=default')
    .then ( response ) ->
      ctrl.answers = response.data.items
      ids = ctrl.answers.map (answer) -> answer.question_id

      $http.get("https://api.stackexchange.com/2.2/questions/#{ ids.join(';') }?order=desc&sort=activity&site=stackoverflow")
        .then ( response ) ->
          ctrl.questions = response.data.items
          ctrl.questions.forEach (question) ->
            ctrl.answers.forEach (answer) ->
              if answer.question_id == question.question_id
                question.answer = answer

        .finally ->
          ctrl.activity.stop()

    .finally ->
      ctrl.activity.stop()

  return

Controller.$inject = ['$http', '$sce', 'activityService']
angular.module('kagd').component('kagdStackOverflow', {
  templateUrl: '/templates/stack_overflow/stack_overflow_component.html',
  controller: Controller
});
