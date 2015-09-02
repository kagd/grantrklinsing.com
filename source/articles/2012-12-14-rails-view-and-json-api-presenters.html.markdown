---
title: Rails View and JSON API Presenters
date: 2012-12-14 05:45 UTC
tags: rails
---

Presenters are essentially a bridge between the model and the view. They allow you to customize the output of a data object without polluting your views with `if`s and `else`s.

READMORE

For instance, let's say we have the following model.

```rb
class Person
  attr_accessible :name, :occupation, :education
end
```

and the following view

```html
Name: <% if @person.name.present? %>
    <%= @person.name %>
  <% else %>
    <%= link_to 'Add a name', edit_name_path %>
  <% end %><br>
Occupation: <% if @person.occupation.present? %>
    <%= @person.occupation %>
  <% else %>
    <%= link_to 'Add a name', edit_occupation_path %>
  <% end %><br>
Education: <% if @person.education.present? %>
    <%= @person.education %>
  <% else %>
    <%= link_to 'Add a name', edit_education_path %>
  <% end %>
```

Our view is getting crowded quickly with all the `if` statements. It would be a lot nicer if we could call `@person.education` and it
would add a link automatically if `education` is blank, without having to add the `if`s each time.

## View Presenter

Here is what we want our view to look when it's finished.

```html
<% present @person do |presenter| %>
  Name: <%= presenter.name %>
  Occupation: <%= presenter.occupation %>
  Education: <%= presenter.education %>
<% end %>
```

That's better. It's shortened, and a lot easier to read. We removed the `if`s and the only piece that we added is the `present` block.
The `present` method is apart of our `application_helper.rb`.

```rb
module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
end
```

It creates a new instance of the `PersonPresenter` and passes in the object, in this case `@person`, and the view block.

Next, we want to create a `BasePresenter` that each individual presenter will inherit from.

```rb
class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end
end
```

The only thing that `initialize` does is create instance variables of `object` and `template` for later use. Now, on to the
`PersonPresenter`.

```rb
class PersonPresenter < BasePresenter
  def name
    if @object.name.present?
      @object.name
    else
      link_to 'Add a name', new_name_path
    end
  end

  def occupation
    if @object.occupation.present?
      @object.occupation
    else
      link_to 'Add a occupation', new_occupation_path
    end
  end

  def education
    if @object.education.present?
      @object.education
    else
      link_to 'Add a education', new_education_path
    end
  end
end
```

This is good, but always calling `@object` is a little ambiguous. It would be better if we could make it explicit by calling
`person.name` instead of `@object.name`, so let's add a few things.

```rb
class PersonPresenter < BasePresenter
  presents :person
  ...
end
```

and

```rb
class BasePresenter
  ...

  private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end
end
```

This basically is saying `person = @object`. So, now we can use `person` instead of `@object`. And now we can finish our `PersonPresenter`.

```rb
class PersonPresenter < BasePresenter
  presents :person

  def name
    if person.name.present?
      person.name
    else
      link_to 'Add a name', new_name_path
    end
  end

  def occupation
    if person.occupation.present?
      person.occupation
    else
      link_to 'Add a occupation', new_occupation_path
    end
  end

  def education
    if person.education.present?
      person.education
    else
      link_to 'Add a education', new_education_path
    end
  end
end
```

But wait, we added `link_to` to the presenter. We will have to add a way to render the anchors. We could include `UrlHelper`, but
let's do it the sexy way, by using `method_missing`.

```rb
class BasePresenter
  ...

  private

  ...

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end
end
```

Remember the instance variable `@template` that we defined in `initialize`? We are sending all `method_missing` calls to the view
(`@template`), where it already has the ability to render links.

There! We now have a way to add attributes to a view without always having to add `if`s each time.

## JSON API Presenter

In the same fashion that views can use presenters, API calls can use presenters too. Although, rather than displaying links, API
calls use custom formats. For instance, when you want to display only a couple model properties, or want to add custom properties.

Let's define a model.

```rb
class Team < ActiveRecord::Base
  attr_accessible :name, :nickname, :location
end
```

If you were to call `Team.first.to_json`, you would get someting similar to this.

```js
{
  city: null,
  created_at: "2012-12-15T02:08:45Z",
  id: 1,
  name: "Green Bay",
  nickname: "Packers",
  updated_at: "2012-12-15T02:08:45Z"
}
```

What if we didn't want to show `created_at` and `updated_at`? Queue the presenters.

```rb
class BasePresenter
  def initialize( resource )
    name = resource.class.to_s.underscore
    self.class.send :define_method, name do
      resource
    end
  end
end
```

The same way we started with view presenters, we create a base API presenter to inherit from. The only parameter it takes is an instance
of a model. Where as the view presenter made you add something like `presents :person` to the presenter, we changed it up and now
it is automatically created. So if we have a instance of `SportsTeam`, `sports_team` will be available for use.

Now, let's create the `TeamPresenter` with a customized format.

```rb
class TeamPresenter < BasePresenter
  def as_json( include_root=false )
    {
      :type => "team",
      :team => {
        :id => team.id,
        :city => team.city,
        :name => team.name,
        :nickname => team.nickname
      }
    }
  end
end
```

There isn't a whole lot of craziness going on here, but now we are only showing the attributes we want. `team` was defined when
initializing the `BasePresenter`.

Any finally, how do we use this bad boy?

```rb
class TeamsController < ApplicationController
  def show
    team = Team.find params[:id]
    render :json => TeamPresenter.new( team ).to_json
  end
end
```

Resources used for this post:

- [http://railscasts.com/episodes/287-presenters-from-scratch](http://railscasts.com/episodes/287-presenters-from-scratch)
- [http://quickleft.com/blog/presenters-as-a-solution-to-asjson-woes-in-rails-apis](http://quickleft.com/blog/presenters-as-a-solution-to-asjson-woes-in-rails-apis)
