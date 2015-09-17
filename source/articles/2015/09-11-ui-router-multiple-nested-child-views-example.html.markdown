---
title: UI Router Multiple Nested Child Views Example
date: 2015-09-11 05:18 MDT
tags: angular, ui-router
downloads: UI Router Example | 09-11-ui-router-multiple-nested-child-views-example.zip
demos: UI Router Demo | 2015/09-11-ui-router-multiple-nested-child-views-demo.html
---

Since you are here, I am assuming that you are wondering how to setup your angular
app with the [UI Router](https://github.com/angular-ui/ui-router) with child views.

UI Router has a pretty simple setup for full page changes, but is definitely a
little tricky when it comes to child views changes. Not because the concept is
difficult, it's because the documentation leaves a lot to be desired. Luckily
I have gone through the UI Router's wiki pages and have a simple example of child
views in action.

READMORE

Here is our base HTML. Really the only thing you will care about is near the bottom
with the `ui-view`s.

```html
<!DOCTYPE html>
<html>
<head>
  <title>UiRouter</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/foundation/5.5.2/css/foundation.min.css" media="screen" charset="utf-8">
</head>
<body ng-app="myApp">

  <!-- Navigation -->
  <div class="text-center">
    <a ui-sref="app">Root</a>
  </div>
  <div class="row">
    <div class="small-4 columns">
      <ul class="side-nav">
        <li><a ui-sref="app.panelOne.childOne">Panel 1 Child 1</a></li>
        <li><a ui-sref="app.panelOne.childTwo">Panel 1 Child 2</a></li>
      </ul>
    </div>
    <div class="small-4 columns end">
      <ul class="side-nav">
        <li><a ui-sref="app.panelTwo.childOne">Panel 2 Child 1</a></li>
        <li><a ui-sref="app.panelTwo.childTwo">Panel 2 Child 2</a></li>
        <li><a ui-sref="app.panelTwo.childThree">Change panel in a diff parent</a></li>
      </ul>
    </div>
  </div>

  <!-- UI Views -->
  <div class="row">
    <div class="small-4 columns">
      <div ui-view="panelOne"></div>
    </div>
    <div class="small-4 columns">
      <div ui-view="panelTwo"></div>
    </div>
    <div class="small-4 columns">
      <div ui-view="panelThree"></div>
    </div>
  </div>

  <!-- Scripts -->
  <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.5/angular.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.15/angular-ui-router.min.js"></script>
  <script src="myapp.js"></script>

</body>
</html>
```

The `ui-view`s are named so we can target the correct view when inserting the
child views.

The rest is handled by our js.

```js
angular.module('myApp', ['ui.router']);

var Config = function($stateProvider, $urlRouterProvider) {
  $stateProvider.state('app', {
    url: "/",
    views: {
      'panelOne': {
        template: "<h1>Panel 1</h1> <div ui-view='panelOneContent'></div>"
      },
      'panelTwo': {
        template: "<h1>Panel 2</h1> <div ui-view='panelTwoContent'></div>"
      },
      'panelThree': {
        template: "<h1>Panel 3</h1>"
      }
    }
  })

  // Panel One ================================================================
  .state('app.panelOne', {
    abstract: true,
    url: "panel1",
    views: {
      'panelOneContent': {
        template: '<div ui-view="content"></div>'
      }
    }
  })
  .state('app.panelOne.childOne', {
    url: "/child1",
    views: {
      'content': {
        template: 'Panel 1 child 1'
      }
    }
  })
  .state('app.panelOne.childTwo', {
    url: "/child2",
    views: {
      'content': {
        template: 'Panel 1 child 2'
      }
    }
  })

  // Panel Two ================================================================
  .state('app.panelTwo', {
    abstract: true,
    url: "panel2",
    views: {
      'panelTwoContent': {
        template: '<div ui-view="content"></div>'
      }
    }
  })
  .state('app.panelTwo.childOne', {
    url: "/child1",
    views: {
      'content': {
        template: 'Panel 2 child 1'
      }
    }
  })
  .state('app.panelTwo.childTwo', {
    url: "/child2",
    views: {
      'content': {
        template: 'Panel 2 child 2'
      }
    }
  })
  .state('app.panelTwo.childThree', {
    url: "/child3",
    views: {
      'content': {
        template: 'Panel 2 child 3'
      },
      'panelOne@': {
        template: '<h2>This one takes over Panel One</h2>'
      }
    }
  });

  $urlRouterProvider.otherwise("/");
};

angular.module('myApp').config(Config);
Config.$inject = ['$stateProvider', '$urlRouterProvider'];
```

Let's go over the js state by state.

```js
$stateProvider.state('app', {
  url: "/",
  views: {
    'panelOne': {
      template: "<h1>Panel 1</h1> <div ui-view='panelOneContent'></div>"
    },
    'panelTwo': {
      template: "<h1>Panel 2</h1> <div ui-view='panelTwoContent'></div>"
    },
    'panelThree': {
      template: "<h1>Panel 3</h1>"
    }
  }
})
```

`panelOne`, `panelTwo` and `panelThree` match up to the named views we have in
our HTML (`<div ui-view="panelOne"></div>`, `<div ui-view="panelTwo"></div>`  and
`<div ui-view="panelThree"></div>`).

The next state is just setup for adding child views to children.

```js
.state('app.panelOne', {
  abstract: true,
  url: "panel1",
  views: {
    'panelOneContent': {
      template: '<div ui-view="content"></div>'
    }
  }
})
```

`panelOneContent` is the named view in the panelOne template

```js
'panelOne': {
  template: "<h1>Panel 1</h1> <div ui-view='panelOneContent'></div>"
}
```

I will admit this step seems a counterintuitive. Why insert a ui-view inside
another ui-view? Because this is the only way you can add children within children.
UI Router doesn't know where to insert the view content without this step unfortunately.

This next section does the same thing as the last except it is going to insert
it's template in the `app.panelOne` content named view.

```js
.state('app.panelTwo.childOne', {
  url: "/child1",
  views: {
    'content': { // inserted into 'ui-view="content"' in app.panelOne
      template: 'Panel 2 child 1'
    }
  }
})
```

The rest is just rinse and repeat, with one exception, `app.panelTwo.childThree`.

```js
.state('app.panelTwo.childThree', {
  url: "/child3",
  views: {
    'content': {
      template: 'Panel 2 child 3'
    },
    'panelOne@': { // replaces panelOne content
      template: '<h2>This one takes over Panel One</h2>'
    }
  }
});
```

In addition to updating the 'content' view for panel 2, it also populates content
into panelOne. It replaces `<h1>Panel 1</h1> <div ui-view='panelOneContent'></div>`
with `<h2>This one takes over Panel One</h2>`. This is acheived by telling UI Router
to use the absolute path to panelOne with the appended `@`.

I will admit that this example is far from a real-life implementation, but it should
show you how to use child views.
