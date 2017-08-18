set :application, 'client_site'
# set :state,       :production

## Servers we are going to deploy to ----------------------
server '138.197.1.41', user: 'deploy'

## Server Settings ----------------------------------------
set :deploy_to, "/var/www/client_site"

## Git Configuration Settings -----------------------------
set :branch, "master"
