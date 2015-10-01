#= require ./json_helpers

ServiceHelpers = (jsonHelpers) ->

  populateObjectFromResponse = (model, data) ->
    formattedData = jsonHelpers.objectKeysToCamelCase(data)

    if Array.isArray(formattedData)
      formattedData.forEach (item) ->
        model.push item
    else
      for own key, value of formattedData
        model[key] = value

  {
    populateObjectFromResponse: populateObjectFromResponse
  }

angular.module('serviceHelpers', ['json-helpers']).factory 'serviceHelpers', ServiceHelpers

ServiceHelpers.$inject = ['jsonHelpers']
