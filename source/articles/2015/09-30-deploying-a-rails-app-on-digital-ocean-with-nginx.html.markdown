---
title: Deploying a Rails App on Digital Ocean with Nginx
date: 2015-09-30 18:41 MDT
tags: nginx, rails
published: false
references: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-14-04, https://www.digitalocean.com/community/tutorials/deploying-a-rails-app-on-ubuntu-14-04-with-capistrano-nginx-and-puma, https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-14-04  
---

# Create Droplet

# Setup Deploy User
All commands should be run as root unless specified.

adduser demo

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

# Step 3 — Installing RVM and Ruby
We won't be installing Ruby directly. Instead, we'll use a Ruby Version Manager. There are lots of them to choose from (rbenv, chruby, etc.), but we'll use RVM for this tutorial. RVM allows you to easily install and manage multiple rubies on the same system and use the correct one according to your app. This makes life much easier when you have to upgrade your Rails app to use a newer ruby.

Before installing RVM, you need to import the RVM GPG Key:

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
Then install RVM to manage our Rubies:

curl -sSL https://get.rvm.io | bash -s stable

# install postgres  

sudo apt-get install postgresql postgresql-contrib


# Step 1 — Installing Nginx
Once the VPS is secure, we can start installing packages. Update the package index files:

sudo apt-get update
Then, install Nginx:

sudo apt-get install curl git-core nginx -y
