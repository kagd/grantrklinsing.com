Controller = ->
  ctrl = @
  ctrl.open = false
  ctrl.toggle = ->
    ctrl.open = !ctrl.open

  return

angular.module('kagd').component('kagdTagsActionsheet', {
  templateUrl: '/templates/tags_actionsheet/tags_actionsheet_component.html',
  controller: Controller
});
