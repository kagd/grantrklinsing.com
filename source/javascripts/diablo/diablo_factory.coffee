Factory = ->
  heroes = []
  profile = {}

  return {
    heroes: heroes
    profile: profile
  }

angular.module('kagd').factory 'diabloFactory', Factory
