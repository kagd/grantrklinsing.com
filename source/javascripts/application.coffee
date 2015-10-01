#= require_self
#= require env
#= require_tree ./modules
#= require_tree ./diablo
#= require_tree ./github

angular.module 'kagd', ['foundation', 'serviceHelpers', 'perfect_scrollbar']

ApplicationController = ->
  ctrl = @
  ctrl.menuOpen = false

  ctrl.toggleMenu = ->
    ctrl.menuOpen = !ctrl.menuOpen

  ctrl.closeMenu = ->
    ctrl.menuOpen = false

  return

angular.module('kagd').controller 'ApplicationController', ApplicationController

angular.module('kagd').run ($templateCache) ->
  $templateCache.put 'components/actionsheet/actionsheet.html', '<div class="action-sheet-container" ng-transclude></div>'

  $templateCache.put 'components/actionsheet/actionsheet-button.html', '
    <div>
      <a href="#" class="button" ng-if="title.length > 0">{{ title }}</a>
      <div ng-transclude></div>
    </div>'

  $templateCache.put 'components/actionsheet/actionsheet-content.html', '
    <div class="action-sheet {{ position }}" ng-class="{\'is-active\': active}">
      <div ng-transclude></div>
    </div>'
