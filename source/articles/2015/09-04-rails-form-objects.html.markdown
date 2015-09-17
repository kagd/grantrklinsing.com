---
title: Rails Form Objects
date: 2015-09-04 02:22 MDT
tags: rails
---

Form objects are a pretty simple. If you are familiar with ActiveRecord models, then you
can work with form objects. Essentially, a form object is a non-persisted model. They
allow you to run validations on specific properties of a separate, persisted model.

READMORE

## Why should I use a form object?

Form objects are a great solution when you have a model that has a bunch of if/else
logic on validations. For instance, if you have an admin section that allows for
the creation of a `User` model. Here is that model:

```rb
# located /app/models/user.rb
class User < ActiveRecord::Base
  validates :first_name,
            :last_name,
            :phone_number,
            :email,
            :password,
            :password_confirmation,
            presence: true
end
```

The admin can create the entire user so all of the validations should be run on save.

Now, let's assume that there are non-admins that can update an user but don't have the
rights to change emails and passwords. You could do something like:

```rb
# located /app/models/user.rb
class User < ActiveRecord::Base
  attr_accessor :admin_update
  validates :email,
            :password,
            :password_confirmation,
            presence: true,
            if: Proc.new{ admin_update == true  }

  validates :first_name,
            :last_name,
            :phone_number
            presence: true
end
```

We added an `attr_accessor` to create a non-persisted property that we check each time
to require `:email`, `:password` and `:password_confirmation` if being updated by an admin.

There are two down side here. You have now created logic in your base model that has nothing
to do with the model itself. It has to do with your business logic. And, you now
have to do this `user.admin_update = true` in any section updating the user by an admin.
This may be a bad example since email and password is typically only updated in one or
two spots anyway, but you can see my point.

## Get to the Form Ojects Already!

So, rather than creating a bunch of spaghetti logic within your models, use a form object.
Non-admins can only update `:first_name`, `:last_name`, and `:phone_number`, so those
are the only attributes within the form object.

```rb
# located /app/forms/user.rb
module Forms
  class User
    include ActiveModel::Model

    attr_accessor :first_name, :last_name, :phone_number
    validates :first_name, :last_name, :phone_number, presence: true
    validates :phone_number,
              length: {
                is: 10
              },
              numericality: {
                only_integer: true
              }

    def initialize(attrs={})
      attrs.each do |key, value|
        send("#{key}=", value)
      end
    end

    def attributes
      {
        first_name: first_name,
        last_name: last_name,
        phone_number: phone_number
      }
    end

    def save_to(user)
      if valid?
        user.assign_attributes attributes
        user.save validate: false
      else
        false
      end
    end
  end
end

```

There is a little bit that we should go over here.

First, we just set up a simple Ruby object and include `ActiveModel::Model`. This
is what give us our validations.

Next we setup our non-persisted attributes with `attr_accessor`. After that, a few
validations. Both of which should look familiar to you if you work with Rails.

`initialize` is just iterating over each attribute passed in and setting it on the
form object. This is similar to how `User.build` works. Here is an example:

```rb
user = User.find params[:id]
form = Forms::User.new first_name: user.first_name, last_name: user.last_name
```

Unfortunately, since we are just using `attr_accessor` we don't have anyway to
get the collection of attributes as a hash. So we have to define the attributes
method.

And finally, `save_to` allows us to save our valid form object back to the parent
user. Notice we use `validate: false` because we don't want to trigger an email
validation when the current non-admin can't do anything about it.

## Examples

```rb
user = User.find params[:id]
form = Forms::User.new phone_number: '5555555555'
form.save_to user #=> false
form.errors #=> #<ActiveModel::Errors:0x007fd5c8814020 @base=#<Forms::User:0x007fd5c884cc90 @phone_number="5555555555", @validation_context=nil, @errors=#<ActiveModel::Errors:0x007fd5c8814020 ...>>, @messages={:first_name=>["can't be blank"], :last_name=>["can't be blank"]}>
form.first_name = 'Grant'
form.last_name = 'Klinsing'
form.valid? #=> true
form.save_to user #=> true
user.first_name #=> "Grant"
```

## Validation Callbacks

In most cases you will only need to add `include ActiveModel::Model`.
If you would like to run `before_validation` and/or `after_validation` just include
`ActiveModel::Validations::Callbacks` after `include ActiveModel::Model`.

```rb
# located /app/forms/user.rb
module Forms
  class User
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    #...
    before_validation :clean_phone_number
    #...

    private #-------------------------------------------------------

    def clean_phone_number
      @phone_number = @phone_number.scan(/\d+/).join('')
    end
  end
end

```

Now our `clean_phone_number` method allow phone_number to only be validated against
the numbers so our numericality check will not fail.
