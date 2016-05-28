Controller = (diabloService, Ps, activityService, $timeout) ->
  ctrl = @
  ctrl.activity = activityService.init()

  ctrl.activity.start()
  diabloService.get()
    .then ( response ) ->
      ctrl.heroes = response.data.heroes
      ctrl.profile = response.data.profile
      ctrl.activity.stop()
      $timeout ->
        container = document.getElementById('heroes-wrapper');
        Ps.initialize(container);
      , 100
    .finally ->
      ctrl.activity.stop()

  ctrl.heroClasses = (hero) ->
    "#{ hero.class }-#{ hero.gender }"

  return

Controller.$inject = ['diabloService', 'Ps', 'activityService', '$timeout']
angular.module('kagd').component('kagdDiablo', {
  templateUrl: '/templates/diablo/diablo_component.html',
  controller: Controller
});
