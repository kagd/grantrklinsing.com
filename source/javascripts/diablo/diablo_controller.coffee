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

angular.module('kagd').controller 'DiabloController', Controller
Controller.$inject = ['diabloService']
