#= require_self
#= require_tree ./modules
#= require_tree ./menu
#= require_tree ./diablo
#= require_tree ./github
#= require_tree ./stack_overflow
#= require_tree ./tags_actionsheet
#= require ./activity/application

angular.module 'kagd', [
  'serviceHelpers',
  'perfect_scrollbar',
  'liveType',
  'perfectScrollbar',
  'kagd.activity'
]

.constant 'API_HOST', window.env.API_HOST
