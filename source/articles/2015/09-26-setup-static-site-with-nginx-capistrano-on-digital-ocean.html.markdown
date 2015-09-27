---
title: Setup static site with Nginx & Capistrano on Digital Ocean
date: 2015-09-26 08:02 MDT
tags: nginx, capistrano, digital ocean
published: false
---

# Setup Deploy User
All commands should be run as root unless specified.

adduser deploy

As root, run this command to add your new user to the sudo group:
gpasswd -a deploy sudo
Now your user can run commands with super user privileges!

Switch to new user
su - deploy

## SSH as deploy user
Create a new directory called .ssh and restrict its permissions with the following commands:

```
mkdir .ssh
chmod 700 .ssh
nano .ssh/authorized_keys
```

add your public key: `pbcopy < ~/.ssh/id_rsa.pub`

Now restrict the permissions of the authorized_keys file with this command:

`chmod 600 .ssh/authorized_keys`

# Step 1 — Installing Nginx
sudo apt-get update
Then, install Nginx:

sudo apt-get install curl git-core nginx

located at `/etc/nginx/sites-available/static_site`

```
server {
  root /var/www/static_site/current;
}
```
cd ../sites-enabled

remove "default" from sites-enabled

ln -s ../static_site static_site

"/current" will make more sense in a bit.

```bash
mkdir /var/www/static_site
chown deploy /var/www/static_site
```

# SSH

ssh-keygen -t rsa

Add the key to your deployment keys. (github, bitbucket, etc)

`cat ~/.ssh/id_rsa.pub`

copy output

# Setup Capistrano

`gem 'capistrano', '~> 3.4.0'` add to your Gemfile

```
bundle exec cap install
```

This sets up a cap file and a couple of deploy files

For this site it looks like:

```rb
# deploy.rb
# config valid only for current version of Capistrano
lock '3.4.0'

set :application,   'client_site'
set :repo_url,      'git@github.com:kagd/kagd.github.io.git'
set :scm,           :git
set :user,          "deploy"
set :pty, true
```

```rb
# production.rb
set :application, 'client_site'

## Servers we are going to deploy to ----------------------
server '159.203.78.230', user: 'deploy'

## Server Settings ----------------------------------------
set :deploy_to, "/var/www/client_site"

## Git Configuration Settings -----------------------------
set :branch, "master"
```

```
bundle exec cap -T

# Check if necessary files and directories exist
bundle exec cap production deploy:check
```
