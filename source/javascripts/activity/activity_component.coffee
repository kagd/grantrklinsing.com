# source/javascripts/activity/activity_component.coffee

Controller = ( $scope, activityService ) ->
  ctrl = @
  ctrl.active = activityService.isActive

  return null

Controller.$inject = [ '$scope', 'activityService']

angular.module('kagd.activity').component 'kagdActivity', {
  bindings:
    id: '=id'
  controller: Controller
  template: '
    <div class="activity-container" ng-if="$ctrl.active( $ctrl.id )">
      <span class="bar"></span>
    </div>
  '
}
