#= require 'angular'

angular.module 'kagd', []

ApplicationController = ->
  ctrl = @
  ctrl.menuOpen = false

  ctrl.toggleMenu = ->
    ctrl.menuOpen = !ctrl.menuOpen

  ctrl.closeMenu = ->
    ctrl.menuOpen = false

  return

angular.module('kagd').controller 'ApplicationController', ApplicationController
