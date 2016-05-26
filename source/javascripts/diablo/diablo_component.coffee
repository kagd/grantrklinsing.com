Controller = (diabloService) ->
  ctrl = @
  response = diabloService.get()
  ctrl.heroes = response.heroes
  ctrl.profile = response.profile

  ctrl.heroClasses = (hero) ->
    "#{ hero.class }-#{ hero.gender }"

  container = document.getElementById('heroes-wrapper');
  Ps.initialize(container);

  return

Controller.$inject = ['diabloService']
angular.module('kagd').component('kagdDiablo', {
  templateUrl: '/templates/diablo/diablo_component.html',
  controller: Controller
});
