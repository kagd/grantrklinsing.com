---
title: Angular Services Without Promises
date: 2015-08-27 03:02 UTC
tags: angular, scheming
---

Services in Angular.js are a great tool for abstraction and re-use. They pull a resource
from the server via a promise and then your code handles the resolve. The problem here
is that all controllers, directives or whatever that handles the promise has to be setup
to assign the data on resolve.

But wouldn't it be great to have your service return the data inline without having
to handle the promise each time? While maintaining the asynchronous nature of services?

READMORE

This can be accomplish with a combination of an Angular service and a Javascript schema generator
called [Scheming](https://github.com/autoric/scheming).

Let's assume we have an order service that retrieves an order by ID.

```coffee
OrdersService = ($http) ->
  @get = (id) ->
    $http.get "api/orders/#{ id }"

  return @

angular.module('myApp')
  .service 'OrdersService', OrdersService

OrdersService.$inject = ['$http']
```

Nothing out of the ordinary here. This is using promises to retrieve the data and we will
have to handle the resolve it in our controller. So let's change it so the service
returns a data object and still pulls the requested resource.

First, we create a Scheming `Order` model:

```coffee
Order = ($window) ->
  scheming = $window.Scheming

  scheming.create
    id: scheming.TYPES.Integer
    createdAt: scheming.TYPES.Date
    complete: scheming.TYPES.Boolean

angular.module('myApp').factory 'Order', Order

Order.$inject = ['$window']
```

This model should have all the fields that you need to represent in the view.

Next, we need to update our service to use the `Order` model:

```coffee
OrdersService = ($http, Order) ->
  populateModelFromResponse = (model, data) ->
    data.forEach (value, key) ->
      model[key] = value

  @get = (id) ->
    order = new Order()
    $http.get "api/orders/#{ id }"
      .then (response) ->
        populateModelFromResponse(order, response.data)

    return order

  return @

angular.module('myApp')
  .service 'OrdersService', OrdersService

OrdersService.$inject = ['$http', 'Order']
```

Let's go over the `get` method first. Instead of returning a promise, we are now
returning a new instance of `Order`. That means that controller doesn't need to
handle the response because it will already have an object. Just an empty one.

Now, since an object was returned in the service, any views interpolating a
property of the `Order` model will be automatically updated. This does mean that
there may be a delay between when the call is made and when the model is populated.
So there may be empty view since the data doesn't exist until there is a response.

I suppose `populateModelFromResponse` should be moved into it's own helper to be used
in all the other services as well. But I will let you figure that one out.

If you are wondering how to make this call in your controllers, you can simply do
this:

```coffee
@order = OrdersService.get(123)
```

rather than this:

```coffee
ctrl = @
ctrl.order = {}

OrdersService.get(123).then (response) ->
  ctrl.order = response.data
```

After all this you are probably thinking, "I don't need to use Scheming at all. I
can just use pojo (plain old Javascript objects)." And, you are correct. What Scheming
get's you is a great way to validate a model on the client side. :)
