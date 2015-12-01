Directive = ( $rootScope ) ->

  link = ( scope, element ) ->
    menuOpen = false

    element.on 'click', ->
      menuOpen = !menuOpen
      message = if menuOpen then 'open' else 'close'
      $rootScope.$broadcast( 'menuToggle', message )

  return {
    restrict: 'EA'
    link: link
  }

angular.module('kagd').directive 'menuButton', Directive
Directive.$inject = ['$rootScope']
