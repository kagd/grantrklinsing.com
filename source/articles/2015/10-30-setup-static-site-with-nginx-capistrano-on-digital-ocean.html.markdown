---
title: Setup static site with Nginx & Capistrano on Digital Ocean
date: 2015-10-30 08:02 MDT
tags: nginx, capistrano, digital ocean
references: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-14-04, https://www.digitalocean.com/community/tutorials/deploying-a-rails-app-on-ubuntu-14-04-with-capistrano-nginx-and-puma,
---

Setting up a static site on Digital Ocean is pretty simple. First we will create a
user that will run the Capistrano deployment. Then, setup SSH, install Nginx, and
finally run Capistrano. Let's get started!

READMORE

**Note:** All commands should be run as root unless specified. The Digital Ocean
instance setup here is for Ubuntu.

# Setup Deploy User

First let's SSH into the Digital Ocean server and add a new user called *deploy*.

```bash
adduser deploy
```

Then to add your new user to the sudo group

```bash
gpasswd -a deploy sudo
```

Now the *deploy* user can run commands with super user privileges!

Switch to new user for the following commands

```bash
su - deploy
```


# Setup SSH as the deploy user

Create a new directory called .ssh and restrict its permissions with the following commands:

```bash
mkdir .ssh
# set permissions so deploy can read, write and execute
chmod 700 .ssh
nano .ssh/authorized_keys
```

From your local machine, copy your public key `pbcopy < ~/.ssh/id_rsa.pub`,
and then paste it into *authorized_keys*. Save and close.

Now restrict the permissions of the authorized_keys file with this command:

```bash
chmod 600 .ssh/authorized_keys
```

You will now be able to SSH into your server as the *deploy* user.

# Generate a server public key from Capistrano deployment

On the server run `ssh-keygen -t rsa` and follow the prompts.

Then add the server key to your git repo host (github, bitbucket, etc) deployment keys.

`cat ~/.ssh/id_rsa.pub` will display the public key.


# Install Nginx

Update out-of-date packages

```bash
sudo apt-get update
```

Then, install Nginx:

```bash
sudo apt-get install curl git-core nginx
```


# Configure Nginx to run the site

Create a file named *static_site* under Nginx

```bash
cd /etc/nginx/sites-available
nano static_site
```

Then add this config to the file

```
server {
  root /var/www/static_site/current;
}
```

`/var/www/static_site/current` is the path where the site files will live. We
will manually create the *static_site* directory later and Capistrano will create
the *current* directory during deployment.

Next, we will enable the site and remove the default Nginx config.

```bash
cd ../sites-enabled
ln -s ../sites-available/static_site static_site
rm default
```
And, create the base directory for the site files and change permissions to
be owned by deploy.

```bash
mkdir /var/www/static_site
chown deploy /var/www/static_site
```

# Capistrano

Add Capistrano to you Gemfile

```rb
gem 'capistrano', '~> 3.4.0'
```

and run

```bash
bundle install
```

Capistrano needs a couple of directories and files so let's run

```bash
cap install
```

Add the following to the generated `deploy.rb` file, remembering to update the repo_url.

```rb
# deploy.rb
# config valid Capistrano 3.4.x
lock '3.4.0'

set :application,   'static_site'
set :repo_url,      'git@<repoUrlHere>'
set :scm,           :git
set :user,          "deploy"
set :pty,           true
```

Copy this to your `production.rb` file and update the server IP address.

```rb
# production.rb
set :application, 'static_site'

## Servers we are going to deploy to ----------------------
server 'xxx.xxx.xxx.xxx', user: 'deploy'

## Server Settings ----------------------------------------
set :deploy_to, "/var/www/static_site"

## Git Configuration Settings -----------------------------
set :branch, "master" # set to your desired branch
```

## Test out Capistrano

Check if necessary files and directories exist. If they don't, Capistrano will create
them.

```bash
bundle exec cap production deploy:check
```

## Deploy your App

```bash
bundle exec cap production deploy
```
