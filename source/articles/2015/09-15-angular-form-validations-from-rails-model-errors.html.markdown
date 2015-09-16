---
title: Angular Form Validations from Rails Model Errors
date: 2015-09-15 23:25 UTC
tags: angular, rails
---

I love Rails for it's baked in model validations. I love Angular for the simplicity.
Together, you can keep your data validations on the server and update the angular
forms with something that is familiar to Rails devs, convention over configuration.

READMORE

First, let's start with the Rails model.

```ruby
class InventoryItem < ActiveRecord::Base
  validates :price, presence: true
end
```

We have a `InventoryItem` model that has a validation for presence. Since you are
familiar with Rails validations, you know that if try to save your flight without
a price you will get an error that looks like this:

```ruby
inventory_item = InventoryItem.new
inventory_item.valid? #=> false
inventory_item.errors.messages #=>  {:price=>["can't be blank"]}
```

We just have to pass the error hash back to the UI as json.

```ruby
class InventoryItemController < ApplicationController
  def create
    @inventory_item = InventoryItem.new params_for_create

    if @inventory_item.save
      # return the item
      render json: @inventory_item
    else
      # Return the inventory_item errors
      render json: { errors: @inventory_item.errors.messages }, status: :conflict
    end
  end

  private #-------------------------

  def params_for_create
    params[:inventory_item]
    params.required(:inventory_item).permit(:price)
  end
end
```

Now let's create the Angular controller and view that will handle the error
response.

```coffee
angular.module('myApp', ['error-helpers']) # error-helpers will be defined in just a bit

# Define controller
InventoryItemController = ($http, ErrorHelpers)->
  ctrl = @
  # bind the methods from ErrorHelpers.setupErrorHelpers to this controller
  ErrorHelpers.setupErrorHelpers.call(ctrl)
  # Setup new model
  ctrl.inventoryItem = {
    price: null
  }

  ctrl.onSubmit = ->
    # clear any errors that were set on a previous submit
    ctrl.clearErrors()

    $http.post '/api/inventory_items', ctrl.inventoryItem
      .then (response) ->
        # do whatever you need to
      .catch (response) ->
        # populate the errors object
        ctrl.populateErrors(response.data.errors)

angular.module('myApp').controller 'InventoryItemController', InventoryItemController
InventoryItemController.$inject = ['$http', 'ErrorHelpers']

# Define ErrorHelpers
ErrorHelpers = ->
  helper = @
  helper.setupErrorHelpers = ->
    binding = @
    binding.errors = {}

    binding.populateErrors = (errors) ->
      for own key, value of errors
        binding.errors[key] = value

    binding.clearErrors = ->
      for own key, value of binding.errors
        delete binding.errors[key]

  return helper

angular.module('error-helpers', [])
  .service 'ErrorHelpers', ErrorHelpers

```

For the HTML I will just use some Bootstrap markup:

```html
<form ng-submit="itemCtrl.onSubmit()" ng-controller="InventoryItemController as itemCtrl">
  <!--
    when itemCtrl.errors.price is present add 'has-class' to .form-group
  -->
  <div class="form-group" ng-class="{ 'has-error': itemCtrl.errors.price }">
    <label for="price">Item Price</label>
    <input type="text" id="price" ng-model="itemCtrl.inventoryItem.price">
    <!--
      when itemCtrl.errors.price is present display .help-block
    -->
    <p class="help-block" ng-if="itemCtrl.errors.price">{{ itemCtrl.errors.price.join(', ') }}</p>
  </div>
</form>
```

This could definitely use a directive but rather than abstract it for this example,
I chose simplicity.

This will interpolate your Rails model errors when they are returned from the server
and apply the Bootstrap `has-error` class to the markup to highlight the error.
