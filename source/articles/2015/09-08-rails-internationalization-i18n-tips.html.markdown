---
title: Rails Internationalization (I18n) Tips
date: 2015-09-08 02:12 UTC
tags: rails, i18n
---

Internationalization (I18n) in Rails is a pretty simple concept. Just create a YML
file with your translations and Rails will slurp them in for the various languages
that you support. The problem is that the documentation leaves a little to be desired.
Here are just a few tips that I have used.

READMORE

## activemodel instead of activerecord

I use activerecord and mongoid on a daily basis and while most of the documentation
of Rails I18n shows `en.activerecord`, use `en.activemodel` instead. No matter if
you are using mongoid or activerecord or a non-persisted form object, they both all
use activemodel.

```yml
# /config/locales/en.yml
en:
  activemodel: # Notice how this is not activerecord
    attributes:
      user:
        name: Full Name
    models:
       user: User
```

## i18n_key

I have had more than a few occasions where I was wondering what the i18n path was
for an attribute on a form object, mongoid model, and active model. Here is a
simple helper to get the model portion of the path:

```rb
Forms::UserForm.model_name.i18n_key #=> forms/user_form
```

This information can be useful for debugging purposes and show you how the model
yml needs to be setup. Here is a yml example:

```yml
# /config/locales/en.yml
en:
  activemodel:
    attributes:
      forms/user_form:
        name: Full Name
    models:
       forms/user_form: User
```

While this only gives a partial path, it is a good starting point if you are lost.

## Translations for a single page

Most of the Rails I18n docs show translations for models and attributes. But as
you start putting you app together you will need to display copy that is not a
model or attribute value. To get the translation for the current file, you just
use a period before the key. So if the translation key you want to use is "headline",
you would put a dot (.) in front of headline:

```rb
# /app/views/users/show.html.erb
t('.headline')
```

Assuming the file calling this is located `/app/views/users/show.html.erb`, our yml
file will look like:

```yml
# /config/locales/en.yml
en:
  users:
    show:
      headline: User show page
```
